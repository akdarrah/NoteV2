class Album < ActiveRecord::Base
  include LastFM

  validates_presence_of :title, :artist

  has_attached_file :cover_art, :styles => {:blurred => "100%", :thumb => "40x40#"}, :convert_options => { :blurred => "-blur 0x8" }

  belongs_to :artist
  has_many :album_tracks, :dependent => :destroy
  has_many :tracks, :through => :album_tracks, :order => :position

  after_create :sync_to_remote_data_source
  
  scope :artist_id, lambda {|artist_id = nil|
    where("artist_id = ?", artist_id.to_i)
  }

  def to_s
    title.titlecase
  end

  def description
    self[:description].blank? ? "No description available." : self[:description].gsub("\n", "<br />")
  end

  def as_json(options={})
    super({
      :only => [:id, :description],
      :methods => [:to_s, :cover_art_url, :cover_art_thumb_url],
      :include => {
        :artist => {
          :only => [:id],
          :methods => [:to_s]
        },
        :tracks => {
          :only => [:id],
          :methods => [:to_s, :youtube_id],
          :include => {
            :album => {
              :only => [:id],
              :methods => [:to_s, :cover_art_thumb_url, :blurred_cover_art_url]
            },
            :artist => {
              :only => [:id],
              :methods => [:to_s]
            }
          }
        }
      }
    }.merge(options))
  end

  # The track - album relationship was designed in a way where if a track is listed on multiple albums,
  # when another album references the same track we use the already created track instead of creating another.
  # So when we get an albums tracks, we should set the album_context to make the track appear to be under this one.
  # Use original_tracks internally when doing import work!
  alias_method :original_tracks, :tracks
  def tracks
    original_tracks.content_available.each do |track|
      track.album_context = self
    end
  end

  def blurred_cover_art_url
    cover_art.url(:blurred)
  end

  def cover_art_url
    cover_art.url
  end

  def cover_art_thumb_url
    cover_art.url(:thumb)
  end

  def sync_to_remote_data_source
    remote_data = LastFM.album_info(artist.name, title)
    fail RuntimeError, "Unable to retreive remote album data." unless remote_data.present?

    destroy and return unless valid_content_present?(remote_data)

    self.attributes = {}.tap do |attrs|
      attrs["released_at"]  = remote_data["releasedate"].to_date
      attrs["summary"]      = ActionController::Base.helpers.strip_tags remote_data["wiki"]["summary"] if remote_data["wiki"].present?
      attrs["description"]  = ActionController::Base.helpers.strip_tags remote_data["wiki"]["content"] if remote_data["wiki"].present?
      attrs["cover_art"]    = open(remote_data["image"].last["#text"])

      attrs["album_tracks"] = [remote_data["tracks"]["track"]].flatten.map do |track_data|
        track = find_or_initialize_unique_track_by_title({:title => track_data["name"], :duration => track_data["duration"]})

        (track.new_record? ? AlbumTrack.new : AlbumTrack.find_or_initialize_by_album_id_and_track_id(id, track.id)).tap do |album_track|
          album_track.attributes = { :position => track_data["@attr"]["rank"].to_i, :album_id => id, :track => track }
          album_track.save!
        end
      end
    end

    save!
  end

  protected ###################################################################

  # Artists can release the same track under multiple albums
  # When creating a track, check if this artist already has the track in a different album
  # If so, we can reference the same track in the current album.
  def find_or_initialize_unique_track_by_title(attrs = {:title => ""})
    artist.albums.map(&:original_tracks).flatten.detect{|track| track.title == attrs[:title]} || Track.new(attrs)
  end

  # Some albums we get back from lastFM should be assumed to be garbage data.
  # examples are if there is no cover art, 0 listed tracks, name doesn't match.
  def valid_content_present?(remote_data)
    [].tap do |validations|
      validations << remote_data["image"].present?
      validations << remote_data["image"].last["#text"].present?
      validations << open(remote_data["image"].last["#text"])
      validations << [remote_data["tracks"]["track"]].flatten.first.present?
      validations << artist.name.downcase == remote_data["artist"].downcase
    end.all?
  rescue OpenURI::HTTPError
    return false
  rescue Errno::ENOENT
    return false
  rescue TypeError
    # A TypeError generally indicates a failure code was returned from LastFM
    # For now, just skip...
    return false
  end

end

class Artist < ActiveRecord::Base
  include LastFM

  validates_presence_of :name
  validates_uniqueness_of :name

  has_attached_file :photo

  has_and_belongs_to_many :genres
  has_many :albums, :dependent => :destroy

  accepts_nested_attributes_for :genres, :reject_if => proc {|attributes| attributes['name'].blank?}
  accepts_nested_attributes_for :albums, :reject_if => proc {|attributes| attributes['name'].blank?}

  serialize :similar_artists

  after_create :sync_to_remote_data_source
  after_commit :notify_tracks_to_sync

  def to_s
    name.titlecase
  end

  def as_json(options={})
    super({
      :only => [:id, :description],
      :methods => [:photo_url, :to_s],
      :include => {
        :albums => {
          :only => [:id, :artist_id],
          :methods => [:to_s, :cover_art_url, :cover_art_thumb_url]
        },
        :similar_artists => {
          :only => [:id],
          :methods => [:to_s, :photo_url]
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

  def description
    self[:description].blank? ? "No description available." : self[:description].gsub("\n", "<br />")
  end

  def tracks
    albums.map(&:tracks).flatten.uniq
  end

  def similar_artists
    self[:similar_artists].map{|name| Artist.find_by_name(name)}.compact
  end

  # This method gets called when the Artist is created or whenever we need to update everything for the artist.
  # This will make many API requests to create all Genres, Albums, Songs associated to this Artist.
  # Note: This will only create associated objects, it won't update anything.
  def sync_to_remote_data_source
    remote_data = LastFM.artist_info(name)
    fail RuntimeError, "Unable to retreive remote artist data." unless remote_data.present?

    self.attributes = {}.tap do |attrs|
      attrs["summary"]          = ActionController::Base.helpers.strip_tags remote_data["bio"]["summary"]
      attrs["description"]      = ActionController::Base.helpers.strip_tags remote_data["bio"]["content"]
      attrs["photo"]            = open(remote_data["image"].last["#text"]) if remote_data["image"].last["#text"].present?
      attrs["similar_artists"]  = remote_data["similar"]["artist"].map{|artist| artist["name"]}

      attrs["genres"] = remote_data["tags"]["tag"].map do |tag|
        Genre.find_or_initialize_by_name(tag["name"])
      end

      attrs["albums"] = [LastFM.top_albums(name)["album"]].flatten.map do |album|
        Album.find_or_initialize_by_title_and_artist_id(album["name"], id)
      end
    end

    save!
  end

  protected ###################################################################

  def notify_tracks_to_sync
    albums.map(&:original_tracks).flatten.uniq.map(&:sync_to_remote_data_source)
  end

  def photo_url
    photo.url
  end

end

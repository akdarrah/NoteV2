class Track < ActiveRecord::Base
  include Youtube

  # This will get set by the TracksController
  # Represents the album the user clicked on in the interface
  attr_accessor :album_context

  # Duration on Track is expected duration of the track (YoutubeVideo duration is length of video)
  validates_presence_of :title, :duration

  has_many :album_tracks, :dependent => :destroy
  has_many :albums, :through => :album_tracks

  # For now a track only has one youtube video
  # In the future, a track could have multiple (live, cover, remix...)
  has_one :youtube_video, :dependent => :destroy

  scope :content_available, lambda {
    joins(:youtube_video).
    where("youtube_videos.track_id IS NOT NULL")
  }

  delegate :youtube_id, :to => :youtube_video

  def to_s
    title.titlecase
  end

  # This is basically duplicated in both artist and album models.
  def as_json(options={})
    super({
      :only => [:id, :duration],
      :methods => [:to_s, :youtube_id],
      :include => {
        :albums => {
          :only => [:id, :artist_id],
          :methods => [:cover_art_url, :cover_art_thumb_url, :to_s]
        },
        :album => {
          :only => [:id, :artist_id],
          :methods => [:to_s, :cover_art_url, :cover_art_thumb_url, :blurred_cover_art_url]
        },
        :artist => {
          :only => [:id, :summary],
          :methods => [:to_s]
        }
      }
    }.merge(options))
  end

  def album
    album_context || albums.first
  end

  def artist
    album.artist
  end

  # Called by after_commit callback in Artist.rb
  # This is used to automatically try to fetch the correct video from youtube.
  # After being called once, never use this again to set the youtube video.
  def sync_to_remote_data_source
    return nil if youtube_video.present?
    remote_data = Youtube.search(albums.first.artist, title)

    fail RuntimeError, "Unable to retreive remote track data." unless remote_data.present?
    fail RuntimeError, "Invalid youtube data for track" unless remote_data["entry"].present?

    video_attrs = {
      :track      => self,
      :duration   => remote_data["entry"].first["media$group"]["yt$duration"]["seconds"].to_i,
      :title      => remote_data["entry"].first["media$group"]["media$title"]["$t"],
      :youtube_id => remote_data["entry"].first["id"]["$t"].split(":").last,
      :thumbnail  => open(remote_data["entry"].first["media$group"]["media$thumbnail"].first["url"])
    }

    # More reliable albums (and its tracks) are scraped first. If the youtube_id is already in the system
    # chances are that a previous album already claimed the video. (These need to be manually fixed)
    # This can be a problem with an artist with two similar worded songs.
    return false if YoutubeVideo.find_by_youtube_id(video_attrs[:youtube_id]).present?

    update_attributes!({"youtube_video" => YoutubeVideo.new(video_attrs)})
  end

end

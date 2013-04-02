class YoutubeVideo < ActiveRecord::Base
  belongs_to :track
  validates_presence_of :track, :duration, :thumbnail, :title, :youtube_id
  validates_uniqueness_of :youtube_id

  has_attached_file :thumbnail
end

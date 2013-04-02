class AlbumTrack < ActiveRecord::Base
  belongs_to :album
  belongs_to :track

  validates_presence_of :album, :track
end

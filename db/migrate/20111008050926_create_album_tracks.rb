class CreateAlbumTracks < ActiveRecord::Migration
  def self.up
    create_table :album_tracks do |t|
      t.references :album
      t.references :track
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :album_tracks
  end
end

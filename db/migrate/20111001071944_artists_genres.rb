class ArtistsGenres < ActiveRecord::Migration
  def self.up
    create_table :artists_genres, :id => false do |t|
      t.integer :artist_id
      t.integer :genre_id
    end
  end

  def self.down
    drop_table :artists_genres
  end
end

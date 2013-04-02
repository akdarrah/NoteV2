class AddSimilarArtistsToArtist < ActiveRecord::Migration
  def self.up
    add_column :artists, :similar_artists, :text
  end

  def self.down
    remove_column :artists, :similar_artists
  end
end

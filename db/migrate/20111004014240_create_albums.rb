class CreateAlbums < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.string :title
      t.references :artist
      t.datetime :released_at
      t.text :summary
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :albums
  end
end

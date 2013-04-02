class CreateYoutubeVideos < ActiveRecord::Migration
  def self.up
    create_table :youtube_videos do |t|
      t.references :track
      t.integer :duration
      t.string :title
      t.string :youtube_id

      t.timestamps
    end
  end

  def self.down
    drop_table :youtube_videos
  end
end

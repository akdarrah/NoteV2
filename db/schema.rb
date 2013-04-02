# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111029053103) do

  create_table "album_tracks", :force => true do |t|
    t.integer  "album_id"
    t.integer  "track_id"
    t.integer  "position"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "albums", :force => true do |t|
    t.string   "title"
    t.integer  "artist_id"
    t.datetime "released_at"
    t.text     "summary"
    t.text     "description"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "cover_art_file_name"
    t.string   "cover_art_content_type"
    t.integer  "cover_art_file_size"
    t.datetime "cover_art_updated_at"
  end

  create_table "artists", :force => true do |t|
    t.string   "name"
    t.text     "summary"
    t.text     "description"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.text     "similar_artists"
  end

  create_table "artists_genres", :id => false, :force => true do |t|
    t.integer "artist_id"
    t.integer "genre_id"
  end

  create_table "genres", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tracks", :force => true do |t|
    t.string   "title"
    t.integer  "duration"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "youtube_videos", :force => true do |t|
    t.integer  "track_id"
    t.integer  "duration"
    t.string   "title"
    t.string   "youtube_id"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.integer  "thumbnail_file_size"
    t.datetime "thumbnail_updated_at"
  end

end

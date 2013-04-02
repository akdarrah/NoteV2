require 'spec_helper'

describe Artist do

  let(:subject) { Artist.new(:similar_artists => [@similar_artist_name]) }

  before(:each) do
    @first_song   = double
    @second_song  = double
    @first_album  = double(:tracks => [@first_song], :original_tracks => [@first_song])
    @second_album = double(:tracks => [@first_song, @second_song], :original_tracks => [@first_song, @second_song])
    @similar_artist_name = double
    @similar_artist_result = double(:id => double, :photo_url => double, :to_s => double)

    subject.stub!(
      :albums => [@first_album, @second_album],
      :photo => double(:url => double)
    )
  end

  describe "#to_s" do
    it "titlecases the name of the artist" do
      artist_title = double
      subject.stub_chain(:name, :titlecase).and_return(artist_title)
      subject.to_s.should == artist_title
    end
  end

  describe "#tracks" do
    it "returns unique tracks for albums" do
      subject.tracks.should == [@first_song, @second_song]
    end
  end

  describe "#similar_artists" do
    it "attempts to find an artist" do
      Artist.should_receive(:find_by_name).with(@similar_artist_name).and_return(@similar_artist_result)
      subject.similar_artists.should == [@similar_artist_result]
    end

    it "removes nil artist search results" do
      Artist.should_receive(:find_by_name).with(@similar_artist_name).and_return(nil)
      subject.similar_artists.should == []
    end
  end

  describe "#similar_artists_to_json" do
    it "returns an array of hashes of needed artist data" do
      similar_artist_to_h = {
        :id => @similar_artist_result.id,
        :photo_url => @similar_artist_result.photo_url,
        :to_s => @similar_artist_result.to_s
      }

      subject.should_receive(:similar_artists).and_return([@similar_artist_result])
      subject.similar_artists_to_json.should == [similar_artist_to_h]
    end
  end

  describe "#sync_to_remote_data_source" do
    # ...
  end

  describe "#notify_tracks_to_sync" do
    it "calls Track#sync_to_remote_data_source on all uniq tracks" do
      @first_song.should_receive(:sync_to_remote_data_source)
      @second_song.should_receive(:sync_to_remote_data_source)
      subject.send(:notify_tracks_to_sync)
    end
  end

  describe "#photo_url" do
    it "returns the url of the photo (for json)" do
      subject.send(:photo_url).should == subject.photo.url
    end
  end

end

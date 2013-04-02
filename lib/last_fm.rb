module LastFM
  class LastFMTransmitter
    def self.transmit(method, args = {})
      raise RuntimeError, "Unknown LastFM credentials." unless LAST_FM["base_url"] && LAST_FM["api_key"]

      params = ""
      args.keys.each{|key| params << "&#{key}=#{CGI::escape(args[key])}"}
      JSON.parse(open("#{LAST_FM["base_url"]}method=#{method}&api_key=#{LAST_FM["api_key"]}&format=json#{params}").read).values.first
    end
  end

  def self.artist_info(artist_name)
    LastFMTransmitter.transmit('artist.getInfo', :artist => artist_name)
  end

  def self.top_albums(artist_name)
    LastFMTransmitter.transmit('artist.gettopalbums', :artist => artist_name)
  end

  def self.album_info(artist_name, album_name)
    LastFMTransmitter.transmit('album.getinfo', {:artist => artist_name, :album => album_name})
  end
end

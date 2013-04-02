module Youtube
  class YoutubeTransmitter
    def self.transmit(method, args = {})
      raise RuntimeError, "Unknown Youtube credentials." unless YOUTUBE["base_url"] && YOUTUBE["api_key"]
      
      params = ""
      args.keys.each{|key| params << "&#{key}=#{CGI::escape(args[key])}"}
      JSON.parse(open("#{YOUTUBE["base_url"]}#{method}?key=#{YOUTUBE["api_key"]}&v=2&category=Music&alt=json#{params}").read)["feed"]
    end
  end

  def self.search(artist_name, song_title)
    YoutubeTransmitter.transmit('videos', {:q => "#{artist_name} #{song_title}", :v => "2", :"max-results" => "1"})
  end
end

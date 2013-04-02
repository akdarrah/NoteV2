class RootController < ApplicationController

  layout 'root'

  def index
    gon.tracks = Track.content_available.order("RAND()").limit(25)
  end

end

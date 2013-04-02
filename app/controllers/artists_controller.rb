class ArtistsController < InheritedResources::Base
  respond_to :html, :js
  actions :show
  
  layout "root"
  
  caches_page :show
  
  def show
    show! do |format|
      format.js { render :json => resource }
      format.html { gon.tracks = resource.tracks }
    end
  end

end

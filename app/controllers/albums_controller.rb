class AlbumsController < InheritedResources::Base
  respond_to :html, :js
  actions :show
  nested_belongs_to :artist

  layout "root"
  
  caches_page :show

  def show
    show! do |format|
      format.js { render :json => resource }
      format.html { gon.tracks = resource.tracks }
    end
  end
  
end

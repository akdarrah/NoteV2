class TracksController < InheritedResources::Base
  respond_to :html, :js
  actions :show

  layout "root"
  
  caches_page :show
  
  def show
    show! do |format|
      format.js { render :json => resource }
      format.html { gon.tracks = resource.album.tracks }
    end
  end

  protected ###################################################################
  
  # not a standard nested_belongs_to
  def resource
    unless @track.present?
      @track = Album.artist_id(params[:artist_id]).find(params[:album_id]).original_tracks.find(params[:id])
      @track.album_context = @track.albums.find(params[:album_id])
    end
    
    @track
  end
  
end

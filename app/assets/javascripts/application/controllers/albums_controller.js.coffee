jQuery ->

  class root.AlbumsController extends Backbone.Router

    routes:
      "artists/:artistId/albums/:id" : "show"

    show: (artistId, id) ->
      $("#page_content").html('<img alt="Loading" src="/assets/loading.gif">')
      root.currentAlbum = new root.Album({"id":id, "artistId":artistId})

      root.currentAlbum.fetch
        success: ->
          root.PageView.getInstance()
                       .setModel(window.currentAlbum)
                       .render($("#album-model-template"))
                       .executeContentJs()
                       
          root.NotemarePlayer.getInstance().resetTrackQueues(root.currentAlbum.get('tracks'))
        error: ->
          # new Error({ message: 'Could not find that document.' })
          # window.location.hash = '#'


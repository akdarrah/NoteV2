jQuery ->

  class root.ArtistsController extends Backbone.Router

    routes:
      "artists/:id" : "show"

    show: (id) ->
      $("#page_content").html('<img alt="Loading" src="/assets/loading.gif">')
      root.currentArtist = new root.Artist({"id":id})

      root.currentArtist.fetch
        success: ->
          root.PageView.getInstance()
                       .setModel(window.currentArtist)
                       .render($("#artist-model-template"))
                       .executeContentJs()
          
          root.NotemarePlayer.getInstance().resetTrackQueues(root.currentArtist.get('tracks'))
        error: ->
            # new Error({ message: 'Could not find that document.' })
            # window.location.hash = '#'


jQuery ->

  class root.TracksController extends Backbone.Router

    routes:
      "artists/:artistId/albums/:albumId/tracks/:id" : "show"

    show: (artistId, albumId, id) ->
      $("#page_content").html('<img alt="Loading" src="/assets/loading.gif">')
      root.currentTrack = new root.Track({"id":id, "albumId":albumId, "artistId":artistId})

      root.currentTrack.fetch
        success: ->
          root.PageView.getInstance()
                       .setModel(window.currentTrack)
                       .render($("#track-model-template"))
                       .executeContentJs()
                       
          trackIndex = _.indexOf(root.NotemarePlayer.getInstance().trackCollectionIds(), parseInt(root.currentTrack.id))
          root.NotemarePlayer.getInstance().syncTrackNowPlaying(trackIndex)
        error: ->
          # new Error({ message: 'Could not find that document.' });
          # window.location.hash = '#';


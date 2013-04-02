jQuery.ajaxSetup
  'beforeSend': (xhr) ->
    xhr.setRequestHeader "Accept", "text/javascript"

jQuery ->

  new root.ArtistsController
  new root.TracksController
  new root.AlbumsController

  root.Router = new Backbone.Router
  Backbone.history.start pushState: true

  $("#player-play").on 'click', (event) ->
    root.NotemarePlayer.getInstance().togglePlaying() if root.EventRateLimiter.getInstance().isAllowedAction()
    return false

  $("#player-next").on 'click', (event) ->
    root.NotemarePlayer.getInstance().playNextTrack() if root.EventRateLimiter.getInstance().isAllowedAction(200)
    return false

  $("#player-prev").on 'click', (event) ->
    root.NotemarePlayer.getInstance().playPrevTrack() if root.EventRateLimiter.getInstance().isAllowedAction(200)
    return false

  # alert user on page unload if track is playing
  $(window).bind 'beforeunload', (event) ->
    return "Leaving now will interrupt the song you're listening to." if root.NotemarePlayer.getInstance().isCurrentlyPlaying()

  # Keyboard bindings
  $(document).bind 'keydown', 'meta+right', () ->
    $("#player-next").trigger('click')
    return false

  $(document).bind 'keydown', 'meta+left', () ->
    $("#player-prev").trigger('click')
    return false

  $(document).bind 'keydown', 'space', () ->
    $("#player-play").trigger('click')
    return false


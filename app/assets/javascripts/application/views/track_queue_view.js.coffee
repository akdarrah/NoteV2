jQuery ->

  class root.TrackQueueView extends Backbone.View

    events:
      "click .playable_track"     : "playTrack"
      "mouseover .playable_track" : "hoverTrack"
      "mouseout .playable_track"  : "unHoverTrack"
    
    playTrack: (event) ->
      if root.EventRateLimiter.getInstance().isAllowedAction()
        root.NotemarePlayer.getInstance().playTrack($(event.currentTarget).index(), {resetToCurrent: true})
      event.preventDefault()

    hoverTrack: (event) ->
      unless $("#secondary-track-queue").hasClass("read-only")
        $($(".track_queue .playable_track").get($(event.currentTarget).index())).addClass("hover_style")
      event.preventDefault()

    unHoverTrack: (event) ->
      $(".track_queue .hover_style").removeClass("hover_style")
      event.preventDefault()

    render:() ->
      $(@el).empty()
      for track in @collection.models
        new root.TrackQueueItemView({model: track}).render(@el)
      return @


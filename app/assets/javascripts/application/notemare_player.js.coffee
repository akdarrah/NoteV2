jQuery ->

  class root.NotemarePlayer extends root.Singleton

    constructor: ->
      @trackCollection = new root.TrackCollection gon.tracks
      @primaryTrackCollectionView   = new root.TrackQueueView({collection:@trackCollection, el: "#primary-track-queue"}).render()
      @secondaryTrackCollectionView = new root.TrackQueueView({collection:@trackCollection, el: "#secondary-track-queue"}).render()

    resetTrackQueues: (tracks) ->
      @trackCollection.reset(tracks)
      @primaryTrackCollectionView.render()
      @secondaryTrackCollectionView.render()

    isCurrentlyPlaying: ->
      root.ytPlayer.getPlayerState() is 1

    togglePlaying: ->
      return @playPrevTrack() if root.ytPlayer.getPlayerState() is -1
      if @isCurrentlyPlaying() then @pauseVideo() else @playVideo()

    playTrack: (index, options) ->
      options ?= {resetToCurrent: @interfaceShowsCurrentlyPlaying()}
      $track = $($("#primary-track-queue .playable_track").get(index))
      if $track.length > 0
        @setInterfaceToTrack($track, options)
        @playVideo()
      return false

    playRandomTrack: ->
      index = Math.floor(Math.random() * ($("#primary-track-queue .playable_track:last").index() + 1))
      @playTrack(index)
      return false

    playNextTrack: ->
      if $(".track_now_playing").length > 0
        nextTrackIndex = $("#primary-track-queue .track_now_playing").index() + 1
        lastTrackIndex = $("#primary-track-queue .playable_track:last").index()
        @playTrack(nextTrackIndex) if nextTrackIndex <= lastTrackIndex
      return false

    playPrevTrack: ->
      if $("#primary-track-queue .track_now_playing").length > 0
        trackIndex = $("#primary-track-queue .track_now_playing").prev().index()

        if root.ytPlayer.getCurrentTime() < 3.0 and trackIndex >= 0
          @playTrack(trackIndex)
        else
          @setInterfaceToTrack($("#primary-track-queue .track_now_playing"))
          root.ytPlayer.seekTo(0)
          @playVideo()
      return false

    setInterfaceToTrack: (track, options) ->
      options ?= {}
      @syncTrackNowPlaying(track.index())
      track = @trackCollection.at track.index()
      $.backstretch(track.blurredCoverArt())

      $("#currently_playing #current-track-name").text(track.get("to_s"))
      $("#currently_playing #current-artist-name").text(track.get("artist").to_s)
      $("#currently_playing #current-album-name").text(track.get("album").to_s)

      # both of these send additional requests
      # For some reason, track.url() wasn't working (undefined album/artist ids)
      root.ytPlayer.cueVideoById(track.get("youtube_id"), 0, "hd1080")
      
      # This will set the url to '/' and do a Backbone route without updating the url
      if options.resetToCurrent
        window.history.replaceState('', '', '/')
      if options.resetToCurrent or @interfaceShowsCurrentlyPlaying()
        Backbone.history.loadUrl("artists/" + track.get("artist").id + "/albums/" + track.get("album").id + "/tracks/" + track.get("id"), {trigger: true})
    
    trackCollectionIds: ->
      @trackCollection.map (track) -> return track.get('id')
    
    # Private
    ###########################################################################

    syncTrackNowPlaying: (targetTrackIndex) ->
      targetPreviewTrack = $("#primary-track-queue .playable_track:eq(" + targetTrackIndex + ")")
      targetFullQueueTrack = $("#secondary-track-queue .playable_track:eq(" + targetTrackIndex + ")")
      scrollDuration = if Math.abs($("#primary-track-queue .track_now_playing").index() - targetPreviewTrack.index()) > 1 then 800 else 100

      $("#primary-track-queue").scrollTo(targetPreviewTrack, scrollDuration, {offset: {top:-102}})
      $("#secondary-track-queue").scrollTo(targetFullQueueTrack, scrollDuration, {offset: {top:-204}})

      $(".track_now_playing").each () ->
        $(this).removeClass("track_now_playing")

      targetPreviewTrack.addClass("track_now_playing")
      targetFullQueueTrack.addClass("track_now_playing")
    
    interfaceShowsCurrentlyPlaying: ->
      root.PageView.getInstance().model is root.currentTrack
    
    # use instead of window.ytPlayer.playVideo() / window.ytPlayer.pauseVideo internally..
    playVideo: ->
      $("#player-play").html("<i class='icon-pause'></i>")
      root.ytPlayer.playVideo()

    pauseVideo: ->
      $("#player-play").html("<i class='icon-play'></i>")
      root.ytPlayer.pauseVideo()

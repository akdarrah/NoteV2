jQuery ->

  swfobject.embedSWF(
    "http://www.youtube.com/e/eOc1mn-4EzE?enablejsapi=1&version=3&playerapiid=ytplayer&controls=0&hd=1&showinfo=0&disablekb=1&iv_load_policy=3",
    "ytapiplayer", "320", "240", "8", null, null,
    (allowScriptAccess: "always", allowFullScreen: "false"), (id: "ytPlayer")
  )

  root.onYouTubePlayerReady = (playerId) ->
    root.ytPlayer = document.getElementById("ytPlayer")
    root.ytPlayer.addEventListener("onStateChange", "onytplayerStateChange")
    root.ytPlayer.setVolume(80)
    unless root.PageView.getInstance().model? and root.PageView.getInstance().model is root.currentTrack
      root.NotemarePlayer.getInstance().setInterfaceToTrack $("#primary-track-queue .playable_track:first")

  root.onytplayerStateChange = (state) ->
    if state is 0
      root.NotemarePlayer.getInstance().playNextTrack()


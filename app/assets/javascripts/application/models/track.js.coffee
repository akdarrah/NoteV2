jQuery ->

  class root.Track extends Backbone.Model

    url: ->
      @trackUrl() + ".js"

    artistUrl: ->
      "/artists/" + @get("artistId")

    albumUrl: (albumId) ->
      albumId ?= @get("albumId")
      "/artists/" + @get("artistId") + "/albums/" + albumId

    trackUrl: ->
      "/artists/" + @get("artistId") + '/albums/' + @get("albumId") + '/tracks/' + @get("id")

    blurredCoverArt: ->
      @get("album").blurred_cover_art_url

    breadcrumbLinks: ->
      return [
        (text: @get("artist").to_s, href: @artistUrl())
        (text: @get("album").to_s, href: @albumUrl())
        (text: @get("to_s"), href: @trackUrl())
      ]


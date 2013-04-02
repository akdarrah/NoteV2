jQuery ->

  class root.Album extends Backbone.Model

    url: ->
      @albumUrl() + ".js"

    albumUrl: ->
      '/artists/' + @get("artistId") + '/albums/' + @get("id")

    artistUrl: ->
      "/artists/" + @get("artistId")

    breadcrumbLinks: ->
      return [
        ({text: @get("artist").to_s, href: @artistUrl()})
        ({text: @get("to_s"), href: @albumUrl()})
      ]


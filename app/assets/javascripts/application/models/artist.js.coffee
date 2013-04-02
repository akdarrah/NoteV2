jQuery ->

  class root.Artist extends Backbone.Model

    url: ->
      @artistUrl() + ".js"

    artistUrl: ->
      '/artists/' + @get("id")

    albumUrl: (albumId) ->
      '/artists/' + @get("id") + '/albums/' + albumId

    breadcrumbLinks: ->
      return [
        ({text: @get("to_s"), href: @artistUrl()})
      ]


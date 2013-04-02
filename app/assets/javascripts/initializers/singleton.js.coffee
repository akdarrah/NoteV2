class root.Singleton
  @_instance: null
  @getInstance: ->
    @_instance ||= new @( arguments... )


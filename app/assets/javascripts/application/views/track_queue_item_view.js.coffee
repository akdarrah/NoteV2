jQuery ->

  class root.TrackQueueItemView extends Backbone.View

    render: (collectionEl) ->
      source   = $("#track-queue-template").html()
      template = Handlebars.compile(source)
      context  = @model.toJSON()
      $(collectionEl).append(template(context))
      return @


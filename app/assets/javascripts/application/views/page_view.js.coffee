jQuery ->

  class root.PageView extends root.Module

    @extend root.Singleton
    @extend Backbone.View

    el: $("#page_content"),

    # return @ so this can be chained
    setModel:(model) ->
      @model = model
      return @

    render:($template) ->
      source   = $template.html()
      template = Handlebars.compile(source)
      context  = @model.toJSON()
      @el.html(template(context))
      return @

    executeContentJs: (customJs) ->
      root.BreadcrumbNavigation.getInstance().set(@model.breadcrumbLinks())

      $('[rel=tooltip]').tooltip()
      $(".meta_info p").expander
        slicePoint: 350,
        expandEffect: 'fadeIn',
        expandSpeed: 20,
        collapseEffect: 'fadeOut',
        collapseSpeed: 20

      customJs() if customJs
      return @


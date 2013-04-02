jQuery ->

  class root.BreadcrumbNavigation extends root.Singleton

    set: (links) ->
      @clear()

      for link in links
        @append link.text, link.href

    # private #################################################################

    clear: ->
      $("ul.breadcrumb").html ""

    append: (text, href) ->
      throw "Cannot append more than 3 items in breadcrumb." if $("ul.breadcrumb li").length >= 3

      divider = if $("ul.breadcrumb li").length > 0 then "<span class='divider'>&rarr;</span>" else ""
      $("<li>" + divider + "<a href='" + href + "'>" + text + "</a></li>").appendTo $("ul.breadcrumb")


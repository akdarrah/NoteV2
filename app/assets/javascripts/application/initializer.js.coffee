# Handle backbone links
# http://dev.tenfarms.com/posts/proper-link-handling

$(document).on "click", "a[href^='/']", (event) =>
  if (!event.altKey and !event.ctrlKey and !event.metaKey and !event.shiftKey)
    $('[rel=tooltip]').tooltip('hide')
    event.preventDefault()
    url = $(event.currentTarget).attr("href").replace(/^\//, "")
    window.Router.navigate(url, { trigger: true })


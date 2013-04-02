# Rate limit interface events from the user.
# Default event rate limit is 100 milliseconds.

class root.EventRateLimiter extends root.Singleton

  constructor: ->
    @lastAction = 0

  isAllowedAction:(eventRate) ->
    eventRate ?= 100
    if (new Date().getTime() - @lastAction) >= eventRate then @takeAction() else false

  # private #################################################################

  takeAction: ->
    @lastAction = new Date().getTime()
    return true


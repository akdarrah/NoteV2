# http://arcturo.github.com/library/coffeescript/03_classes.html

moduleKeywords = ['extended', 'included']

class root.Module

  @extend: (obj) ->
    for key, value of obj when key not in moduleKeywords
      @[key] = value

    obj.extended?.apply(@)
    this

  @include: (obj) ->
    for key, value of obj when key not in moduleKeywords
      @::[key] = value

    obj.included?.apply(@)
    this


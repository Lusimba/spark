goog.provide 'spark.components.Field'

goog.require 'spark.core.View'


###*
  Base field class for input element types in Spark Framework.
###
class spark.components.Field extends spark.core.View

  ###*
    @constructor
    @param   {Object=} options Class options.
    @param   {*=} data Class data
    @extends {spark.core.View}
  ###
  constructor: (options = {}, data) ->

    options.tagName     = 'input'
    options.cssClass    = "#{spark.utils.concatString 'input', options.type, options.cssClass}"
    options.type      or= 'text'
    options.name      or= null
    options.value     or= ""

    super options, data

    @setAttribute 'type', options.type

    if options.value
      @setValue options.value

    if options.name
      @setName options.name


  ###*
    Sets field value.
    @param {!string} value Input value.
  ###
  setValue: (value) ->
    @getElement().value = value


  ###*
    Return field value.
  ###
  getValue: ->
    return @getElement().value


  ###*
    Sets field name.
    @param {!string} name field name.
  ###
  setName: (name) ->
    @setAttribute 'name', name


  ###*
    Return field name.
  ###
  getName: ->
    return @getElement().name

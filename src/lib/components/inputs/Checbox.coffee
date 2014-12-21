goog.provide 'spark.components.Checkbox'

goog.require 'spark.components.Field'


class spark.components.Checkbox extends spark.components.Field

  ###*
    Checkbox component of Spark Framework.

    @constructor
    @export
    @param   {Object=} options Class options.
    @param   {*=} data Class data
    @extends {spark.components.Field}
  ###
  constructor: (options = {}, data) ->

    options.type     or= options['type']    or 'checkbox'
    options.checked   ?= options['checked']  ? no

    super options, data

    if options.checked is yes
      @check()


  ###*
    Check the element.

    @export
  ###
  check: ->
    @getElement().checked = yes
    @emit 'StateChanged', yes


  ###*
    Uncheck the element.

    @export
  ###
  uncheck: ->
    @getElement().checked = no
    @emit 'StateChanged', no


  ###*
    Returns element's checked state.

    @export
    @return {boolean} Checked state.
  ###
  isChecked: ->
    return @getElement().checked


  ###*
    Returns element value. It's actually checked state.

    @export
    @return {boolean} Checked state.
  ###
  getValue: ->
    return @isChecked()

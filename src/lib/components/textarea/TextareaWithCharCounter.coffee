goog.provide 'spark.components.TextareaWithCharCounter'

goog.require 'spark.components.Textarea'
goog.require 'goog.ui.CharCounter'


class spark.components.TextareaWithCharCounter extends spark.components.Textarea

  ###*
    Texarea component with built-in char counter like Twitter 140 char input.
    By default char limit is 140. See `charLimit` option. Counter element may be
    configured to be invisible. See `isCounterVisible` option. Default char
    counter is a remaining counter also it may be an incremental counter. See
    `showRemainingCount` option. By default the counter view will be appended to
    `document.body`. To change it see `counterContainer` option.

    @constructor
    @export
    @param   {Object=} options Class options.
    @param   {*=} data Class data
    @extends {spark.components.Textarea}
  ###
  constructor: (options = {}, data) ->

    options.charLimit         or= options['charLimit']          or 140
    options.counterContainer  or= options['counterContainer']   or document.body
    options.isCounterVisible   ?= options['isCounterVisible']   ? yes
    options.showRemainingCount ?= options['showRemainingCount'] ? yes

    super options, data


  ###*
    @override
  ###
  decorate_: ->
    super

    { counterContainer, charLimit, isCounterVisible, showRemainingCount } = @getOptions()

    @counterView = new spark.core.View
      cssClass   : 'textarea-counter'
      renderTo   : counterContainer

    unless isCounterVisible
      @counterView.addClass 'hidden'

    counterEl  = @counterView.getElement()
    textareaEl = @getTextaraeElement_()
    charMode   = goog.ui.CharCounter.Display.REMAINING

    unless showRemainingCount
      charMode = goog.ui.CharCounter.Display.INCREMENTAL

    @counter = new goog.ui.CharCounter textareaEl, counterEl, charLimit, charMode

    @counter.checkLength()


  ###*
    Returns the textarea element. This method should live here because of the
    return annotation, Compiler needs it.

    @private
    @return {HTMLTextAreaElement}
  ###
  getTextaraeElement_: ->
    return @textarea_.getElement()


  ###*
    Sets the value and triggers counter to check it's length.

    @export
    @override
  ###
  setValue: (value) ->
    super

    if @counter
      @counter.checkLength()


  ###*
    Set counter's max length. It can be modified on run time. If you set the new
    length to be less than the previous value, counter will update itself and it
    will also truncate the value in textbox if the textbox value's length is
    more than the new max length.

    @export
    @param {number} length Max length for counter.
  ###
  setCharLimit: (length) ->
    @counter.setMaxLength length


  ###*
    Returns counter view instance.

    @export
    @return {spark.core.View}
  ###
  getCounterView: ->
    return @counterView


  ###*
    Destroy's the component and it's dependencies.

    @export
    @override
  ###
  destroy: ->
    unless @isDestroyed()
      @counter.disposeInternal()
      @counter = null

      @getCounterView().destroy()
      @counterView = null

    super

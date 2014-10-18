goog.provide 'spark.components.Form'

goog.require 'spark.core.View'
goog.require 'spark.components.FieldFactory'
goog.require 'spark.components.LabeledInput'


###*
  Form component.
###
class spark.components.Form extends spark.core.View

  ###*
    @constructor
    @param   {Object=} options Class options.
    @param   {*=} data Class data
    @extends {spark.core.View}
  ###
  constructor: (options = {}, data) ->

    options.cssClass = "#{spark.utils.concatString 'form', options.cssClass}"

    super options, data

    @inputs           = []
    @buttons          = []
    @inputsByName     = {}
    {inputs, buttons} = options

    @createContainers_()

    if inputs
      inputs.forEach (options) =>  @createInput options

    if buttons
      buttons.forEach (options) => @createButton options

    @setData data


  ###*
    Creates DOM element to hold input and button elements.

    @private
  ###
  createContainers_: ->
    @inputsContainer  = new spark.core.View cssClass: 'input-container'
    @buttonsContainer = new spark.core.View cssClass: 'buttons-container'

    @appendView @inputsContainer
    @appendView @buttonsContainer


  ###*
    Creates field component from passed option using FieldFactory.
    FIXME: Creating LabeledInput should be handled in FieldFactory.

    @param {!Object} options Field options to create a field component.
  ###
  createInput: (options) ->
    {name, label} = options

    if label
      labeledInput   = new spark.components.LabeledInput
        labelOptions : options
        inputOptions : options

      @inputsContainer.appendView labeledInput
      @inputs.push input = labeledInput.input

    else
      input = spark.components.FieldFactory options
      @inputsContainer.appendView input
      @inputs.push input

    @inputsByName[name] = input if name


  ###*
    Creates button with the options.

    @param {!Object} options Options to create a button component.
  ###
  createButton: (options) ->
    button = new spark.components.Button options

    @buttons.push button
    @buttonsContainer.appendView button


  ###*
    Sets form data and update fields with the data.
    Data should be an object and keys should match field names in this form.
    Values should be string.
  ###
  setData: (data) ->
    return unless @inputsByName

    for name, value of data
      input = @inputsByName[name]
      input.setValue value if input


  ###*
    Returns form data from DOM elements.
    This method may be useful for serializing the form data.
  ###
  getData: ->
    dataSet = {}

    for input in @inputs
      dataSet[input.getName()] = input.getValue()

    return dataSet

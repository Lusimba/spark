goog = goog or goog = require: ->

goog.require 'spark.components.Form'
goog.require 'spark.components.Input'
goog.require 'spark.components.Button'
goog.require 'spark.components.LabeledInput'


describe 'spark.components.Form', ->

  form      = null
  f         = null
  cancelled = null
  submitted = null
  options   = null

  beforeEach ->
    f = new spark.components.Form null, null
    options =
      inputs              : [
        {
          type            : 'text'
          placeholder     : 'Enter your name'
          name            : 'name'
          value           : 'Fatih'
        }
        {
          type            : 'text'
          placeholder     : 'Enter your surname'
          name            : 'surname'
          value           : 'Acet'
        }
      ]
      buttons             : [
        { title           : 'Cancel'  }
        { title           : 'Confirm' }
      ]

    form = new spark.components.Form options


  it 'should extend spark.core.View', ->
    expect(form instanceof spark.core.View).toBeTruthy()


  it 'should have default options', ->
    expect(f.options).toBeDefined()


  it 'should have containers even no options passed', ->
    expect(f.getInputsContainer() instanceof spark.core.View).toBeTruthy()
    expect(f.getButtonsContainer() instanceof spark.core.View).toBeTruthy()


  it 'should have correct amount of inputs', ->
    expect(form.getInputs().length).toBe 2


  it 'should have correct amount of buttons', ->
    expect(form.getButtons().length).toBe 2


  it 'should have inputs as an instance of spark.components.Input if no label passed in input options', ->
    for input in form.getInputs()
      expect(input instanceof spark.components.Input).toBeTruthy()


  it 'should have buttons as instance of spark.components.Button', ->
    for button in form.getButtons()
      expect(button instanceof spark.components.Button).toBeTruthy()


  it 'should return inputs by name', ->
    expect(form.getInputByName('surname') instanceof spark.components.Input).toBeTruthy()
    expect(form.getInputByName('unexisting')).toBeNull()


  it 'should set and update form data', ->
    form.setData { name: 'John', surname: 'Doe', notExistingInput: 'someValue' }

    expect(form.getInputByName('name').getValue()).toBe 'John'
    expect(form.getInputByName('surname').getValue()).toBe 'Doe'


  it 'should have spark.components.LabeledInput element if label options passed in input options', ->
    f = new spark.components.Form inputs: [ { label: 'Your Name..?', name: 'hello' } ]

    expect(f.getInputsContainer().getElement().firstChild.tagName).toBe 'DIV'


  it 'should return latest form data', ->
    defaults = name: 'Fatih', surname: 'Acet'
    newData  = name: 'John',  surname: 'Doe'

    expect(form.getData().name).toBe 'Fatih'

    form.setData newData

    expect(form.getData().name).toBe 'John'


  it 'should set data from constructor', ->
    options =
      inputs : [
        { name  : 'email', value : 'fatih@fatihacet.com' }
        { name  : 'password' }
      ]

    data = { email: 'fatih@fatihacet.com.', password: '123' }

    f = new spark.components.Form options, data

    expect(f.getInputByName('email').getValue()).toBe    'fatih@fatihacet.com.'
    expect(f.getInputByName('password').getValue()).toBe '123'


  it 'should create input first for type checkbox or radio', ->
    form = new spark.components.Form
      inputs: [
        {
          type: 'checkbox'
          label: 'Are you sure'
          name: 'cb'
        }
        {
          type: 'radio'
          label: 'Hello'
          name: 'rd'
        }
      ]

    cb = form.getInputByName('cb').getElement()
    rd = form.getInputByName('rd').getElement()

    expect(cb.tagName).toBe 'INPUT'
    expect(cb.nextSibling.tagName).toBe 'LABEL'
    expect(rd.tagName).toBe 'INPUT'
    expect(rd.nextSibling.tagName).toBe 'LABEL'


  it 'should create combobox with proper items', ->
    form = new spark.components.Form
      inputs: [
        {
          type  : 'combobox'
          name  : 'combo1'
          items : [
            { title: 'item 1', value: 'item1' }
            { title: 'item 2', value: 'item2' }
            { title: 'item 3', value: 'item3' }
          ]
        }
        {
          type  : 'combobox'
          name  : 'combo2'
          label : 'hello'
          items : [
            { title: 'item 1', value: 'item1' }
            { title: 'item 2', value: 'item2' }
          ]
        }
      ]

    c1 = form.getInputByName('combo1')
    c2 = form.getInputByName('combo2')

    expect(c1.getItems().length).toBe 3
    expect(c2.getItems().length).toBe 2

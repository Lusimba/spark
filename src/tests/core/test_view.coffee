goog.require 'spark.core.Object'
goog.require 'spark.core.View'
goog.require 'spark.utils'


describe 'spark.core.View', ->


  view      = null
  element   = null
  isClicked = null
  isHovered = null

  fireEvent = (type) ->
    event = document.createEvent 'MouseEvents'
    event.initEvent type, yes, yes
    element.dispatchEvent event

  beforeEach ->
    isClicked       = null
    isHovered       = null
    options         =
      tagName       : 'span'
      cssClass      : 'hello buddy'
      domId         : 'world'
      template      : '<p>Hello World</p>'
      eventHandlers :
        click       : -> isClicked = yes
        mouseover   : -> isHovered = yes

    view            = new spark.core.View options
    element         = view.getElement()


  it 'should has default options if no options passed', ->
    v = new spark.core.View
    expect(v.getOptions()).not.toBe {}


  it 'should create a DOM element with passed options', ->
    expect(element).toBeDefined()
    expect(element.id).toBe 'world'
    expect(element.classList.contains('hello')).toBeTruthy()
    expect(element.firstChild.tagName).toBe 'P'


  it 'should be appendable to document body', ->
    # it will throw an error if it couldn't append it to dom
    # there is not assertion needed
    document.body.appendChild element


  it 'should bind events in eventHandlers object', ->
    expect(isClicked).toBe null
    expect(isHovered).toBe null

    fireEvent 'click'
    fireEvent 'mouseover'

    expect(isClicked).toBe yes
    expect(isHovered).toBe yes


  it 'should return dom id', ->
    expect(view.getDomId()).toBe 'world'

    newView = new spark.core.View
    expect(newView.getDomId()).toBeNull()


  it 'should set element template', ->
    expect(element.firstChild.tagName).toBe 'P'

    view.setTemplate '<div><span></span></div>'

    expect(element.firstChild.tagName).toBe 'DIV'
    expect(element.firstChild.firstChild.tagName).toBe 'SPAN'


  it 'should add new class', ->
    expect(element.classList.contains 'new-class').toBeFalsy()

    view.addClass 'new-class'

    expect(element.classList.contains 'new-class').toBeTruthy()


  it 'should remove a class name', ->
    expect(element.classList.contains 'hello').toBeTruthy()

    view.removeClass 'hello'

    expect(element.classList.contains 'hello').toBeFalsy()


  it 'should return class list as an array like', ->
    classList = view.getClassList()
    expect(classList.length).toBe 3 # view, hello, buddy


  it 'should return all class names', ->
    expect(view.getClass()).toBe 'view hello buddy'


  it 'should update class name', ->
    expect(element.classList.contains 'new-class-name').toBeFalsy()

    view.setClass 'new-class-name'

    expect(element.getAttribute 'class').toBe 'new-class-name'


  it 'should return true if element has a class name', ->
    expect(view.hasClass 'class-name').toBeFalsy()
    expect(view.hasClass 'hello').toBeTruthy()


  describe 'appendView', ->

    newOne     = new spark.core.View template : '<p>New View</p>'
    button     = null
    child      = null
    innerChild = null

    it 'should allow appending a new view into this view', ->
      view.appendView newOne

      child      = element.lastChild
      innerChild = child.firstChild

      expect(child.tagName).toBe 'DIV'
      expect(innerChild.tagName).toBe 'P'
      expect(innerChild.innerHTML).toBe 'New View'


    it 'should allow appending a new view into a view which is appended a different view', ->
      button     = new spark.components.Button
        title    : 'Test Button'
        cssClass : 'new-button'

      newOne.appendView button

      expect(newOne.getElement().lastChild).toBe button.getElement()


    it 'should throw error if a view already appended into this view', ->
      error = new Error 'This view already appended to target view.'

      expect( -> newOne.appendView button ).toThrow error


    it 'should throw error when view argument is not an instance of spark.View', ->
      error = new Error 'View should be an instance of spark.core.View'
      items = [ {}, [], null, undefined, 5, 'some string' ]

      expect( -> newOne.appendView item).toThrow error  for item in items


  it 'should append element to document body when appendToDocumentBody called', ->
      myView = new spark.core.View domId: 'myView'

      expect(document.getElementById('myView')).toBeNull()

      myView.appendToDocumentBody()

      expect(document.getElementById('myView')).not.toBeNull()


    it 'should remove element from document body if it is in the document', ->
      isRemoved = view.removeFromDocument()

      expect(isRemoved).toBeFalsy()

      view.appendToDocumentBody()

      isRemoved = view.removeFromDocument()

      expect(isRemoved).toBeTruthy()

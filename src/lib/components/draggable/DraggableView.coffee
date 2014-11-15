goog.provide 'spark.components.DraggableView'

goog.require 'spark.core.View'
goog.require 'goog.fx.Dragger'
goog.require 'goog.style'
goog.require 'goog.dom'


class spark.components.DraggableView extends spark.core.View


  ###*
    Draggable view for Spark Framework. It uses battle tested goog.fx.Dragger
    as a drag engine but comes with more fancy methods like containers.
    If you pass a container parameter which should be a DOM element or a View
    instance then the drag will only be allowed inside that container element
    or view. Draggable view listens for window resize and sets its limit again
    to not allow dragging offset of the container. You can also want to unset
    the container if you don't want to force dragging inside an element.
    By default, dragging will be allowed for all element. If you want to use a
    handle pass handle option either a view instance or an element.

    @constructor
    @export
    @param   {Object=} options Class options.
    @param   {*=} data Class data
    @extends {spark.core.View}
  ###
  constructor: (options = {}, data) ->

    @getCssClass options, 'draggable'

    ###*
      If you want to constrain drag inside an element, pass this option either
      a View instance or a DOM element.
    ###
    options.container or= options['container'] or null

    ###*
      To create a handle for draggable element, pass a View instance or DOM
      element to handle option. Make sure that, you appended handle view/element
      to this component. For now Spark won't append it for you.
    ###
    options.handle or= options['handle']    or null

    super options, data

    @dragger_ = new goog.fx.Dragger @getElement(), @getHandleElement_()

    if options.container
      @setContainer options.container

    goog.events.listen window, 'resize', =>
      @setLimits_()

    @once 'ViewHasParent', =>
      @setLimits_()


  ###*
    Sets drag limits relative to container element. This means dragging won't be
    available outside of that container element.

    @private
  ###
  setLimits_: ->
    return unless @getContainer()

    element = @getElement()

    return unless element.parentNode

    container     = @getContainer()
    sizes         = goog.style.getSize   element
    bounds        = goog.style.getBounds container
    bounds.width  = bounds.width  - sizes.width
    bounds.height = bounds.height - sizes.height

    @dragger_.setLimits bounds


  ###*
    Set container to force dragging inside that container element.

    @export
    @param {spark.core.View|Node} container Container to force dragging.
  ###
  setContainer: (container) ->
    if container instanceof spark.core.View
      @container = container.getElement()

    else if goog.dom.isElement container
      @container = container

    else
      throw new Error 'Drag container must be a View instance or a DOM element.'

    @setLimits_()


  ###*
    Unset container to free dragging area.
    @export
  ###
  unsetContainer: ->
    @container = null
    @dragger_.setLimits new goog.math.Rect NaN, NaN, NaN, NaN


  ###*
    Returns drag container.
    @export
    @return {Element}
  ###
  getContainer: ->
    return @container
  ###*
    Returns handle element if exists.

    @private
    @return {Element|null}
  ###
  getHandleElement_: ->
    handle = @getOptions().handle

    if handle instanceof spark.core.View
      return handle.getElement()

    else if goog.dom.isElement handle
      return handle

    return handle

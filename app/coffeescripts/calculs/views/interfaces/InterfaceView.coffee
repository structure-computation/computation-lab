# Interface View
SCViews.InterfaceView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
    @firstRendering = true
    
  tagName   : "li"
  className : "interface_view"   

  events: 
    "click"                 : "select"
    'click button.assign'   : 'assignInterfaceToLink'
    'click button.unassign' : 'unassignInterfaceToLink'

  # Assign the piece to a material
  assignInterfaceToLink: ->
    @parentElement.assignInterfaceToLink @model
    @addUnassignButton()

  # Unassign the piece from his material
  unassignInterfaceToLink: ->
    @parentElement.unassignInterfaceToLink @model
    @addAssignButton()

    
  # Highlight the selected Interface and tell the Link list to 
  # show the link of this interface. If it has no link associated, user can assign one to it.
  select: (event) ->
    if event.srcElement == @el
      @parentElement.render() # Clear all buttons from all piece view
      @parentElement.selectInterface @


  # If the interface has no link, it can be assigned to it.
  # If it already has a link, it can be unassigned to it
  # else, no button is rendered.
  linkHasBeenSelected: (linkModel) ->
    if @model.get('link_id') == linkModel.getId()
      @addUnassignButton()
    else if !@model.isAssigned()
      @addAssignButton()
    else
      @render()
      $(@el).removeClass('selected').addClass('gray')

  # Add a button for unassigning the interface from the selected link.
  addUnassignButton: ->
    @renderWithButton 'unassign', 'Désassigner'
    $(@el).addClass('selected').removeClass('gray')

  # Add a button for assigning the interface from the selected link.
  addAssignButton: ->
    @renderWithButton 'assign', 'Assigner'
    $(@el).removeClass('selected').removeClass('gray')

  # Render with an action button
  renderWithButton: (className, textButton)->
    $(@el).html(@model.get('name'))
    $(@el).append("<button class='#{className}'>#{textButton}</button>")
    return this

  render: ->
    if @firstRendering
      $(@parentElement.el).append(@el)
      @firstRendering = false
    $(@el).html(@model.get('id') + " - " + @model.get('name'))
    if @model.isAssigned()
      $(@el).append("<span class='is_assigned'>✓ [#{@model.get('link_id')}]</span>")
    else
      $(@el).append('<span class="is_not_assigned">?</span>')
    $(@el).removeClass('selected').removeClass('gray')
    return this


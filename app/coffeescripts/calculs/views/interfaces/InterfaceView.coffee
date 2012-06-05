# Interface View
SCViews.InterfaceView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@parentElement.el).find('tbody').append(@el)    
    @model.bind "change", @render, this

  tagName   : "tr"
  className : "interface_view"   

  events: 
    "click"                      : "selectionChanged"
    'click button.assign'        : 'assignInterfaceToLink'
    'click button.unassign'      : 'unassignInterfaceToLink'
    'click button.unassign_link' : 'unassignLink'

  # Add class to the element to highlight it
  select: ->
    $(@el).addClass("selected")
    
  # Remove class from the element
  deselect: ->
    $(@el).removeClass("selected")

  # Inform the ListView that a piece has been clicked
  selectionChanged: (event) ->
    if event.srcElement.tagName != "BUTTON"
      @parentElement.trigger("selection_changed:interfaces", this)
  

  # Assign the piece to a material
  assignInterfaceToLink: ->
    @parentElement.trigger "action:assign:interface", this

  # Unassign the piece from his material
  unassignInterfaceToLink: ->
    @parentElement.trigger "action:unassign:interface", this

  # Unassign the link from the interface
  unassignLink: ->
    @model.unset('link_id')
    # To keep buttons up to date regarding the interface selected
    SCVisu.linkListView.trigger("selection_changed:interfaces", this)
    @render()
    @select()

  # Show an unassign button to unassign link from selected interface
  showUnassignLinkButton: ->
    @renderWithButton 'unassign_link', 'Désassigner'
    $(@el).addClass('selected')
 
  # If the interface has no link, it can be assigned to it.
  # If it already has a link, it can be unassigned to it
  # else, no button is rendered.
  linkHasBeenSelected: (linkModel) ->
    if @model.get('link_id') == linkModel.getId()
      @showUnassignButton()
    else if !@model.isAssigned()
      @showAssignButton()
    else
      @render()
      $(@el).removeClass('selected')

  # Add a button for unassigning the interface from the selected link.
  showUnassignButton: ->
    @renderWithButton 'unassign', 'Désassigner'
    $(@el).addClass('selected')

  # Add a button for assigning the interface from the selected link.
  showAssignButton: ->
    @renderWithButton 'assign', 'Assigner'
    $(@el).removeClass('selected')

  # Render with an action button
  renderWithButton: (className, textButton) ->
    @render()
    $(@el).find('td:last').append("<button class='#{className}'>#{textButton}</button>")
    return this

  render: ->
    template = """
      <td>#{@model.get('id')}</td>
      <td>#{@model.get('name')}</td>
    """
    $(@el).html(template)
    if @model.isAssigned()
      $(@el).append("<td class='is_assigned'>#{@model.get('link_id')}</td>")
    else
      $(@el).append('<td>Parfaite</td>')
    $(@el).removeClass('selected')
    return this

  showView: ->
    @model.to_visualize = true

  hideView: ->
    #$(@el).hide()
    @model.to_visualize =  false
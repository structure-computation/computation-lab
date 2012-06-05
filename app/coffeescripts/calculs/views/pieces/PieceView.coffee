# Piece View
SCViews.PieceView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@parentElement.el).find('tbody').append(@el)

  tagName   : "tr"
  className : "piece_view"   

  events: 
    'click'                          : 'selectionChanged'
    'click button.assign'            : 'assignPieceToMaterial'
    'click button.unassign'          : 'unassignPieceToMaterial'
    'click button.unassign_material' : 'unassignMaterial'

  # Add class to the element to highlight it
  select: ->
    $(@el).addClass("selected")
    
  # Remove class from the element
  deselect: ->
    $(@el).removeClass("selected")

  # Inform the ListView that a piece has been clicked
  selectionChanged: (event) ->
    if event.srcElement.tagName != "BUTTON"
      @parentElement.trigger("selection_changed:pieces", this)

  # Assign the piece to a material
  assignPieceToMaterial: ->
    @parentElement.trigger "action:assign:piece", this

  # Unassign the piece from his material
  unassignPieceToMaterial: ->
    @parentElement.trigger "action:unassign:piece", this

  # Unassign the material from the piece
  unassignMaterial: ->
    @model.unset('material_id')
    # To keep buttons up to date regarding the piece selected
    SCVisu.materialListView.trigger("selection_changed:pieces", this)
    @render()
    @select()

  # Tells the view that a material has been selected.
  # If the piece has no material, it can be assigned to it.
  # If it already has a material, it can be unassigned to it
  # else, nothing is rendered.
  materialHasBeenSelected: (material) ->
    if @model.get('material_id') == material.getId()
      @showUnassignButton()
    else if _.isUndefined @model.get('material_id')
      @showAssignButton()
    else
      @render()

  # Add a button for unassigning the piece from the selected material.
  showUnassignButton: ->
    @renderWithButton 'unassign', 'Désassigner'
    $(@el).addClass('selected')

  # Show an unassign button to unassign material from selected piece
  showUnassignMaterialButton: ->
    @renderWithButton 'unassign_material', 'Désassigner'
    $(@el).addClass('selected')
    

  # Add a button for assigning the piece from the selected material.
  showAssignButton: ->
    @renderWithButton 'assign', 'Assigner'
    $(@el).removeClass('selected')

  # Render with an action button
  renderWithButton: (className, textButton)->
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
      $(@el).append "<td class='is_assigned'>#{@model.get('material_id')}</td>"
    else
      $(@el).append "<td>-</td>"
    $(@el).removeClass('selected')
    return this

  showView: ->
    @model.to_visualize = true

  hideView: ->
    #$(@el).hide()
    @model.to_visualize =  false
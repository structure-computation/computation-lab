# Piece View
SCModels.PieceView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
    @firstRendering = true
    
  tagName   : "li"
  className : "piece_view"   

  events: 
    'click'                 : 'select'
    'click button.assign'   : 'assignPieceToMaterial'
    'click button.unassign' : 'unassignPieceToMaterial'

  # Assign the piece to a material
  assignPieceToMaterial: ->
    @parentElement.assignPieceToMaterial @model
    @addUnassignButton()

  # Unassign the piece from his material
  unassignPieceToMaterial: ->
    @parentElement.unassignPieceToMaterial @model
    @addAssignButton()
    
  # Highlight the selected piece and tell the material list to 
  # show the material of this piece. If it has no material, a material can be assigned to it.
  select: (event) ->
    if event.srcElement == @el
      @parentElement.render() # Clear all buttons from all piece view
      @parentElement.selectPiece @

  # Tells the view that a material has been selected.
  # If the piece has no material, it can be assigned to it.
  # If it already has a material, it can be unassigned to it
  # else, nothing is rendered.
  materialHasBeenSelected: (material) ->
    if @model.get('material_id') == material.get('id')
      @addUnassignButton()
    else if _.isUndefined @model.get('material_id')
      @addAssignButton()
    else
      @render()

  # Add a button for unassigning the piece from the selected material.
  addUnassignButton: ->
    @renderWithButton 'unassign', 'Désassigner'
    $(@el).addClass('selected').removeClass('gray')

  # Add a button for assigning the piece from the selected material.
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
    $(@el).html(@model.get('name'))
    if @model.isAssigned()
      $(@el).append('<span class="is_assigned">✓</span>')
    else
      $(@el).append('<span class="is_not_assigned">?</span>')
    $(@el).removeClass('selected').removeClass('gray')
    return this


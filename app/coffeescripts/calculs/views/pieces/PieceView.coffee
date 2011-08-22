# Piece View
window.PieceView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
  
  tagName   : "li"
  className : "piece_view"   

  events: 
    'click span'            : 'select'
    'click button.assign'   : 'assign'

  # Assign the piece to a material
  assign: ->
    @parentElement.assign @model
    @addUnassignButton()
  
  # Highlight the selected piece and tell the material list to 
  # show the material of this piece. If it has no material, a material can be assigned to it.
  select: ->
    @parentElement.render()
    @parentElement.selectPiece @

  # Tells the view that a material has been selected.
  # If the piece has no material, it can be assigned to it.
  # If it already has a material, it can be unassigned to it
  # else, nothing is rendered.
  materialHasBeenSelected: (material) ->
    if @model.get('material_id') == material.get('id')
      @addUnassignButton()
    else if @model.get('material_id') == 0
      @renderWithButton 'assign', 'Assigner'
      $(@el).css('color', 'black')
    else
      @render()

  # Add a button for unassigning the piece from the selected material.
  addUnassignButton: ->
    @renderWithButton 'unassign', 'Désassigner'
    $(@el).css('color', 'green')
  # Render with an action button
  renderWithButton: (className, textButton)->
    $(@el).html('<span>' + @model.get('name') + '</span>')
    $(@el).append("<button class='#{className}'>#{textButton}</button>")
    $(@parentElement.el).append(@el)
    return this

  render: ->
    $(@el).html('<span>' + @model.get('name') + '</span>')
    $(@parentElement.el).append(@el)
    $(@el).css('color', 'black')
    return this



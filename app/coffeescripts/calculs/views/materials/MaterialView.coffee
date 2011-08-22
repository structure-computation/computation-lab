# Material View
window.MaterialView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
  
  tagName   : "li"
  className : "material_view"   
  
  events:
    "click button.edit"     : "show_details"
    "click button.clone"    : "clone"
    "click button.assign"   : "assign"
    "click button.unassign" : "unassign"
    "click span"            : "select"
  
  show_details: ->
    @trigger 'update_details_model', @model

  # Tell the parent that a material have been selected.
  # The row will be highlighted and pieces wich contains 
  # this material will be also highlighted.
  select: ->
    @parentElement.selectMaterial @
    @parentElement.render()

  # Clone the model of the clicked material view
  clone: ->
    @parentElement.clone @model

  # Show button for unassigning a material
  showUnassignButton: ->
    @parentElement.render()
    @renderWithButton 'unassign', 'Désassigner'
    $(@el).css('color', 'green')
  # Unassign the material from the selected Piece
  unassign: ->
    @parentElement.unassignMaterial @model

  # Show an "Assign" button to each View in order to be able to 
  # assign the material to the selected piece.
  showAssignButtons: ->
    @renderWithButton 'assign', 'Assigner'
  # Assign the clicked model to the selected piece
  assign: ->
    @parentElement.assignMaterialToSelectedPiece @model
    @parentElement.render()
    $(@el).css('color', 'green')
    @showUnassignButton()
    
  # Render the list view with an extra button for assigning or unassigning material.
  renderWithButton: (className, textButton) ->
    $(@el).html('<span>' + @model.get('name') + '</span>')
    $(@el).append("<button class='#{className}'>#{textButton}</button>")
    $(@parentElement.el).append(@el)
    return this
    
  render: ->
    @renderWithButton 'edit', 'Editer'



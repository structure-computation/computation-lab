# Material View
SCVisu.MaterialView = Backbone.View.extend
  initialize: (params) ->
    @parentElement  = params.parentElement
    @firstRendering = true
  tagName   : "li"
  className : "material_view"   
  
  events:
    "click button.edit"     : "showDetails"
    "click button.clone"    : "clone"
    "click button.assign"   : "assign"
    "click button.unassign" : "unassign"
    "click"                 : "select"
  
  showDetails: ->
    @trigger 'show_details_model', @model

  # Tell the parent that a material have been selected.
  # The row will be highlighted and pieces wich contains 
  # this material will be also highlighted.
  select: (event) ->
    if event.srcElement == @el
      @parentElement.render() # Clear all buttons from all material view
      @parentElement.selectMaterial @

  # Clone the model of the clicked material view
  clone: ->
    @parentElement.clone @model

  # Show button for unassigning a material
  showUnassignButton: ->
    @parentElement.render() # Remove all buttons from other material view because only one material can be assigned
    @renderWithButton 'unassign', 'Désassigner'
    @parentElement.highlightView @

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
    $(@el).addClass('selected').removeClass('gray')
    @showUnassignButton()
    
    
  # Render the list view with an extra button for assigning or unassigning material.
  renderWithButton: (className, textButton) ->
    $(@el).removeClass('selected').removeClass('gray')
    $(@el).html(@model.get('name'))
    $(@el).append("<button class='#{className}'>#{textButton}</button>")
    if @firstRendering
      $(@parentElement.el).append(@el)
      @firstRendering = false
    return this
    
  render: ->
    @renderWithButton 'edit', 'Editer'



# Material View
SCViews.MaterialView = Backbone.View.extend
  initialize: (params) ->
    @parentElement  = params.parentElement
    $(@parentElement.el).append(@el)
  tagName   : "li"
  className : "material_view"   
  
  events:
    "click button.edit"     : "showMaterialDetails"
    "click button.clone"    : "clone"
    "click button.assign"   : "assign"
    "click button.unassign" : "unassign"
    "click button.remove"   : "removeMaterial"
    "click"                 : "selectionChanged"
  
  # Add class to the element to highlight it
  select: ->
    $(@el).addClass("selected")
  # Remove class from the element
  deselect: ->
    $(@el).removeClass("selected")

  # Inform the ListView that a material has been clicked
  selectionChanged: (event) ->
    if event.srcElement.tagName != "BUTTON"
      @parentElement.trigger("selection_changed:materials", this)
  
  
  # Removing model from collection passing silent prevent from destroying from database
  # Also removing the view
  removeMaterial: ->
    if confirm "Êtes-vous sûr ?"
      SCVisu.pieceListView.trigger("action:removed_material", this)
      @parentElement.collection.remove @model
      SCVisu.current_calcul.trigger 'change'
      @remove()
  
  # Show details of a material
  showMaterialDetails: ->
    @parentElement.showDetails @model
    # Trigger selection change only when the material selected change because it
    # makes lose the focus
    @parentElement.trigger("selection_changed:materials", this) if @parentElement.selectedMaterialView != this

  # Clone the model of the clicked material view
  clone: ->
    @parentElement.clone @model
  
  # Show button for unassigning a material
  showUnassignButton: ->
    @parentElement.render() # Remove all buttons from other material view because only one material can be assigned
    @renderWithButton 'unassign', 'Désassigner'
    $(@el).addClass "selected"
  
  # Assign the clicked model to the selected piece
  assign: ->
    @parentElement.trigger "action:assign:material", this
    SCVisu.pieceListView.trigger "action:assign:material", this    

  # Unassign the material from the selected Piece
  unassign: ->
    @parentElement.trigger "action:unassign:material", this
    SCVisu.pieceListView.trigger "action:unassign:material", this
  
  # Show an "Assign" button to each View in order to be able to 
  # assign the material to the selected piece.
  showAssignButton: ->
    @renderWithButton 'assign', 'Assigner'
      
  # Render the list view with an extra button for assigning or unassigning material.
  renderWithButton: (className, textButton) ->
    $(@el).html(@model.get('id_in_calcul') + " - " + @model.get('name'))
    $(@el).append("<button class='remove'>X</button>")
    $(@el).append("<button class='#{className}'>#{textButton}</button>")
    return this
    
  render: ->
    @renderWithButton 'edit', 'Editer'



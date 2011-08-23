## MaterialListView
SCVisu.MaterialListView = Backbone.View.extend
  el: 'ul#materials'

  initialize: (options) ->
    @editView = new SCVisu.EditMaterialView parentElement: this
    @materialViews = []
    for material in @collection.models
      @createMaterialView(material)
    @selectedMaterial = null
    @clearView()
    @render()
    

  createMaterialView: (material) ->
    m = new SCVisu.MaterialView model: material, parentElement: this
    m.bind 'update_details_model', @update_details, this
    @materialViews.push m
    
  update_details: (model) ->
    @editView.updateModel model
      
  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#materials' element already exists in the DOM and every time we create a MaterialListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new MaterialListView 
  clearView: ->
    $(@el).html('')
    
  render : ->
    for m in @materialViews
      m.render()
    return this

  # Is executed when a material view has been clicked.
  # Tell the pieces view to show all pieces who have this material
  selectMaterial: (materialView) ->
    @highlightView materialView
    @selectedMaterial = materialView.model
    SCVisu.pieceListView.materialHasBeenSelected(materialView.model)

  # Highlight the material which have material_id as id
  highlightMaterial: (material_id) ->
    _.each @materialViews, (view) ->
      if view.model.get('id') == material_id
        $(view.el).addClass('selected').removeClass('gray')
        view.showUnassignButton()

  # Show an assign button to each material view
  showAssignButtons: ->
    _.each @materialViews, (view) ->
      $(view.el).removeClass('selected').removeClass('gray')
      view.showAssignButtons()

  # Assign the selected material to currently selected piece
  assignMaterialToSelectedPiece: (material) ->
    SCVisu.pieceListView.assignMaterialToSelectedPiece material

  # Unassign selected material to currently selected piece
  unassignMaterial: (material) ->
    SCVisu.pieceListView.unassignMaterialToSelectedPiece material
    @showAssignButtons()

  highlightView: (materialView) ->
    _.each @materialViews, (view) -> 
      $(view.el).addClass('gray').removeClass('selected')
    $(materialView.el).addClass('selected').removeClass('gray')











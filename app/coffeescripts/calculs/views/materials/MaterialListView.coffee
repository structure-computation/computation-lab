## MaterialListView
window.MaterialListView = Backbone.View.extend
  el: 'ul#materials'

  initialize: (options) ->
    @editView = new EditMaterialView parentElement: this
    @materialViews = []
    for material in @collection.models
      @createMaterialView(material)
    @selectedMaterial = null
    @render()
    

  createMaterialView: (material) ->
    m = new MaterialView model: material, parentElement: this
    m.bind 'update_details_model', @update_details, this
    @materialViews.push m
    
  update_details: (model) ->
    @editView.updateModel model   

  render : ->
    for m in @materialViews
      m.render()
    return this

  # Is executed when a material view has been clicked.
  # Tell the pieces view to show all pieces who have this material
  selectMaterial: (materialView) ->
    _.each @materialViews, (view) -> 
      $(view.el).css('color', 'gray')
    $(materialView.el).css("color","green")
    @selectedMaterial = materialView.model
    window.pieceListView.materialHasBeenSelected(materialView.model)

  # Highlight the material which have material_id as id
  highlightMaterial: (material_id) ->
    _.each @materialViews, (view) ->
      if view.model.get('id') == material_id
        $(view.el).css('color','green')
        view.showUnassignButton()

  # Show an assign button to each material view
  showAssignButtons: ->
    _.each @materialViews, (view) ->
      $(view.el).css('color','black')
      view.showAssignButtons()

  # Assign the selected material to currently selected piece
  assignMaterialToSelectedPiece: (material) ->
    window.pieceListView.assignMaterialToSelectedPiece material

  # Unassign selected material to currently selected piece
  unassignMaterial: (material) ->
    window.pieceListView.unassignMaterialToSelectedPiece material
    @showAssignButtons()














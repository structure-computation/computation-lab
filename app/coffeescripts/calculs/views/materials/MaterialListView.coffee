## MaterialListView
SCModels.MaterialListView = Backbone.View.extend
  el: 'ul#materials'

  initialize: (options) ->
    @editView = new SCVisu.EditMaterialView parentElement: this
    @materialViews = []
    for material in @collection.models
      @createMaterialView(material)
    @selectedMaterial = null
    $('#materials_database button.close').click -> $('#materials_database').hide()
    @render()
  
  events:
    "click button.add_material" : "showDatabaseMaterials"
    
  showDatabaseMaterials: ->
    $('#materials_database').show()
    @editView.hide()

  # Add a material to the collection and create an associated view
  add: (materialModel) ->
    @collection.models.push materialModel
    @createMaterialView materialModel

  createMaterialView: (material) ->
    m = new SCModels.MaterialView model: material, parentElement: this
    m.bind 'show_details_model', @showDetails, this
    @materialViews.push m
    @render()
    
  showDetails: (model) ->
    $('#materials_database').hide()
    @editView.updateModel model
    
  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#materials' element already exists in the DOM and every time we create a MaterialListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new MaterialListView 
  clearView: ->
    $(@el).html('')


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

  render : ->
    for m in @materialViews
      m.render()
    $(@el).find(".add_material").remove() if $(@el).find(".add_material")
    $(@el).append('<button class="add_material">Ajouter un matériau</button>')
    return this
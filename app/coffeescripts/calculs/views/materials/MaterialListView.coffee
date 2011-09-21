## MaterialListView
SCViews.MaterialListView = Backbone.View.extend
  el: 'ul#materials'

  initialize: (options) ->

    @clearView()
    @editView = new SCViews.EditMaterialView parentElement: this
    @materialViews = []
    for material in @collection.models
      @createMaterialView(material)
    @selectedMaterialView = null

    @collection.bind 'add'   , @saveCalcul, this

    $('#materials_database').hide()
    $('#materials_database button.close').click => 
      $('#materials_database').slideUp()
      $('#list_calcul > div') .slideDown()
      @editView.hide()

    @collection.bind 'change', (model) =>
      @render()
      @selectedMaterialView.select() if @selectedMaterialView != null and model == @selectedMaterialView.model
      @saveCalcul()
    @collection.bind 'remove', (materialModel) =>
      if @selectedMaterialView != null and materialModel == @selectedMaterialView.model
        @editView.hide()
        @render()
      @saveCalcul()
      
    @render()
      
    # Triggered when a material is clicked
    @bind "selection_changed:materials", (selectedMaterialView) =>
      @render() # Reset all views
      # Hide edit view if the model selected is not the same as the one in the edit view
      @editView.hide() if @selectedMaterialView == selectedMaterialView or @editView.model != selectedMaterialView.model

      if @selectedMaterialView == selectedMaterialView
        @selectedMaterialView.deselect()
        @selectedMaterialView = null
        SCVisu.pieceListView.trigger("selection_changed:materials", null)
      else
        @selectedMaterialView.deselect() if @selectedMaterialView
        @selectedMaterialView = selectedMaterialView
        @selectedMaterialView.select()
        SCVisu.pieceListView.trigger("selection_changed:materials", @selectedMaterialView)

      
    # Triggered when a piece is clicked
    @bind "selection_changed:pieces", (selectedPieceView) =>
      @selectedMaterialView.deselect() if @selectedMaterialView
      @selectedMaterialView = null
      @editView.hide()
      @render() # Reset all views
      
      if selectedPieceView != null
        # If the selected piece is not null, then there is two possibilities:
        # The piece is already assigned to a material 
        if !_.isUndefined(selectedPieceView.model.get('material_id'))
          # Then we have to select this material and show an unassign button
          for materialView in @materialViews
            if materialView.model.getId() == selectedPieceView.model.get('material_id')
              materialView.select()
              materialView.showUnassignButton()
              break
        # The piece doesn't have a material assigned yet
        else
          # Then we have to show assign buttons
          _.each @materialViews, (materialView) =>
            materialView.showAssignButton()

    @bind "action:unassign:material", (materialView) =>
      materialView.deselect()
      _.each @materialViews,  (view) =>
        view.showAssignButton()
            
    @bind "action:assign:material", (materialView) =>
      @render()
      materialView.showUnassignButton()


  events:
    "click button.add_material" : "showDatabaseMaterials"
    
  showDatabaseMaterials: ->
    $('#list_calcul > div') .slideUp()
    $('#materials_database').slideDown()
    
  # Add a material to the collection and create an associated view
  add: (materialModel) ->
    #materialModel.set id_in_calcul : @getNewMaterialId()
    @collection.add materialModel
    @createMaterialView materialModel
  


  createMaterialView: (material) ->
    m = new SCViews.MaterialView model: material, parentElement: this
    @materialViews.push m
    @render()
  
  # Show edit view of the given model.
  # Readonly make all inputs unaccessible
  showDetails: (model, readonly = false) ->
    @editView.updateModel model, readonly

  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#materials' element already exists in the DOM and every time we create a MaterialListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new MaterialListView 
  clearView: ->
    $(@el).html('')

  # Show an assign button to each material view
  showAssignButtons: ->
    _.each @materialViews, (view) ->
      $(view.el).removeClass('selected')
      view.showAssignButton()

  saveCalcul: ->
    SCVisu.current_calcul.set materials: @collection.models  
    SCVisu.current_calcul.set pieces: SCVisu.pieceListView.collection.models  
    SCVisu.current_calcul.trigger 'change'

  render : ->
    for materialView in @materialViews
      materialView.render()
      materialView.deselect()
    $(@el).find(".add_material").remove() if $(@el).find(".add_material")
    $(@el).append('<button class="add_material">Ajouter un matériau</button>')
    return this
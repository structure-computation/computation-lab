## PieceListView
SCViews.PieceListView = Backbone.View.extend
  el: '#pieces'
  
  # You have to pass a PieceCollection at initialisation as follow:
  # new SCVisu.pieceListView({ collection : myPieceCollection })
  initialize: ->
    @clearView()
    @pieceViews = []
    for piece in @collection.models
      @pieceViews.push new SCViews.PieceView model: piece, parentElement: this
    @selectedPieceView = null
    @render()
    $('#pieces').tablesorter()

     # Triggered when a piece is clicked
    @bind "selection_changed:pieces", (selectedPieceView) =>
      @render() # Reset all views
      if @selectedPieceView == selectedPieceView
        @selectedPieceView.deselect()
        @selectedPieceView = null
        SCVisu.materialListView.trigger("selection_changed:pieces", null)
      else
        @selectedPieceView.deselect() if @selectedPieceView
        @selectedPieceView = selectedPieceView
        @selectedPieceView.select()
        SCVisu.materialListView.trigger("selection_changed:pieces", @selectedPieceView)


     # Triggered when a material is clicked
    @bind "selection_changed:materials", (selectedMaterialsView) =>
      @selectedPieceView.deselect() if @selectedPieceView
      @selectedPieceView = null
      @render() # Reset all views
      if selectedMaterialsView != null
        $("button.assign_all, button.unassign_all").removeAttr('disabled')
        # On each piece, 
        # - If it is not assigned yet                                       -> we show an assign button
        # - If it is assigned and have the same id of the selected material -> We show Unassigned button
        # - Else, we do nothing
        _.each @pieceViews, (pieceView) =>
          if _.isUndefined(pieceView.model.get('material_id'))
            pieceView.showAssignButton()
          else if pieceView.model.get('material_id') == selectedMaterialsView.model.getId()
            pieceView.select()
            pieceView.showUnassignButton()

    # Check if a piece had the material associated to it before. 
    # If it is the case, then it removes the association
    @bind "action:removed_material", (materialView) =>
      _.each @collection.models, (piece) ->
        if piece.get('material_id') == materialView.model.getId()
          piece.unset 'material_id'
      @render()
 
  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#pieces' element already exists in the DOM and every time we create a PiecesListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new PiecesListView 
  clearView: ->
   $(@el).find('tbody').html('')
    
  # Assign the pieceModel to the selected Material.
  assignPieceToMaterial: (pieceModel) ->
    pieceModel.set 'material_id' : SCVisu.materialListView.selectedMaterialView.model.getId()
    SCVisu.current_calcul.set pieces: SCVisu.pieceListView.collection.models
    SCVisu.current_calcul.trigger 'change'
    
  # Assign the pieceModel to the selected Material.
  unassignPieceToMaterial: (pieceModel) ->
    pieceModel.unset 'material_id'
    SCVisu.current_calcul.set pieces: SCVisu.pieceListView.collection.models
    SCVisu.current_calcul.trigger 'change'
    
  # Assign the selected material to the currently selected piece.
  assignMaterialToSelectedPiece: (material) ->
    @selectedPieceView.model.set material_id: material.getId()
    SCVisu.current_calcul.set pieces: SCVisu.pieceListView.collection.models
    SCVisu.current_calcul.trigger 'change'
    @render()
    $(@selectedPieceView.el).addClass("selected")
    
  # Unassign the selected material from the currently selected piece.
  unassignMaterialToSelectedPiece: ->
    @selectedPieceView.model.unset 'material_id'
    SCVisu.current_calcul.set pieces: SCVisu.pieceListView.collection.models
    SCVisu.current_calcul.trigger 'change'
    @render()
    $(@selectedPieceView.el).removeClass("selected")

  events:
    'change input#hide_assigned_pieces'   : 'toggleAssignedPieces'
    'click button.assign_all'             : 'assignAllVisiblePieces'
    'click button.unassign_all'           : 'unassignAllVisiblePieces'
  
  # If the checkbox is checked, hide all assigned pieces
  toggleAssignedPieces: (event) ->
    if event.srcElement.checked
      _.each @pieceViews, (pieceView) ->
        $(pieceView.el).hide() if pieceView.model.isAssigned()
    else
      _.each @pieceViews, (pieceView) ->
        $(pieceView.el).show()

  # Assign all visible pieces which are visible to the selected material
  assignAllVisiblePieces: ->
    _.each @pieceViews, (pieceView) ->
      if $(pieceView.el).is(':visible')
        pieceView.model.set "material_id" : SCVisu.materialListView.selectedMaterialView.model.getId()
        pieceView.showUnassignButton()

  # Assign all visible pieces which are visible to the selected material
  unassignAllVisiblePieces: ->
    _.each @pieceViews, (pieceView) ->
      if $(pieceView.el).is(':visible')
        pieceView.model.unset "material_id"
        pieceView.showAssignButton()

  render : ->
    $("button.assign_all, button.unassign_all").attr('disabled', 'disabled')
    _.each @pieceViews, (pieceView) ->
      pieceView.render()
      pieceView.deselect()
    return this

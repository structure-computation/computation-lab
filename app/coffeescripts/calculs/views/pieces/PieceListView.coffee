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
    $(@el).find('table').tablesorter()

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
        @selectedPieceView.showUnassignMaterialButton() if @selectedPieceView.model.isAssigned()
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

    # Triggered when the unassigned button of a material is clicked.
    # Unassign the material from the current piece
    @bind "action:unassign:material", (materialView) =>
      @selectedPieceView.model.unset "material_id"
      @selectedPieceView.render()
      @selectedPieceView.select()

    # Triggered when the assigned button of a material is clicked.
    # Assign the current piece to the given material view
    @bind "action:assign:material", (materialView) =>
      @selectedPieceView.model.set material_id: materialView.model.getId()
      @selectedPieceView.render()
      @selectedPieceView.showUnassignMaterialButton()
      @selectedPieceView.select()

    # Triggered when the assigned button of a piece is clicked.
    # Assign the current piece to the currently selected material
    @bind "action:assign:piece", (pieceView) =>
      pieceView.model.set material_id: SCVisu.materialListView.selectedMaterialView.model.getId()
      pieceView.showUnassignButton()
      pieceView.select()
      @saveCalcul()
      
    # Triggered when the unassigned button of a piece is clicked.
    # Unassign the material from the current piece
    @bind "action:unassign:piece", (pieceView) =>
      pieceView.model.unset "material_id"
      pieceView.showAssignButton()
      @saveCalcul()

  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#pieces' element already exists in the DOM and every time we create a PiecesListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new PiecesListView 
  clearView: ->
   $(@el).find('tbody').html('')
    
  saveCalcul: ->
    SCVisu.current_calcul.set pieces: SCVisu.pieceListView.collection.models
    SCVisu.current_calcul.trigger 'change'

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

  getPiece: (pieceID) ->
    # I don't go through @collection.each because it would go through all 
    # elements and would not stop on return statement
    for piece in @collection.models
      if parseInt(piece.get('id'),10) == parseInt(pieceID,10)
        return piece

  
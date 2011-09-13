## PieceListView
SCViews.PieceListView = Backbone.View.extend
  el: 'table#pieces'
  
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
 
  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#pieces' element already exists in the DOM and every time we create a PiecesListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new PiecesListView 
  clearView: ->
   $(@el).find('tbody').html('')

  # Is executed when user click on a piece.
  # Highlight the selected piece and put others in gray.
  # If the selected piece has already a material, it will be highlighted and the user will have the 
  # possibility to unassign it.
  # Else, he will be able to select a material for the selected piece.
  selectPiece: (pieceView) ->
    @selectedPieceView = pieceView
    @highlightPieceView pieceView
    if pieceView.model.isAssigned()
      SCVisu.materialListView.highlightMaterial(pieceView.model.get('material_id'))
    else
      SCVisu.materialListView.showAssignButtons()
  highlightPieceView: (pieceView) ->
    _.each @pieceViews, (piece) ->
      $(piece.el).addClass('gray').removeClass('selected')
    $(pieceView.el).addClass('selected').removeClass('gray')

  # Add an "Assign" button to each piece view in order that the user can 
  # assign it to a selected material. 
  # And an unassigned button to pieces whith which have the same material_id 
  # that the selected material.
  materialHasBeenSelected: (material) ->
    _.each @pieceViews, (pieceView) ->
      $(pieceView.el).addClass('selected').removeClass('gray')
      pieceView.materialHasBeenSelected material
  
  # Assign the pieceModel to the selected Material.
  assignPieceToMaterial: (pieceModel) ->
    pieceModel.set 'material_id' : SCVisu.materialListView.selectedMaterial.getId()
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
    @highlightPieceView @selectedPieceView
    
  # Unassign the selected material from the currently selected piece.
  unassignMaterialToSelectedPiece: ->
    @selectedPieceView.model.unset 'material_id'
    SCVisu.current_calcul.set pieces: SCVisu.pieceListView.collection.models
    SCVisu.current_calcul.trigger 'change'
    @render()
    @highlightPieceView @selectedPieceView

  # Check if a piece had the material associated to it before. 
  # If it is the case, then it removes the association
  materialHasBeenRemoved: (material) ->
    _.each @collection.models, (piece) ->
      if piece.get('material_id') == material.getId()
        piece.unset 'material_id'
    @render()

  render : ->
    _.each @pieceViews, (piece) ->
      piece.render()
    return this

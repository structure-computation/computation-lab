## PieceListView
window.PieceListView = Backbone.View.extend
  el: 'ul#pieces'
  
  # You have to pass a PieceCollection at initialisation as follow:
  # new PieceListView({ collection : myPieceCollection })
  initialize: ->
    @pieceViews = []
    for piece in @collection.models
      @pieceViews.push new PieceView model: piece, parentElement: this
    @selectedPieceView = null
    @render()
        
  # Is executed when user click on a piece.
  # Highlight the selected piece and put others in gray.
  # If the selected piece has already a material, it will be highlighted and the user will have the 
  # possibility to unassign it.
  # Else, he will be able to select a material for the selected piece.
  selectPiece: (pieceView) ->
    @selectedPieceView = pieceView
    _.each @pieceViews, (pieceView) ->
      $(pieceView.el).addClass('gray').removeClass('selected')
    $(pieceView.el).addClass('selected').removeClass('gray')
    if pieceView.model.get('material_id') == 0
      window.MaterialViews.showAssignButtons()
    else
      window.MaterialViews.highlightMaterial(pieceView.model.get('material_id'))

  # Add an "Assign" button to each piece view in order that the user can 
  # assign it to a selected material. 
  # And an unassigned button to pieces whith which have the same material_id 
  # that the selected material.
  materialHasBeenSelected: (material) ->
    _.each @pieceViews, (pieceView) ->
      $(pieceView.el).addClass('gray').removeClass('selected')
      pieceView.materialHasBeenSelected material
  
  # Assign the pieceModel to the selected Material.
  assign: (pieceModel) ->
    pieceModel.setMaterial(window.MaterialViews.selectedMaterial)

  # Assign the selected material to the currently selected piece.
  assignMaterialToSelectedPiece: (material) ->
    @selectedPieceView.model.set material_id: material.get('id')

  # Unassign the selected material from the currently selected piece.
  unassignMaterialToSelectedPiece: ->
    @selectedPieceView.model.set material_id: 0
    
  render : ->
    for piece in @pieceViews
      piece.render()
    return this

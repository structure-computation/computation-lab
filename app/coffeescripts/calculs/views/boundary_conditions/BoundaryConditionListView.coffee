## PieceListView
SCModels.BoundaryConditionListView = Backbone.View.extend
  el: 'ul#boundary_conditions'
  
  # You have to pass a PieceCollection at initialisation as follow:
  # new SCVisu.pieceListView({ collection : myPieceCollection })
  initialize: ->
    @clearView()
    @boundaryConditionViews = []
    for boundaryCondition in @collection.models
      @boundaryConditionViews.push new SCModels.BoundaryConditionView model: boundaryCondition, parentElement: this
    @render()

  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#pieces' element already exists in the DOM and every time we create a PiecesListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new PiecesListView 
  clearView: ->
    $(@el).html('')
    
  render : ->
    _.each @boundaryConditionViews, (boundaryCondition) ->
      boundaryCondition.render()
    return this
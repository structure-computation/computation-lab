## BoundaryConditionListView
SCViews.BoundaryConditionListView = Backbone.View.extend
  el: 'ul#boundary_conditions'
  
  # You have to pass a PieceCollection at initialisation as follow:
  # new SCVisu.pieceListView({ collection : myPieceCollection })
  initialize: ->
    @clearView()
    @boundaryConditionViews = []
    @selectedBoundaryCondition = null
    @editBoundaryConditionView = new SCViews.EditBoundaryConditionView()
    
    for boundaryCondition in @collection.models
      @boundaryConditionViews.push new SCViews.BoundaryConditionView model: boundaryCondition, parentElement: this
    
    @render()
    @collection.bind 'change', @render, this
    @collection.bind 'add'   , @render, this


  events:
    "click .add" : "add_condition"

  show: ->
    $(@el).show()
    
  add_condition: ->
    $("#new_edge_form").hide()
    @show()
    boundaryCondition           = new SCModels.BoundaryCondition
    @boundaryConditionViews.push  new SCViews.BoundaryConditionView model: boundaryCondition, parentElement: this
    @collection.add               boundaryCondition
    @editBoundaryConditionView.setModel boundaryCondition

  # setNewSelectedModel is executed when a child view indicate it has been selected.
  # It set the current selected model to "non selected" (which trigger an event that redraw its line).
  setNewSelectedModel: (boundaryConditionView) ->
    @selectedBoundaryCondition.model.unset "selected" if @selectedBoundaryCondition
    @selectedBoundaryCondition = boundaryConditionView
    @editBoundaryConditionView.setModel boundaryConditionView.model
    SCVisu.edgeListView.boundaryConditionHasBeenSelected @editBoundaryConditionView
    $("#new_edge_form").hide()

  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#boundary_conditions' element already exists in the DOM and every time we create a BoundaryConditionListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new BoundaryConditionListView 
  clearView: ->
    $(@el).html('')
    
  render: ->
    SCVisu.current_calcul.set boundary_condition: @collection
    _.each @boundaryConditionViews, (boundaryCondition) ->
      boundaryCondition.render()
    $(@el).find('button.add').remove()
    $(@el).append "<button class='add'>Ajouter une condition limite</button>"
    return this
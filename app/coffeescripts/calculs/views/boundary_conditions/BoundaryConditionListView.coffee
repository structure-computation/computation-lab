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
    @collection.bind 'add'   , (boundaryCondition) =>
      boundaryConditionView       = new SCViews.BoundaryConditionView model: boundaryCondition, parentElement: this
      @boundaryConditionViews.push  boundaryConditionView
      @setNewSelectedModel          boundaryConditionView
      @render()


  events:
    "click .add" : "addCondition"

  # Show itself
  show: ->
    $(@el).show()

  # Show an assign button to each condition view
  showAssignButtons: ->
    _.each @boundaryConditionViews, (view) ->
      view.showAssignButton()

  # Highlight the condition with the given "condition_id".
  # Also show unassign button because it is called when an edge is selected
  highlightCondition: (condition_id)->
    for conditionView in @boundaryConditionViews
      if conditionView.model.get('id_in_calcul') == condition_id
        @render()
        conditionView.showUnassignButton()
        break

  # Update the calcul json
  updateCalcul: ->
    SCVisu.current_calcul.set boundary_conditions: @collection.models
    SCVisu.current_calcul.trigger 'change'

  # Add a new boundary condition (model and view)
  addCondition: ->
    $("#edit_edge_form").hide()
    @show()
    boundaryCondition                 = new SCModels.BoundaryCondition()
    @collection.add                     boundaryCondition
    SCVisu.current_calcul.trigger       'change'
    
  # setNewSelectedModel is executed when a child view indicate it has been selected.
  # It set the current selected model to "non selected" (which trigger an event that redraw its line).
  setNewSelectedModel: (boundaryConditionView) ->
    @selectedBoundaryCondition = boundaryConditionView
    @editBoundaryConditionView.setModel boundaryConditionView.model
    SCVisu.edgeListView.boundaryConditionHasBeenSelected(boundaryConditionView.model)
    $("#edit_edge_form").hide()
    @render()

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
    $(@selectedBoundaryCondition.el).addClass 'selected' if @selectedBoundaryCondition
    $(@el).find('button.add').remove()
    $(@el).append "<button class='add'>Ajouter une condition limite</button>"
    return this
## BoundaryConditionListView
SCViews.BoundaryConditionListView = Backbone.View.extend
  el: 'ul#boundary_conditions'
  
  # You have to pass a EdgeCollection at initialisation as follow:
  # new SCVisu.edgeListView({ collection : myEdgeCollection })
  initialize: ->
    @clearView()
    @boundaryConditionViews = []
    @selectedBoundaryConditionView = null
    @editView = new SCViews.EditBoundaryConditionView()
    
    for boundaryCondition in @collection.models
      @boundaryConditionViews.push new SCViews.BoundaryConditionView model: boundaryCondition, parentElement: this
    @render()
    
    @collection.bind 'change', (model) =>
      @render()
      @selectedBoundaryConditionView.select() if @selectedBoundaryConditionView != null and model == @selectedBoundaryConditionView.model
      @saveCalcul()
    @collection.bind 'remove', (boundaryConditionModel) =>
      if boundaryConditionModel == @selectedBoundaryConditionView.model
        @editView.hide()
        @render()
      @saveCalcul()
    @collection.bind 'add'   , (boundaryCondition) =>
      boundaryConditionView       = new SCViews.BoundaryConditionView model: boundaryCondition, parentElement: this
      @boundaryConditionViews.push  boundaryConditionView
      @render()
      $(boundaryConditionView.el).addClass("selected")
      @saveCalcul()

    # Triggered when a boundaryCondition is clicked
    @bind "selection_changed:boundary_conditions", (selectedBoundaryConditionView) =>
      @render() # Reset all views

      # Hide edit view if the model selected is not the same as the one in the edit view
      @editView.hide() if @selectedBoundaryConditionView == selectedBoundaryConditionView or @editView.model != selectedBoundaryConditionView.model

      if @selectedBoundaryConditionView == selectedBoundaryConditionView
        @selectedBoundaryConditionView.deselect()
        @selectedBoundaryConditionView = null
        SCVisu.edgeListView.trigger("selection_changed:boundary_conditions", null)
      else
        @selectedBoundaryConditionView.deselect() if @selectedBoundaryConditionView
        @selectedBoundaryConditionView = selectedBoundaryConditionView
        @selectedBoundaryConditionView.select()
        SCVisu.edgeListView.trigger("selection_changed:boundary_conditions", @selectedBoundaryConditionView)

    # Triggered when a edge is clicked
    @bind "selection_changed:edges", (selectedEdgeView) =>
      @selectedBoundaryConditionView.deselect() if @selectedBoundaryConditionView
      @selectedBoundaryConditionView = null
      @editView.hide()
      @render() # Reset all views
      
      if selectedEdgeView != null
        # If the selected edge is not null, then there is two possibilities:
        # The edge is already assigned to a boundaryCondition 
        if !_.isUndefined(selectedEdgeView.model.get('boundary_condition_id'))
          # Then we have to select this boundaryCondition and show an unassign button
          for boundaryConditionView in @boundaryConditionViews
            if boundaryConditionView.model.getId() == selectedEdgeView.model.get('boundary_condition_id')
              boundaryConditionView.select()
              boundaryConditionView.showUnassignButton()
              break
        # The edge doesn't have a boundaryCondition assigned yet
        else
          # Then we have to show assign buttons
          _.each @boundaryConditionViews, (boundaryConditionView) =>
            boundaryConditionView.showAssignButton()

    # Triggered when a edge is remove
    @bind "action:removed_edge", (edgeView) =>
      _.each @collection.models, (boundaryCondition) ->
        if boundaryCondition.get('edge_id') == edgeView.model.getId()
          boundaryCondition.unset 'edge_id'
      @render()

    @bind "action:unassign:boundary_condition", (boundaryConditionView) =>
      boundaryConditionView.deselect()
      _.each @boundaryConditionViews,  (view) =>
        view.showAssignButton()
      
    @bind "action:assign:boundary_condition", (boundaryConditionView) =>
      @render()
      boundaryConditionView.showUnassignButton()

  events:
    "click .add" : "addCondition"

  # Show an assign button to each condition view
  showAssignButtons: ->
    _.each @boundaryConditionViews, (view) ->
      view.showAssignButton()

  # Update the calcul json
  updateCalcul: ->
    SCVisu.current_calcul.set boundary_conditions: @collection.models
    SCVisu.current_calcul.trigger 'change'

  # Add a new boundary condition (model and view)
  addCondition: ->
    $("#edge_form").hide()
    boundaryCondition                 = new SCModels.BoundaryCondition()
    @collection.add                     boundaryCondition
    @editView.setModel boundaryCondition
    SCVisu.current_calcul.trigger       'change'

  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#boundary_conditions' element already exists in the DOM and every time we create a BoundaryConditionListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new BoundaryConditionListView 
  clearView: ->
    $(@el).html('')
    
  # Show edit view of the given model.
  showDetails: (model) ->
    @editView.setModel model

  # Update the calcul JSON
  saveCalcul: ->
    SCVisu.current_calcul.set boundary_conditions: @collection.models
    SCVisu.current_calcul.set edges: SCVisu.edgeListView.collection.models
    SCVisu.current_calcul.trigger 'change'

  render: ->
    SCVisu.current_calcul.set boundary_conditions : @collection
    _.each @boundaryConditionViews, (boundaryCondition) ->
      boundaryCondition.render()
      boundaryCondition.deselect()
    $(@el).find('button.add').remove()
    $(@el).append "<button class='add'>Ajouter une condition limite</button>"
    return this
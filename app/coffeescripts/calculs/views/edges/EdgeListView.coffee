## EdgeListView
SCViews.EdgeListView = Backbone.View.extend
  el: '#edges'

  initialize: (options) ->
    @clearView()
    @edgeViews = []
    @editView = new SCViews.EditEdgeView()
    @editView.hide()
    for edge in @collection.models
      @edgeViews.push new SCViews.EdgeView model: edge, parentElement: @
    @selectedEdgeView = null

    @render()
    $(@el).find('table').tablesorter()

    @collection.bind 'change', (model) =>
      @selectedEdgeView.render() if  @selectedEdgeView != null and model == @selectedEdgeView.model
      @saveCalcul()
    @collection.bind 'add'   , =>
      @render()
      @saveCalcul()
    @collection.bind 'remove', (edgeModel) => 
      if edgeModel == @selectedEdgeView.model
        @editView.hide()
        @render()
      @saveCalcul()
      
    # Triggered when a edge is clicked
    @bind "selection_changed:edges", (selectedEdgeView) =>
      @render() # Reset all views

      # Hide edit view if the model selected is not the same as the one in the edit view
      @editView.hide() if selectedEdgeView == @selectedEdgeView or @editView.model != selectedEdgeView.model

      if @selectedEdgeView == selectedEdgeView
        @selectedEdgeView.deselect()
        @selectedEdgeView = null
        SCVisu.boundaryConditionListView.trigger("selection_changed:edges", null)
      else
        @selectedEdgeView.deselect() if @selectedEdgeView
        @selectedEdgeView = selectedEdgeView
        @selectedEdgeView.select()
        @selectedEdgeView.showUnassignBoundaryConditionButton() if @selectedEdgeView.model.isAssigned()
        SCVisu.boundaryConditionListView.trigger("selection_changed:edges", @selectedEdgeView)


    # Triggered when a boundaryCondition is clicked
    @bind "selection_changed:boundary_conditions", (selectedBoundaryConditionsView) =>
      @selectedEdgeView.deselect() if @selectedEdgeView
      @selectedEdgeView = null
      @editView.hide()
      @render() # Reset all views
      if selectedBoundaryConditionsView != null
        $("button.assign_all, button.unassign_all").removeAttr('disabled')
        # On each edge, 
        # - If it is not assigned yet                                       -> we show an assign button
        # - If it is assigned and have the same id of the selected boundaryCondition -> We show Unassigned button
        # - Else, we do nothing
        _.each @edgeViews, (edgeView) =>
          if _.isUndefined(edgeView.model.get('boundary_condition_id'))
            edgeView.showAssignButton()
          else if edgeView.model.get('boundary_condition_id') == selectedBoundaryConditionsView.model.getId()
            edgeView.select()
            edgeView.showUnassignButton()

    # Check if a edge had the boundaryCondition associated to it before. 
    # If it is the case, then it removes the association
    @bind "action:removed_boundary_condition", (boundaryConditionView) =>
      _.each @collection.models, (edge) ->
        if edge.get('boundary_condition_id') == boundaryConditionView.model.getId()
          edge.unset 'boundary_condition_id'
      @render()      

    # Triggered when the unassigned button of a boundary condition is clicked.
    # Unassign the boundary condition from the current edge
    @bind "action:unassign:boundary_condition", (boundaryConditionView) =>
      @selectedEdgeView.model.unset "boundary_condition_id"
      @selectedEdgeView.render()
      @selectedEdgeView.select()

    # Triggered when the assigned button of a boundary_condition is clicked.
    # Assign the current edge to the given boundary_condition view
    @bind "action:assign:boundary_condition", (boundaryConditionView) =>
      @selectedEdgeView.model.set boundary_condition_id: boundaryConditionView.model.getId()
      @selectedEdgeView.render()
      @selectedEdgeView.showUnassignBoundaryConditionButton()
      @selectedEdgeView.select()

    # Triggered when the assigned button of a edge is clicked.
    # Assign the current edge to the currently selected boundary_condition
    @bind "action:assign:edge", (edgeView) =>
      edgeView.model.set boundary_condition_id: SCVisu.boundaryConditionListView.selectedBoundaryConditionView.model.getId()
      edgeView.showUnassignButton()
      edgeView.select()
      
    # Triggered when the unassigned button of a edge is clicked.
    # Unassign the boundary_condition from the current edge
    @bind "action:unassign:edge", (edgeView) =>
      edgeView.model.unset "boundary_condition_id"
      edgeView.showAssignButton()

  addEdgeModel: (edgeModel) ->
    @editView.hide()
    @edgeViews.push new SCViews.EdgeView model: edgeModel, parentElement: @
    @collection.add edgeModel
    @render()

  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#boundaryConditions' element already exists in the DOM and every time we create a BoundaryConditionListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new BoundaryConditionListView 
  clearView: ->
    $(@el).find('table tbody').html('')  
    
  # Shows the new edge form
  showNewEdgeForm: ->
    $('#boundary_condition_form').hide()
    @render()
    @editView.showAndInitialize()

  # Called from edit view when user wants to create a new edge.
  # Create a view associated to the given model
  events:
    'change input#hide_assigned_edges' : 'toggleAssignedEdges'
    'click button.assign_all'          : 'assignAllVisibleEdges'
    'click button.unassign_all'        : 'unassignAllVisibleEdges'
    'click button.new_edge'            : 'showNewEdgeForm'

  
  # If the checkbox is checked, hide all assigned interfaces
  toggleAssignedEdges: (event) ->
    if event.srcElement.checked
      _.each @edgeViews, (edgeView) ->
        $(edgeView.el).hide() if edgeView.model.isAssigned()
    else
      _.each @edgeViews, (edgeView) ->
        $(edgeView.el).show()

  # Assign all visible edges which are visible to the selected boundary condition
  assignAllVisibleEdges: ->
    _.each @edgeViews, (edgeView) ->
      if $(edgeView.el).is(':visible')
        edgeView.model.set "boundary_condition_id" : SCVisu.boundaryConditionListView.selectedBoundaryConditionView.model.getId()
        edgeView.showUnassignButton()

  # Assign all visible edges which are visible to the selected boundary condition
  unassignAllVisibleEdges: ->
    _.each @edgeViews, (edgeView) ->
      if $(edgeView.el).is(':visible')
        edgeView.model.unset "boundary_condition_id"
        edgeView.showAssignButton()

  # Update the calcul JSON
  saveCalcul: ->
    SCVisu.current_calcul.set edges: @collection.models
    SCVisu.current_calcul.set boundary_conditions: SCVisu.boundaryConditionListView.collection.models
    SCVisu.current_calcul.trigger 'change'

  render: ->
    for edgeView in @edgeViews
      edgeView.render()
      edgeView.deselect()
    return this
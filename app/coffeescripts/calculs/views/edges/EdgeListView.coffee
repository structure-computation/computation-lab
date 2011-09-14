## EdgeListView
SCViews.EdgeListView = Backbone.View.extend
  el: '#edges'

  initialize: (options) ->
    @clearView()
    @edgeViews = []
    @editEdgeView = new SCViews.EditEdgeView()
    @editEdgeView.hide()
    for edge in @collection.models
      @edgeViews.push new SCViews.EdgeView model: edge, parentElement: @
    @selectedEdgeView = null
    for edge in @collection.models
      if !_.isUndefined(edge.getId())
        return @selectedEdgeView = edge
    @render()
    $(@el).find('table').tablesorter()
    @collection.bind 'add'   , @render, this
    @collection.bind 'change', @render, this

  # Called from edit view when user wants to create a new edge.
  # Create a view associated to the given model
  events: 
    "click button.new_edge"  : "showNewEdgeForm"

  addEdgeModel: (edgeModel) ->
    @editEdgeView.hide()
    @edgeViews.push new SCViews.EdgeView model: edgeModel, parentElement: @
    @collection.add edgeModel
    
  # setNewSelectedModel is executed when a child view indicate it has been selected.
  # It set the current selected model to "non selected" (which trigger an event that redraw its line).
  setNewSelectedModel: (edgeView) ->
    if @selectedEdgeView == edgeView
      @selectedEdgeView = null
      @unhighlightEdges()
      SCVisu.boundaryConditionListView.edgeHasBeenDeselected()
    else
      $('#boundary_condition_form').hide()
      @selectedEdgeView = edgeView
      @editEdgeView.setModel edgeView.model
      if _.isUndefined edgeView.model.get('boundary_condition_id')
        SCVisu.boundaryConditionListView.showAssignButtons()
      else
        SCVisu.boundaryConditionListView.highlightCondition(edgeView.model.get('boundary_condition_id'))
      @render()

  unhighlightEdges: ->
    _.each @edgeViews, (edgeView) ->
      $(edgeView.el).removeClass('gray').removeClass('selected')

  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#materials' element already exists in the DOM and every time we create a MaterialListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new MaterialListView 
  clearView: ->
    $(@el).find('table tbody').html('')  
  
  # Update the calcul JSON
  updateCalcul: ->
    SCVisu.current_calcul.set edges: @collection.models
    SCVisu.current_calcul.trigger 'change'

  # Assign the selected condition to the selected edge
  asssignCondition: (toThisEdge)->
    toThisEdge.model.set 'boundary_condition_id': SCVisu.boundaryConditionListView.selectedBoundaryCondition.model.getId(), {silent: true}
    @updateCalcul()

  # Assign the condition from the selected edge
  unasssignCondition: (toThisEdge)->
    toThisEdge.model.unset 'boundary_condition_id', {silent: true}
    @updateCalcul()
    
  # Update all edges regarding the condition which has been removed by unseting all boundary_condition_id
  conditionHasBeenRemoved: (boundaryConditionRemoved)->
    @collection.each (edge) ->
      edge.unset('boundary_condition_id') if edge.get('boundary_condition_id') == boundaryConditionRemoved.getId()
    @updateCalcul()
    @render()
  
  # Highlight all edges that has the same ID as the selected boundary condition
  boundaryConditionHasBeenSelected: (selectedBoundaryConditionModel)->
    $(@el).find("button.assign_all, button.unassign_all").removeAttr('disabled')
    _.each @edgeViews, (edgeView) ->
      if _.isUndefined(edgeView.model.get('boundary_condition_id'))
        edgeView.showAssignButton()
      else if edgeView.model.get('boundary_condition_id') == selectedBoundaryConditionModel.getId()
        edgeView.showUnassignButton()
      else 
        edgeView.render()

  boundaryConditionHasBeenDeselected: (selectedBoundaryConditionModel)->
    $(@el).find("button.assign_all, button.unassign_all").attr('disabled','disabled')
    @render()

  # Shows the new edge form
  showNewEdgeForm: ->
    $('#boundary_condition_form').hide()
    @editEdgeView.showAndInitialize()

  events:
    'change input#hide_assigned_edges' : 'toggleAssignedEdges'
    'click button.assign_all'          : 'assignAllVisibleEdges'
    'click button.unassign_all'        : 'unassignAllVisibleEdges'
  
  
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
        edgeView.model.set "boundary_condition_id" : SCVisu.boundaryConditionListView.selectedBoundaryCondition.model.getId(), {silent: true}
        edgeView.showUnassignButton()

  # Assign all visible edges which are visible to the selected boundary condition
  unassignAllVisibleEdges: ->
    _.each @edgeViews, (edgeView) ->
      if $(edgeView.el).is(':visible')
        edgeView.model.unset "boundary_condition_id", {silent: true}
        edgeView.showAssignButton()
    
  render: ->
    for edgeView in @edgeViews
      edgeView.render()
    $(@selectedEdgeView.el).addClass("selected") if @selectedEdgeView
    return this
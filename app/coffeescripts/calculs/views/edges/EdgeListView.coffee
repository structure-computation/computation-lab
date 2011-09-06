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
      if !_.isUndefined(edge.get('id_in_calcul'))
        return @selectedEdgeView = edge
    @render()
    $(@el).find('table').tablesorter()
    @collection.bind 'add', @render, this
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
    @selectedEdgeView.model.unset "selected" if @selectedEdgeView
    @selectedEdgeView = edgeView
    @editEdgeView.setModel edgeView.model

  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#materials' element already exists in the DOM and every time we create a MaterialListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new MaterialListView 
  clearView: ->
    $(@el).find('table tbody').html('')  

  boundaryConditionHasBeenSelected: ->
    _.each @edgeViews, (edgeView) ->
      if _.isUndefined(edgeView.model.get('boundary_condition_id'))
        edgeView.showAssignButton()
      
  showNewEdgeForm: ->
    $('#boundary_condition_form').hide()
    @editEdgeView.show()
    @editEdgeView.showAndInitialize()
    
  render: ->
    for edgeView in @edgeViews
      edgeView.render()
    return this
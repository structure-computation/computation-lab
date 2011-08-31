## EdgeListView
SCViews.EdgeListView = Backbone.View.extend
  el: '#edges'

  initialize: (options) ->
    @edgeViews = []
    @editEdgeView = new SCViews.EditEdgeView()
    @editEdgeView.hide()
    for edge in @collection.models
      @edgeViews.push new SCViews.EdgeView model: edge, parentElement: @
    @render()
    @selectedEdgeView = null
    @collection.bind 'add', @render, this

  # Called from edit view when user wants to create a new edge.
  # Create a view associated to the given model
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

  events: 
    "click button.new_edge"  : "showNewEdgeForm"

  showNewEdgeForm: ->
    $('#boundary_condition_form').hide()
    @editEdgeView.show()
    @editEdgeView.showAndInitialize()
    

  render: ->
    for edgeView in @edgeViews
      edgeView.render()
    return @
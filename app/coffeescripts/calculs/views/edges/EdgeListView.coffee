## EdgeListView
SCModels.EdgeListView = Backbone.View.extend
  el: '#edges'

  initialize: (options) ->
    @edgeViews = []
    @newEdgeViewForm = new SCVisu.NewEdgeView()
    @newEdgeViewForm.hide()

  addEdgeModel: (edgeModel) ->
    @newEdgeViewForm.hide()
    @edgeViews.push new SCModels.EdgeView model: edgeModel, parentElement: @
    @render()
  events: 
    "click button.new_edge"  : "showNewEdgeForm"

  showNewEdgeForm: ->
    @newEdgeViewForm.showAndInitialize()
    

  render: ->
    for edgeView in @edgeViews
      edgeView.render()
    return @
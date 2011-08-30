## EdgeListView
SCViews.EdgeListView = Backbone.View.extend
  el: '#edges'

  initialize: (options) ->
    @edgeViews = []
    @newEdgeViewForm = new SCViews.NewEdgeView()
    @newEdgeViewForm.hide()

  addEdgeModel: (edgeModel) ->
    @newEdgeViewForm.hide()
    @edgeViews.push new SCViews.EdgeView model: edgeModel, parentElement: @
    @render()
  events: 
    "click button.new_edge"  : "showNewEdgeForm"

  showNewEdgeForm: ->
    @newEdgeViewForm.showAndInitialize()
    

  render: ->
    for edgeView in @edgeViews
      edgeView.render()
    return @
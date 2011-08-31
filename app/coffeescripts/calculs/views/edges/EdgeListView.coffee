## EdgeListView
SCViews.EdgeListView = Backbone.View.extend
  el: '#edges'

  initialize: (options) ->
    @clearView()
    @edgeViews = []
    @newEdgeViewForm = new SCViews.NewEdgeView()
    @newEdgeViewForm.hide()
    for edge in @collection.models
      @addEdgeModel edge
    @render()

  events: 
    "click button.new_edge"  : "showNewEdgeForm"

  addEdgeModel: (edgeModel) ->
    @newEdgeViewForm.hide()
    @edgeViews.push new SCViews.EdgeView model: edgeModel, parentElement: @
    @render()
    
  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#materials' element already exists in the DOM and every time we create a MaterialListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new MaterialListView 
  clearView: ->
    $(@el).find('ul.data_list').html('')  

  showNewEdgeForm: ->
    $('#boundary_condition_form').hide()
    @newEdgeViewForm.show()
    @newEdgeViewForm.showAndInitialize()
    

  render: ->
    for edgeView in @edgeViews
      edgeView.render()
    return @
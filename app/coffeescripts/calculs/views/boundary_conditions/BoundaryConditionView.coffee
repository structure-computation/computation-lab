## BoundaryConditionView
SCViews.BoundaryConditionView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement

  tagName   : "li"
  className : "boundary_condition_view"

  events: 
    "click"   : "select"
  
  select: ->
    @parentElement.setNewSelectedModel(this)
    @model.set selected: true

  render: ->
    $(@el).html(@model.get('name'))
    $(@parentElement.el).append(@el)
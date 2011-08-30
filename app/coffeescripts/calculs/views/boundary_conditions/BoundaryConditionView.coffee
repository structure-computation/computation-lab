## BoundaryConditionView
SCModels.BoundaryConditionView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
    
  tagName   : "li"
  className : "boundary_condition_view"
  
  render: ->
    $(@el).html(@model.get('name'))
    $(@parentElement.el).append(@el)
## BoundaryConditionView
SCViews.BoundaryConditionView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@parentElement.el).append(@el)
    
  tagName   : "li"
  className : "boundary_condition_view"

  events: 
    "click"   : "select"
  
  select: ->
    @parentElement.setNewSelectedModel(this)
    @model.set selected: true

  render: ->
    if @model.get 'selected' then $(@el).addClass 'selected' else $(@el).removeClass 'selected'
    $(@el).html(@model.get('id_in_calcul') + " - " + @model.get('name'))

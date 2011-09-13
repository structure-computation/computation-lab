## BoundaryConditionView
SCViews.BoundaryConditionView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@parentElement.el).append(@el)
    
  tagName   : "li"
  className : "boundary_condition_view"

  events: 
    "click"         : "select"
    "click .remove" : "removeCondition"
  
  removeCondition: ->
    # SCVisu.edgeListView.conditionHasBeenRemoved(@model)
    @parentElement.collection.remove @model
    SCVisu.current_calcul.trigger 'change'
    @remove()

  
  select: ->
    @parentElement.setNewSelectedModel(this)

  render: ->
    $(@el).html(@model.get('id_in_calcul') + " - " + @model.get('name') + "<button class='remove''>X</button>").removeClass('selected')
    this
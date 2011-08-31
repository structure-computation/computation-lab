SCViews.CalculView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
  
  tagName   : "li"
  className : "calcul_view" 
  
  events:
    "click" : 'selectCalcul'
  
  # Calls the parent's method to select a calcul 
  selectCalcul: ->
    @parentElement.selectCalcul this
    
  render: ->
    $(@el).html(@model.get('name'))
    $(@parentElement.el).append(@el)
    return this



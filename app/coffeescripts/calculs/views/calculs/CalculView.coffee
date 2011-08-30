SCViews.CalculView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
  
  tagName   : "li"
  className : "calcul_view" 
  
  events:
    "click" : 'select_calcul'
  
  # Appelle la fonction de selection de l'element parent, donc de la vue correspondant à la liste 
  select_calcul: ->
    @parentElement.select_calcul this
    
  render: ->
    $(@el).html(@model.get('name'))
    $(@parentElement.el).append(@el)
    return this



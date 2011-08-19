window.CalculView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
  
  tagName   : "li"
  className : "calcul_view"   

  render: ->
    $(@el).html(@model.get('name'))
    $("ul#calculs").append(@el)
    return this



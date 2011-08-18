# Material View
window.MaterialView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
  
  tagName   : "li"
  className : "material_view" 
  
  
  events:
    "click" : "show_details"
  
  show_details: ->
    @trigger 'update_details_model', @model
  
  render: ->
    $(@el).html(@model.get('name'))
    $("ul#materials").append(@el)
    return this



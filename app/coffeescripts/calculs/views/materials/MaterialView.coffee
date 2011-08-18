# Material View
window.MaterialView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
  
  tagName   : "li"
  className : "material_view"   
  
  events:
    "click" : "show_details"
    "click button.clone" : "show_details"
  
  show_details: ->
    @trigger 'update_details_model', @model
  
  render: ->
    $(@el).html(@model.get('name'))
    $(@el).append("<button class='clone'>Clone</button>")
    $("ul#materials").append(@el)
    return this



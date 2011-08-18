# Material View
window.MaterialView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
  
  tagName   : "li"
  className : "material_view"   
  
  events:
    "click button.edit"  : "show_details"
    "click button.clone" : "clone"
  
  show_details: ->
    @trigger 'update_details_model', @model

  clone: ->
    @parentElement.clone @model
    
  render: ->
    $(@el).html(@model.get('name'))
    $(@el).append("<button class='edit'>Editer</button>")
    $("ul#materials").append(@el)
    return this



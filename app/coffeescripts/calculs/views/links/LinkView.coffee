## Link View
window.LinkView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement

  tagName   : "li"
  className : "link_view"
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
    $("ul#links").append(@el)
    return this
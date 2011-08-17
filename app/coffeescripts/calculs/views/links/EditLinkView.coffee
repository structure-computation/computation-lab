## Edit Link View
window.EditLinkView = Backbone.View.extend
  el: "#edit_link"
  initialize: (params) ->
    @parentElement = params.parentElement
    
  events: 
    'keyup': 'updateModelAttributes'

  updateModel: (model) ->
    @model = model
    @render()
    
  updateModelAttributes: ->
    for input in $(@el).find('input, textarea')
      key = $(input).attr('id').split('link_')[1]
      value = $(input).val()
      h = new Object()
      h[key] = value
      @model.set h
    @parentElement.render()
    
  render: ->
    for input in $(@el).find('input, textarea')
      $(input).val(@model.get($(input).attr('id').split("link_")[1]))

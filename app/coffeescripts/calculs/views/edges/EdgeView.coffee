## EdgeView
SCViews.EdgeView = Backbone.View.extend
  tagName   : 'li'
  className : 'edge_view'

  initialize: (options) ->
    @parentElement = options.parentElement
    $(@parentElement.el).find('ul').append @el
  events:
    "click" : "select"

  select: ->
    @parentElement.setNewSelectedModel(this)
    @model.set selected: true

  showAssignButton: ->
  

  render: ->
    $(@el).html(@model.get('id') + " - " + @model.get 'name')
    return this
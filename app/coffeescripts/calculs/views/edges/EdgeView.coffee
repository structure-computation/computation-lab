## EdgeView
SCViews.EdgeView = Backbone.View.extend
  tagName   : 'li'
  className : 'edge_view'

  initialize: (options) ->
    @first = true
    @parentElement = options.parentElement

  events:
    "click" : "select"

  select: ->
    @parentElement.setNewSelectedModel(this)
    @model.set selected: true
    
  render: ->
    $(@el).html @model.get 'name'
    if @first
      $(@parentElement.el).find('ul').append @el
      @first = false
    return @
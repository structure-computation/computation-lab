## EdgeView
SCViews.EdgeView = Backbone.View.extend
  tagName   : 'li'
  className : 'edge_view'

  initialize: (options) ->
    @first = true
    @parentElement = options.parentElement

  render: ->
    $(@el).html @model.get 'name'
    if @first
      $(@parentElement.el).find('ul').append @el
      @first = false
    return @
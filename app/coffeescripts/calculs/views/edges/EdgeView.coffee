## EdgeView
SCViews.EdgeView = Backbone.View.extend
  tagName   : 'li'
  className : 'edge_view'

  initialize: (options) ->
    console.log @model
    @first = true
    @parentElement = options.parentElement

  render: ->
    $(@el).html @model.get 'name'
    console.log @el
    if @first
      $(@parentElement.el).find('ul').append @el
      @first = false
    return @
## EdgeView
SCViews.EdgeView = Backbone.View.extend
  tagName   : 'tr'
  className : 'edge_view'

  initialize: (options) ->
    @parentElement = options.parentElement
    $(@parentElement.el).find('table tbody').append @el

  events:
    "click" : "select"

  select: ->
    @parentElement.setNewSelectedModel(this)
    @model.set selected: true

  showAssignButton: ->
  

  render: ->
    template = """
      <td>#{@model.get('id')}</td>
      <td>#{@model.get('name')}</td>
      <td></td>
    """
    $(@el).html(template)
    return this
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

  showAssignButton: ->
  

  render: ->
    template = """
      <td>#{@model.get('id')}</td>
      <td>#{@model.get('name')}</td>
      <td></td>
    """
    $(@el).html(template).removeClass('selected')
    return this
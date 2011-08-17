## Link View
window.LinkView = Backbone.View.extend
  tagName   : "tr"
  initialize: (params) ->
    @parentElement = params.parentElement
  events: 
    'click .add' : 'addLink'

  addLink: ->
    @parentElement.trigger 'linkAdded', @model
    
  render: ->
    template = """
        <td>#{@model.get('name')}</td>
        <td><button class='add'>Ajouter</button></td>
            """
    $(@el).html(template)
    $("#links_table tbody").append(@el)
    return this



## Selected Link View
SCVisu.SelectedLinkView = Backbone.View.extend
  tagName   : "tr"
  initialize: (params) ->
    @parentElement = params.parentElement

  events: 
    'click .delete' : 'deleteLink'
    'click .edit' : 'editLink'

  deleteLink: ->
    @parentElement.trigger 'linkRemoved', @model
  editLink: ->
    @parentElement.trigger 'editLink', @model
  render: ->
    template = """
        <td>#{@model.get('name')}</td>
        <td><button class='edit'>Editer</button></td>
        <td><button class='delete'>Supprimer</button></td>
            """
    $(@el).html(template)
    $("#selected_links_table tbody").append(@el)
    return this

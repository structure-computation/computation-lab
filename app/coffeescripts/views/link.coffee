## LinkListView
window.LinkListView = Backbone.View.extend
  el: 'links_table'
  
  initialize: (options) ->
    @linkViews          = []
    @localLinks = new LocalLinkListView
    @bind "link_added", @add_selected_link, this
    
    for link in @collection
      @linkViews.push new LinkView model: link, parentElement: this
    @render()
    
  add_selected_link: (selectedLink) ->
    @localLinks.add_link(selectedLink)
    
  render : ->

    for linkView in @linkViews
      linkView.render()
    return this


## Link View
window.LinkView = Backbone.View.extend
  tagName   : "tr"
  initialize: (params) ->
    @parentElement = params.parentElement
  events: 
    'click .add' : 'add_link'

  add_link: ->
    @parentElement.trigger 'link_added', @model
    
  render: ->
    template = """
        <td>#{@model.get('name')}</td>
        <td><button class='add'>Ajouter</button></td>
            """
    $(@el).html(template)
    $("#links_table tbody").append(@el)
    return this


## LocalLinkListView
window.LocalLinkListView = Backbone.View.extend
  id: 'selected_links_table'

  initialize: (options) ->
    @selectedLinkViews = []
    @bind "link_removed", @remove_link, @

  remove_link: (link_to_remove) ->
    for linkView, i in @selectedLinkViews
      if linkView.model == link_to_remove
        @selectedLinkViews.splice(i, 1)
        linkView.remove()
        @render()
        break
    
  add_link: (selectedLink) ->
    @selectedLinkViews.push new SelectedLinkView model: selectedLink, parentElement: this
    console.log @selectedLinkViews
    @render()

  render : ->
    for linkView in @selectedLinkViews
      linkView.render()
    return this

## Selected Link View
window.SelectedLinkView = Backbone.View.extend
  tagName   : "tr"
  initialize: (params) ->
    @parentElement = params.parentElement

  events: 
    'click .delete' : 'delete_link'

  delete_link: ->
    @parentElement.trigger 'link_removed', @model
    
  render: ->
    template = """
        <td>#{@model.get('name')}</td>
        <td><button class='delete'>Supprimer</button></td>
            """
    $(@el).html(template)
    $("#selected_links_table tbody").append(@el)
    return this


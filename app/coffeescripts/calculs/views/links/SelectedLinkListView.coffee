## LocalLinkListView
SCVisu.LocalLinkListView = Backbone.View.extend
  el: '#selected_links_table'

  initialize: (options) ->
    @selectedLinkViews = []
    @bind "linkRemoved", @removeLink, @
    @bind "editLink", @editLink, @
    @editLinkView = new EditLinkView parentElement: this
    
  removeLink: (linkToRemove) ->
    for linkView, i in @selectedLinkViews
      if linkView.model == linkToRemove
        @selectedLinkViews.splice(i, 1)
        linkView.remove()
        @render()
        break
  editLink: (link) ->
    @editLinkView.updateModel link

  addLink: (selectedLink) ->
    newLink = selectedLink.clone()

    for linkView in @selectedLinkViews
      if linkView.model.get('name') == newLink.get('name')
        newLink.set name : newLink.get('name') + " - copy"
        break
    @selectedLinkViews.push new SelectedLinkView model: newLink, parentElement: this
    @render()

  render : ->
    for linkView in @selectedLinkViews
      linkView.render()
    return this


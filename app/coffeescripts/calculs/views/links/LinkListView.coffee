## LinkListView
window.LinkListView = Backbone.View.extend
  el: '#links_table'
  
  initialize: (options) ->
    @linkViews          = []
    @localLinks = new LocalLinkListView
    @bind "linkAdded", @addSelectedLink, this
    
    for link in @collection
      @linkViews.push new LinkView model: link, parentElement: this
    @render()
    
  addSelectedLink: (selectedLink) ->
    @localLinks.addLink(selectedLink)
    
  render : ->

    for linkView in @linkViews
      linkView.render()
    return this

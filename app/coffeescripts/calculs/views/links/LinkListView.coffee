## LinkListView
window.LinkListView = Backbone.View.extend
  el: 'ul#links'
  
  initialize: (options) ->
    @editView = new EditLinkView parentElement: this
    @linkViews = []
    for link in @collection.models
      @createLinkView(link)
    @render() 

  createLinkView: (link) ->
    l = new LinkView model: link, parentElement: this
    l.bind 'update_details_model', @update_details, this
    @linkViews.push l
    
  update_details: (model) ->
    @editView.updateModel model   

  render : ->
    for l in @linkViews
      l.render()
    return this

 
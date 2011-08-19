window.CalculListView = Backbone.View.extend
  el: 'ul#calculs'

  initialize: (options) ->
    @calculViews = []
    for calcul in @collection.models
      @createCalculView(calcul)
    @render()

  createCalculView: (calcul) ->
    c = new CalculView model: calcul, parentElement: this
    @calculViews.push c

  render : ->
    for c in @calculViews
      c.render()
    return this

 
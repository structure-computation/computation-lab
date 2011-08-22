window.CalculListView = Backbone.View.extend
  el: 'ul#calculs'

  initialize: (options) ->
    @calculViews = []
    for calcul in @collection.models
      @createCalculView(calcul)
    @render()
    
  events:
    "click #load_calcul": "load_calcul"
    
  load_calcul: ->
    window.current_calcul = new Calcul @selected_calcul
  
  select_calcul:(calcul) ->
    for calculView in @calculViews
      $(calculView.el).removeClass('selected')
    $(calcul.el).addClass 'selected'
    @selected_calcul = new Calcul calcul.model

  createCalculView: (calcul) ->
    c = new CalculView model: calcul, parentElement: this
    @calculViews.push c

  render : ->
    for c in @calculViews
      c.render()
    $('#initialisation_button').append("<button id=\"load_calcul\" class='yellow_button'>Charger le calcul</button>")
    return this

 
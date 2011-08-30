SCViews.CalculListView = Backbone.View.extend
  el: 'ul#calculs'

  initialize: (options) ->
    @calculViews = []
    for calcul in @collection.models
      @createCalculView(calcul)
    @render()
    
  events:
    "click .load_calcul": "loadCalcul"
    "click .save_calcul": "saveCalcul"
    
  # Fonction appellé lorsque l'on clique sur le bouton 'Charger le calcul'. Elle créee alors  le current_calcul qui sera utilisé tout au long du calcul
  loadCalcul: ->
    SCVisu.current_calcul = new SCModels.Calcul @selected_calcul
    SCVisu.router.calculIsLoading()
    Backbone.sync("read", SCVisu.current_calcul,
      success: (response) ->
        SCVisu.current_calcul.setElements response
        #SCVisu.current_calcul.set brouillon: response.brouillon
        SCVisu.initializeFromJSON()
        SCVisu.router.calculHasBeenLoad()
      error: ->
        SCVisu.router.calculLoadError()
    )
    
  
  saveCalcul: ->
    Backbone.sync "update", SCVisu.current_calcul
  
  select_calcul:(calcul) ->
    for calculView in @calculViews
      $(calculView.el).removeClass('selected')
    $(calcul.el).addClass 'selected'
    @selected_calcul = new SCModels.Calcul calcul.model

  createCalculView: (calcul) ->
    c = new SCViews.CalculView model: calcul, parentElement: this
    @calculViews.push c

  render : ->
    for c in @calculViews
      c.render()
    $(@el).append("<button class=\"load_calcul\">Charger le brouillon</button>")
    $(@el).append("<button class=\"save_calcul\">Save le brouillon</button>")
    return this

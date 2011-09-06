SCViews.CalculListView = Backbone.View.extend
  el: 'table#calculs'

  initialize: (options) ->
    @calculViews = []
    for calcul in @collection.models
      @createCalculView(calcul)
    @render()
    $(@el).tablesorter()
    
  events:
    "click .load_calcul": "loadCalcul"
    "click .save_calcul": "saveCalcul"
    
  # Get a JSON from the server containing calcul information and create current_calcul which will be used all along the calcul's setup.
  loadCalcul: ->
    SCVisu.current_calcul = new SCModels.Calcul @selected_calcul
    SCVisu.router.calculIsLoading()
    Backbone.sync("read", SCVisu.current_calcul,
      success: (response) ->
        SCVisu.current_calcul.setElements response
        SCVisu.initializeFromJSON()
        SCVisu.router.calculHasBeenLoad()
        
      error: ->
        SCVisu.router.calculLoadError()
    )
        
  # Saves the current_calcul to the server side
  saveCalcul: ->
    Backbone.sync "update", SCVisu.current_calcul
  
  selectCalcul:(calcul) ->
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
    tableFooter = """
        <tr>
          <td colspan='4'>
            <button class=\"load_calcul\">Charger le brouillon</button>
            <button class=\"save_calcul\">Sauvegarder le brouillon</button>
            <button class=\"new_calcul\">Nouveau brouillon</button>
          </td>
        </tr>
    """
    $(@el).find('tfoot').append(tableFooter)
    return this

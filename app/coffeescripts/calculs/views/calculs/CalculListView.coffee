SCViews.CalculListView = Backbone.View.extend
  el: 'table#calculs'

  initialize: (options) ->
    @calculViews = []
    for calcul in @collection.models
      @createCalculView(calcul)
    @calculInformationView = new SCViews.CalculInformation()
    @render()
    $(@el).tablesorter()
    $(window).unload @beforeClosePage
    
  events:
    "click #new_calcul"  : "newCalcul"
    
  # Get a JSON from the server containing calcul information and create current_calcul which will be used all along the calcul's setup.
  loadCalcul: ->
    SCVisu.current_calcul = new SCModels.Calcul @selected_calcul
    SCVisu.router.calculIsLoading()
    Backbone.sync("read", SCVisu.current_calcul,
      success: (response) =>
        SCVisu.current_calcul.setElements response
        SCVisu.initializeFromJSON()
        SCVisu.router.calculHasBeenLoad()
        $('#saved_for').html "Dernière sauvegarde : " + SCVisu.current_calcul.get('last_saved') if !_.isUndefined(SCVisu.current_calcul.get 'last_saved')
        @disableSaveButton()
      error: ->
        SCVisu.router.calculLoadError()
    )

  # Saves the current_calcul to the server side
  saveCalcul: ->
    previousSaveDate = SCVisu.current_calcul.get 'last_saved'
    date = new Date()
    dateString = date.getDate() + "/" + date.getMonth() + "/" + date.getFullYear() + " " + date.toTimeString()
    SCVisu.current_calcul.set last_saved: dateString
    SCVisu.NOTIFICATIONS.setTextWithoutTimer('Sauvegarde en cours...')
    Backbone.sync "update", SCVisu.current_calcul, 
      success: (response) ->
        SCVisu.NOTIFICATIONS.close()
      error: ->
        SCVisu.NOTIFICATIONS.setText('La sauvegarde a échouée')
    $('#saved_for').html('')
    $('#saved_for').append "Dernière sauvegarde : " + dateString
    @disableSaveButton()
    
  disableSaveButton: ->
    $('#save_calcul').attr("disabled", "disabled")

  beforeClosePage: (event) ->
    SCVisu.NOTIFICATIONS.setTextWithoutTimer('Sauvegarde en cours...')
    date = new Date()
    dateString = date.getDate() + "/" + date.getMonth() + "/" + date.getFullYear() + " " + date.toTimeString()
    SCVisu.current_calcul.set last_saved: dateString
    Backbone.sync "update", SCVisu.current_calcul, async: false
    
  newCalcul: ->
    $('#new_calcul').attr("disabled", "disabled")
    SCVisu.current_calcul = new SCModels.Calcul
    SCVisu.router.calculIsCreating()
    that = this
    Backbone.sync("create", SCVisu.current_calcul,
      success: (response) ->
        SCVisu.current_calcul.set 'name' : response.name, 'id' : response.id, 'state' : response.state, 'description' : 'null'
        SCVisu.current_calcul.resetUrl()
        calculView = SCVisu.calculListView.createCalculView SCVisu.current_calcul
        SCVisu.calculListView.renderChildViews()
        SCVisu.router.calculHasBeenCreated()
        $('#new_calcul').removeAttr("disabled")
        that.disableSaveButton()
        
      error: (response) ->
        SCVisu.router.calculLoadError()
        console.log "erreur lors de la sauvegarde"
        $('#new_calcul').removeAttr("disabled")
        that.disableSaveButton()
    )

  
  selectCalcul:(calcul) ->
    for calculView in @calculViews
      $(calculView.el).removeClass('selected')
    $(calcul.el).addClass 'selected'
    @selected_calcul = new SCModels.Calcul calcul.model

  createCalculView: (calcul) ->
    c = new SCViews.CalculView model: calcul, parentElement: this
    @calculViews.push c
    return c
    
  render : ->
    @renderChildViews()
    tableFooter = """
        <tr>
          <td colspan='4'>
            <button id=\"new_calcul\">Nouveau brouillon</button>
          </td>
        </tr>
    """
    $(@el).find('tfoot').append(tableFooter)
    return this
    
  renderChildViews : ->
    for c in @calculViews
      c.render()

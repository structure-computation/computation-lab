## Edit Link View
SCViews.EditLinkView = Backbone.View.extend
  el: "#edit_link"
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@el).hide()

  events: 
    'change'                         : 'updateModelAttributes'
    'click button.close'             : 'hide'
    'change select.ep_type'          : 'selectEpType'
  

  # Select the first tab
  selectFirstTab: ->
    $(@el).find(".horizontal_tab_submenu a")      .removeClass('selected')
    $(@el).find(".horizontal_tab_submenu a:first").addClass('selected')
    $(@el).find(".horizontal_tab_content div")      .hide()
    $(@el).find(".horizontal_tab_content div:first").show()

  # Update edit view 
  selectEpType: ->
    @model.set  "Ep_Type" : $(event.srcElement).val()
    @setEpType()
   
  setEpType: ->
    $(@el).find("#epaisseur_normale").hide()
    $(@el).find("#epaisseur_direction").hide()
    $(@el).find("#preload_normale").hide()
    $(@el).find("#preload_direction").hide()
    
    if @model.get("Ep_Type") == "0"
      #alert  @model.get("Ep_Type")
      $(@el).find("#epaisseur_normale").show()
    else if @model.get("Ep_Type") == "1"
      $(@el).find("#epaisseur_direction").show()  
    else if @model.get("Ep_Type") == "2"
      $(@el).find("#preload_normale").show()
    else if @model.get("Ep_Type") == "3"
      $(@el).find("#preload_direction").show()  
    else
      @model.set "Ep_Type" : "0"
      $(@el).find("#epaisseur_normale").show()
      
    $(@el).find("select.ep_type").val(@model.get("Ep_Type"))
    
  # Update edit view with the given model
  updateModel: (model, readonly = false) ->
    @selectFirstTab()    
    @model = model
    if readonly then @disableAllInputs() else @enableAllInputs()
    
    $(@el).find("select.ep_type").show()
    $(@el).find("#raideur").hide()
    $(@el).find("#frottement").hide()
    $(@el).find("#Lrupture").hide()
    $(@el).find("#Lendo").hide()
    $(@el).find("#PalphaEndo").hide()
    $(@el).find("#PnEndo").hide()
          
    $(@el).find("#raideur").show()  if @model.get('type_num') == 1 or @model.get('type_num') == 4 or @model.get('type_num') == 5
    $(@el).find("#frottement").show()  if @model.get('type_num') == 2 or @model.get('type_num') == 3 or @model.get('type_num') == 4 or @model.get('type_num') == 5
    $(@el).find("#Lrupture").show()  if @model.get('type_num') == 3 or @model.get('type_num') == 4 or @model.get('type_num') == 5
    $(@el).find("#Lendo").show()  if @model.get('type_num') == 5
    $(@el).find("#PalphaEndo").show()  if @model.get('type_num') == 5
    $(@el).find("#PnEndo").show()  if @model.get('type_num') == 5
    
    @render()

  # Enable all inputs
  enableAllInputs: ->
    $(@el).find('input, textarea').removeAttr 'disabled'

  # Disable all inputs
  disableAllInputs: ->
    $(@el).find('input, textarea').attr 'disabled', 'disabled'

  # Hide itself
  hide: ->
    # Put back the visu
    $('#visu_calcul').show()
    $(@el).hide()
  
  # Update model from all input values
  updateModelAttributes: ->
    for input in $(@el).find('input, textarea')
      key    = $(input).attr('id').split('link_')[1]
      value  = $(input).val()
      h      = new Object()
      h[key] = value
      @model.set h
    SCVisu.current_calcul.set links: SCVisu.linkListView.collection.models  
    SCVisu.current_calcul.trigger 'change'
    
  # Reset all fields of the edit view
  resetFields: ->
    for input in $(@el).find('input, textarea')
      $(input).val("")

  
  render: (resetFields = false) ->
    $('#visu_calcul').hide()
    $(@el).show()
    for input in $(@el).find('input, textarea')
      $(input).val(@model.get($(input).attr('id').split("link_")[1]))
    @setEpType()

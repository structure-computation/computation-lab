SCViews.EditMaterialView = Backbone.View.extend
  el: "#edit_material"
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@el).find('h2:first').prepend('<button class="close">Fermer</button>')    
    @hide()

  events: 
    'change'              : 'updateModelAttributes'
    'click button.close'  : 'hide'

  # Hide itself
  hide: ->
    # Put back the visu
    $('#visu_calcul').show()
    $(@el).hide()
    
  # Update moddel with values which are in inputs
  updateModelAttributes: ->
    for input in $(@el).find('input, textarea')
      # Get the name of the attribute
      # HTML Is formatted as follow: <input id="material_family"...
      key = $(input).attr('id').split('material_')[1] 
      value = $(input).val()
      h = new Object()
      h[key] = value
      @model.set h
    SCVisu.current_calcul.set materials: SCVisu.materialListView.collection.models  
    SCVisu.current_calcul.trigger 'change'
    
  # Select the first tab
  selectFirstTab: ->
    $(@el).find(".horizontal_tab_submenu a")      .removeClass('selected')
    $(@el).find(".horizontal_tab_submenu a:first").addClass('selected')
    $(@el).find(".horizontal_tab_content div")      .hide()
    $(@el).find(".horizontal_tab_content div:first").show()

  # Update view with the given model
  updateModel: (model, readonly = false) ->
    @selectFirstTab()    
    @model = model
    if readonly then @disableAllInputs() else @enableAllInputs()
    @render()

  # Enable all inputs
  enableAllInputs: ->
    $(@el).find('input:not("input[type=radio], input[type=checkbox]"), textarea').removeAttr 'disabled'

  # Disable all inputs
  disableAllInputs: ->
    $(@el).find('input, textarea').attr 'disabled', 'disabled'

  getAndSetMaterialCompAndType: ->
    # First, uncheck all radio and checkboxes input and hide useless tabs
    $(@el).find("input[type=radio], input[type=checkbox]").removeAttr('checked')
    $(@el).find("> ul li a:not(':first')").hide()
    $(@el).find(".orthotropic_information").hide()

    if !_.isNull(@model.get('comp'))
      # Checking good checkboxes regarding material behavior
      if @model.get('comp').indexOf('el') != -1
        $('#material_comp_el').attr('checked', 'checked')
        $(@el).find("#tab_elastic").show()
      if @model.get('comp').indexOf('pl') != -1
        $('#material_comp_pl').attr('checked', 'checked')
        $(@el).find("#tab_plastic").show()
      if @model.get('comp').indexOf('en') != -1
        $('#material_comp_en').attr('checked', 'checked')
        $(@el).find("#tab_damage").show()

    if !_.isNull(@model.get('mtype'))
      # Checking good checkboxes regarding material behavior
      if @model.get('mtype').indexOf('isotrope') != -1
        $('#material_mtype_isotrope').attr('checked', 'checked')
      else if @model.get('mtype').indexOf('orthotrope') != -1
        $('#material_mtype_orthotrope').attr('checked', 'checked')
        $(@el).find(".orthotropic_information").show()
        
  # Reset all fields of the view
  resetFields: ->
    for input in $(@el).find('input, textarea')
      $(input).val("")
    
  
  render: (resetFields = false) ->
    # Hide the visu when show itself
    $('#visu_calcul').hide()
    $(@el).show()
    @parentElement.render()
    if resetFields
      @resetFields()
    else
      @getAndSetMaterialCompAndType()
      for input in $(@el).find('textarea, input:not("input[type=radio], input[type=checkbox]")')
        $(input).val(@model.get($(input).attr('id').split("material_")[1]))


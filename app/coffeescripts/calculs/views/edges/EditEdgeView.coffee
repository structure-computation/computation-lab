# The view is composed of three part:
#   First:  A select box (#edge_criteria) where the user will choose the criteria of the edge
#     From this choice another select box another one pops up : #volume_geometry or #surface_geometry
#     From this new choice the correct div will be displayed
SCViews.EditEdgeView = Backbone.View.extend
  el: "#new_edge_form"
  initialize: (params) ->
    $(@el).find('> div:not("#edge_criteria, #edge_information_box")').hide()
    # Hide save button
    $(@el).find('button.save').hide()
    @currentCriteria = null
    @currentGeometry = null
    @currentEdge     = null
  showAndInitialize: ->
    @hideEverythingExceptCriteriaPart()
    @currentEdge = null
    $(@el).show()
  hide: ->
    $(@el).hide()
    
  show: ->
    @emptyInputs()
    $(@el).find('button').removeAttr('disabled')
    $(@el).find('button').removeClass('pressed_button')
    $(@el).show()
  events: 
    "click  button.criteria"          : "showSelectGeometry"
    "click  button.geometry"          : "showCorrectGeometry"
    "click  button.save"              : "save"
    "change"                          : "updateSelectedModelAttributes"
      
  setModel: (edge) ->
    @currentEdge = edge
    @showCriteriaPartAndDisableButtons()
    $(@el).find('#edge_name')       .val(edge.get('name')) 
    $(@el).find('#edge_description').val(edge.get('description')) 
    
    if !_.isUndefined edge.get('surface')
      $(@el).find('button.criteria[value=surface]').addClass('pressed_button')
      if      !_.isUndefined edge.get('surface').plan
        @showGeometry 'surface', 'plan'
      else if !_.isUndefined edge.get('surface').disc
        @showGeometry 'surface', 'disc'
      else if !_.isUndefined edge.get('surface').cylinder
        @showGeometry 'surface', 'cylinder'
      else if !_.isUndefined edge.get('surface').sphere
        @showGeometry 'surface', 'sphere'
      else if !_.isUndefined edge.get('surface').parameterized_surface
        @showGeometry 'surface', 'parameterized'
    
    else if !_.isUndefined edge.get('volume')
      $(@el).find('button.criteria[value=volume]').addClass('pressed_button')
      if      !_.isUndefined edge.get('volume').box
        @showGeometry 'volume', 'box'
      else if !_.isUndefined edge.get('volume').cylinder
        @showGeometry 'volume', 'cylinder'
      else if !_.isUndefined edge.get('volume').sphere
        @showGeometry 'volume', 'sphere'
    
    
  # Show the good select box between volume and surface depending of the choice of the criteria
  showSelectGeometry: (event) ->
    @hideEverythingExceptCriteriaPart()
    $('button.criteria').removeClass('pressed_button')
    $(event.srcElement).addClass('pressed_button')
    switch event.srcElement.value
      when 'surface'
        $(@el).find('#volume_geometry').hide()
        $(@el).find('#surface_geometry').show()
      when 'volume'
        $(@el).find('#volume_geometry').show()
        $(@el).find('#surface_geometry').hide()


  # Show the good form regarding the choice of the geometry when creating new edge
  showCorrectGeometry: (event) ->
    @hideEverythingExceptCriteriaPart()
    @currentEdge = null
    $('button.geometry').removeClass('pressed_button')
    $(event.srcElement).addClass('pressed_button')

    switch event.srcElement.value
      when 'volume_box'            then @showGeometry 'volume', 'box'
      when 'volume_cylinder'       then @showGeometry 'volume', 'cylinder'
      when 'volume_sphere'         then @showGeometry 'volume', 'sphere'

      when 'surface_plan'          then @showGeometry 'surface', 'plan'
      when 'surface_disc'          then @showGeometry 'surface', 'disc'
      when 'surface_cylinder'      then @showGeometry 'surface', 'cylinder'
      when 'surface_sphere'        then @showGeometry 'surface', 'sphere'
      when 'surface_parameterized' then @showGeometry 'surface', 'parameterized'

  # Updates all inputs relative to the current Edge depending on the criteria and the geometry of the edge
  updateInputs: (criteria, geometry)->
    attributes = @currentEdge.get(criteria)[geometry]
    for key of attributes
      $(@el).find("##{criteria}_#{geometry}_#{key}").val(attributes[key])
    
  # Hide everything except the criteria select box
  # Let the good geometry select box shown
  # Show the good form regarding the criteria and the geometry choosed
  showGeometry: (criteria, geometry) ->
    @updateInputs(criteria, geometry) if @currentEdge
    
    $('button.geometry').removeClass('pressed_button')
    $("button.geometry[value=#{criteria}_#{geometry}]").addClass('pressed_button')

    $(@el).find('button.save').show()
    @currentCriteria = criteria
    @currentGeometry = geometry
    if criteria == "volume"
      $(@el).find('#volume_geometry').show()    
    else if criteria == "surface"
      $(@el).find('#surface_geometry').show()    
    $(@el).find("#edge_#{criteria}_#{geometry}").show()

  # Hide all divs except criteria div
  hideEverythingExceptCriteriaPart: ->
    $(@el).find('> div:not("#edge_criteria, #edge_information_box")').hide()
    $(@el).find('button.save').hide()

  # Show Criteria, Geometry and disable all buttons
  showCriteriaPartAndDisableButtons: ->
    @show()
    @hideEverythingExceptCriteriaPart()
    $(@el).find('#edge_criteria').show()
    $(@el).find('button').attr('disabled', 'disabled')
  
  emptyInputs: ->
    $(@el).find('input, textarea').val('')
    
  # Create a new edge
  save: ->
    if @attributesAreValid()
      SCVisu.edgeListView.addEdgeModel new SCModels.Edge(@retrieveModelAttributesFromInput())

  updateSelectedModelAttributes: ->
    @currentEdge.set @retrieveModelAttributesFromInput() if @currentEdge

  # Regarding the currentCriteria and the currentGeometry, retrieve and returns 
  # all good data from inputs
  retrieveModelAttributesFromInput: ->
    edgeAttributes = new Object()
    edgeAttributes['name']                              = $(@el).find("#edge_name").val()
    edgeAttributes['description']                       = $(@el).find("#edge_description").val()
    edgeAttributes[@currentCriteria]                    = new Object()
    edgeAttributes[@currentCriteria][@currentGeometry]  = new Object()

    _.each $(@el).find("#edge_#{@currentCriteria}_#{@currentGeometry} input, #edge_#{@currentCriteria}_#{@currentGeometry} textarea"), (input) =>
      edgeAttributes[@currentCriteria][@currentGeometry][$(input).attr('name')] = $(input).val() if !_.isEmpty $(input).val()
    return edgeAttributes

  # Check if inputs are correctly filled and with the good data type
  # HTML Inputs have an HTML5 data attribute : data-type which tells if it has to be number or text
  # The function will return false if an input is blank or mal filled. Inputs concerned will be put in red
  attributesAreValid: ->
    @resetInputColors()
    isValid = true
    for input in $(@el).find("#edge_#{@currentCriteria}_#{@currentGeometry} input, #edge_#{@currentCriteria}_#{@currentGeometry} textarea")
      if _.isEmpty $(input).val() 
        isValid = false
      # To improve
      if isValid and $(input).data('type') == 'number' and !_.isNumber(parseInt($(input).val(), 10))
        isValid = false
      if isValid and $(input).data('text') == 'number' and !_.isString $(input).val()
        isValid = false
      if !isValid
         $(input).css('background-color', 'pink')

    return  isValid

  resetInputColors: ->
    for input in $(@el).find("#edge_#{@currentCriteria}_#{@currentGeometry} input, #edge_#{@currentCriteria}_#{@currentGeometry} textarea")
       $(input).css('background-color', 'white')


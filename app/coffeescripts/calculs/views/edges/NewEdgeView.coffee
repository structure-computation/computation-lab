# The view is composed of three part:
#   First:  A select box (#edge_criteria) where the user will choose the criteria of the edge
#     From this choice another select box another one pops up : #volume_geometry or #surface_geometry
#     From this new choice the correct div will be displayed
SCViews.NewEdgeView = Backbone.View.extend
  el: "#new_edge_form"
  initialize: (params) ->
    $(@el).find('> div:not("#edge_criteria")').hide()
    # Hide save button
    $(@el).find('button.save').hide()
    @currentCriteria = null
    @currentGeometry = null
    
  showAndInitialize: ->
    @hideEveryoneExceptFirstSelectBox()
    $(@el).show()
  hide: ->
    $(@el).hide()
  show: ->
    $(@el).show()
  events: 
    "click  button.criteria"          : "showSelectGeometry"
    "click  button.geometry"          : "showGoodGeometry"
    "click  button.save"              : "save"
    
    
  # Show the good select box between volume and surface depending of the choice of the criteria
  showSelectGeometry: (event) ->
    @hideEveryoneExceptFirstSelectBox()
    $('button.criteria').removeClass('pressed_button')
    $(event.srcElement).addClass('pressed_button')
    switch event.srcElement.value
      when 'surface'
        $(@el).find('#volume_geometry').hide()
        $(@el).find('#surface_geometry').show()
      when 'volume'
        $(@el).find('#volume_geometry').show()
        $(@el).find('#surface_geometry').hide()


  # Show the good form regarding the choice of the geometry
  showGoodGeometry: (event) ->
    @hideEveryoneExceptFirstSelectBox()
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


  # Hide everything except the criteria select box
  # Let the good geometry select box shown
  # Show the good form regarding the criteria and the geometry choosed
  showGeometry: (criteria, geometry) ->
    $(@el).find('button.save').show()
    @currentCriteria = criteria
    @currentGeometry = geometry
    if criteria == "volume"
      $(@el).find('#volume_geometry').show()    
    else if criteria == "surface"
      $(@el).find('#surface_geometry').show()    
    $(@el).find("#edge_#{criteria}_#{geometry}").show()

  # Hide all divs except criteria select box
  hideEveryoneExceptFirstSelectBox: ->
    $(@el).find('> div:not("#edge_criteria")').hide()
    $(@el).find('button.save').hide()

  # Retrieve all attributes and create a new edge
  save: ->
    if @attributesAreValid()
      edgeAttributes = new Object()
      _.each $(@el).find("#edge_#{@currentCriteria}_#{@currentGeometry} input, #edge_#{@currentCriteria}_#{@currentGeometry} textarea"), (input) ->
        edgeAttributes[$(input).attr('name')] = $(input).val()
      edgeAttributes['criteria'] = @currentCriteria
      edgeAttributes['geometry'] = @currentGeometry

      SCVisu.edgeListView.addEdgeModel new SCModels.Edge(edgeAttributes)

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


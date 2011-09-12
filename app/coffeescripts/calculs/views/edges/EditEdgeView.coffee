# The view is composed of three part:
#   First:  A select box (#edge_criteria) where the user will choose the criteria of the edge
#     From this choice another select box another one pops up : #volume_geometry or #surface_geometry
#     From this new choice the correct div will be displayed
SCViews.EditEdgeView = Backbone.View.extend
  el: "#edit_edge_form"
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
    $(@el).find('input:radio').removeAttr('disabled')
    $(@el).show()
    @emptyInputs()
    
  hide: ->
    $(@el).hide()
    
  show: ->
    @emptyInputs()
    $(@el).show()
  events: 
    "click  input[name=edge_criteria]"          : "showSelectGeometry"
    "click  input[name=edge_surface_geometry], 
            input[name=edge_volume_geometry]"   : "showCorrectGeometry"
    "click  button.save"                        : "save"
    "change"                                    : "updateSelectedModelAttributes"
      
  setModel: (edge) ->
    @currentEdge = edge
    @showCriteriaPartAndDisableButtons()
    $(@el).find('#edge_name')       .val(edge.get('name')) 
    $(@el).find('#edge_description').val(edge.get('description'))     
    @currentCriteria = edge.get('criteria')
    @currentGeometry = edge.get('geometry')
    $(@el).find('input:radio').attr('disabled', 'disabled')
    $(@el).find('input:radio[name=edge_criteria]').filter("[value=#{@currentCriteria}]").attr('checked',true)
    switch @currentCriteria
      when "surface"  then $(@el).find('input:radio[name=edge_surface_geometry]').filter("[value=#{@currentGeometry}]").attr('checked',true)
      when "volume"   then $(@el).find('input:radio[name=edge_volume_geometry]') .filter("[value=#{@currentGeometry}]").attr('checked',true)

    @showGeometry()
    
  # Show the good select box between volume and surface depending of the choice of the criteria
  showSelectGeometry: (event) ->
    @hideEverythingExceptCriteriaPart()
    @currentCriteria = event.srcElement.value
    switch @currentCriteria
      when 'surface'
        $(@el).find('#volume_geometry').hide()
        $(@el).find('#surface_geometry').show()
      when 'volume'
        $(@el).find('#volume_geometry').show()
        $(@el).find('#surface_geometry').hide()


  # Show the good form regarding the choice of the geometry when creating new edge
  showCorrectGeometry: (event) ->
    @currentGeometry = event.srcElement.value
    @showGeometry()

  # Updates all inputs relative to the current Edge depending on the criteria and the geometry of the edge
  updateInputs: ->
    for key of @currentEdge.attributes
      if key != 'criteria' or key != 'geometry'
        $(@el).find("##{@currentCriteria}_#{@currentGeometry}_#{key}").val(@currentEdge.get(key))
    
  # Hide everything except the criteria select box
  # Let the good geometry select box shown
  # Show the good form regarding the criteria and the geometry choosed
  showGeometry: ->
    @hideEverythingExceptCriteriaAndGeometryPart()
    @updateInputs() if @currentEdge    
    $(@el).find('button.save').show() if @currentEdge == null

    $(@el).find("#{@currentCriteria}_geometry").show()    
    $(@el).find("#edge_#{@currentCriteria}_#{@currentGeometry}").show()

  # Hide all divs except criteria div
  hideEverythingExceptCriteriaPart: ->
    $(@el).find('> div:not("#edge_criteria, #edge_information_box")').hide()
    $(@el).find('button.save').hide()

  hideEverythingExceptCriteriaAndGeometryPart: ->
    @hideEverythingExceptCriteriaPart()
    $("##{@currentCriteria}_geometry").show()
    
  # Show Criteria, Geometry and disable all buttons
  showCriteriaPartAndDisableButtons: ->
    @show()
    @hideEverythingExceptCriteriaPart()
    $(@el).find('#edge_criteria').show()
    $(@el).find('button').hide()
  
  emptyInputs: ->
    $(@el).find('input:not([type=radio]), textarea').val('')
    $(@el).find('input[type=radio]').attr('checked', false)
    
  # Create a new edge
  save: ->
    SCVisu.edgeListView.addEdgeModel new SCModels.Edge(@retrieveModelAttributesFromInput())

  updateSelectedModelAttributes: ->
    @currentEdge.set @retrieveModelAttributesFromInput() if @currentEdge

  # Regarding the currentCriteria and the currentGeometry, retrieve and returns 
  # all good data from inputs
  retrieveModelAttributesFromInput: ->
    edgeAttributes = new Object()
    edgeAttributes['name']        = $(@el).find("#edge_name").val()
    edgeAttributes['description'] = $(@el).find("#edge_description").val()
    edgeAttributes['criteria']    = @currentCriteria
    edgeAttributes['geometry']    = @currentGeometry

    _.each $(@el).find("#edge_#{@currentCriteria}_#{@currentGeometry} input, #edge_#{@currentCriteria}_#{@currentGeometry} textarea"), (input) =>
      edgeAttributes[$(input).attr('name')] = $(input).val() if !_.isEmpty $(input).val()
    return edgeAttributes


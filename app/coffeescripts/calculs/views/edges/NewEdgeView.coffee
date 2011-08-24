# The view is composed of three part:
#   First:  A select box (#edge_criteria) where the user will choose the criteria of the edge
#     From this choice another select box another one pops up : #volume_geometry or #surface_geometry
#     From this new choice the correct div will be displayed
SCVisu.NewEdgeView = Backbone.View.extend
  el: "#new_edge"
  initialize: (params) ->
    $(@el).find('> div:not("#edge_criteria")').hide()

  events: 
    "change #edge_criteria select"   : "showSelectGeometry"
    "change #volume_geometry select" : "showVolumeGeometry"
    "change #surface_geometry select" : "showSurfaceGeometry"
    
  # Show the good select box between volume and surface depending of the choice of the criteria
  showSelectGeometry: (event) ->
    @hideEveryoneExceptFirstSelectBox()
    switch event.srcElement.value
      when 'surface'
        $(@el).find('#volume_geometry').hide()
        $(@el).find('#surface_geometry').show()
      when 'volume'
        $(@el).find('#volume_geometry').show()
        $(@el).find('#surface_geometry').hide()


  # Show the good form regarding the choice of the geometry
  showVolumeGeometry: (event) ->
    @hideEveryoneExceptFirstSelectBox()
    switch event.srcElement.value
      when 'box'      then @showGeometry 'volume', 'box'
      when 'cylinder' then @showGeometry 'volume', 'cylinder'
      when 'sphere'   then @showGeometry 'volume', 'sphere'
      else                 $(@el).find('#volume_geometry').show()

  # Show the good form regarding the choice of the geometry
  showSurfaceGeometry: (event) ->
    @hideEveryoneExceptFirstSelectBox()
    switch event.srcElement.value
      when 'plan'          then @showGeometry 'surface', 'plan'
      when 'disc'          then @showGeometry 'surface', 'disc'
      when 'cylinder'      then @showGeometry 'surface', 'cylinder'
      when 'sphere'        then @showGeometry 'surface', 'sphere'
      when 'parameterized' then @showGeometry 'surface', 'parameterized'
      else                 $(@el).find('#surface_geometry').show()


  # Hide everything except the criteria select box
  # Let the good geometry select box shown
  # Show the good form regarding the criteria and the geometry choosed
  showGeometry: (criteria, geometry) ->
    if criteria == "volume"
      $(@el).find('#volume_geometry').show()    
    else if criteria == "surface"
      $(@el).find('#surface_geometry').show()    
    $(@el).find("#edge_#{criteria}_#{geometry}").show()

  # Hide all divs except criteria select box
  hideEveryoneExceptFirstSelectBox: ->
    $(@el).find('> div:not("#edge_criteria")').hide()    

  render: ->


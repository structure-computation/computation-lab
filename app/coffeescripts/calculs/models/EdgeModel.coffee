# Edge
SCVisu.Edge = Backbone.Model.extend
  criteria    : ""
  geometry    : ""
  name        : ""
  description : ""

  ## Volume attributes
  # Box attributes
  volume_box_p1X     : 0
  volume_box_p1Y     : 0
  volume_box_p1Z     : 0
  volume_box_p2X     : 0
  volume_box_p2Y     : 0
  volume_box_p2Z     : 0

  # Cylinder attributes  
  volume_cylinder_p1X            : 0
  volume_cylinder_p1Y            : 0
  volume_cylinder_p1Z            : 0
  volume_cylinder_axisDirectionX : 0
  volume_cylinder_axisDirectionY : 0
  volume_cylinder_axisDirectionZ : 0
  volume_cylinder_radius         : 0

  # Sphere attributes
  volume_sphere_centerX : 0
  volume_sphere_centerY : 0
  volume_sphere_centerZ : 0
  volume_sphere_radius  : 0

  ## Surface attributes
  # Plan attributes
  surface_plan_p1X  :0
  surface_plan_p1Y  :0
  surface_plan_p1Z  :0
  # To be continued...
  
  initialize: ->
  
  # Two criteria available: 
  #   Volume
  #   Surface
  setCriteria: (criteria) ->
    @set criteria: criteria
  
  # Three geometry available: 
  #   Box
  #   Cylinder
  #   Sphere
  setGeometry: (geometry) ->
    @set geometry: geometry

# Collection of Step. Keep all steps up to date with each others.
SCVisu.EdgeCollection = Backbone.Collection.extend

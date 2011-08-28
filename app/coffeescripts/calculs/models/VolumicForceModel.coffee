# VolumicForce
# A volumic fore is a force applied on all parts of the model
# Name : Name of this volumic force (weight, centrifugal accelleration,... )
# Parameters are : Gamma (value of accelleration)
# Direction (Dx, Dy, Dz)
SCVisu.VolumicForce = Backbone.Model.extend
  #initialize: ->


# Collection of Step. Keep all steps up to date with each others.
SCVisu.VolumicForceCollection = Backbone.Collection.extend
  model: SCVisu.VolumicForce
  # initialize: -> 

# VolumicForce
# A volumic fore is a force applied on all parts of the model
# Name : Name of this volumic force (weight, centrifugal accelleration,... )
# Parameters are : Gamma (value of accelleration)
# Direction (Dx, Dy, Dz)
SCModels.VolumicForce = Backbone.Model.extend()



# Collection of Step. Keep all steps up to date with each others.
SCModels.VolumicForceCollection = Backbone.Collection.extend
  model: SCModels.VolumicForce
  initialize: () ->
    @bind 'change', () =>                 # Note the '=>' opérator to bind this to the collection object.
      SCVisu.current_calcul.set { volumic_forces : this}

# Edge
SCModels.Edge = Backbone.Model.extend()

# Collection of Step. Keep all steps up to date with each others.
SCModels.EdgeCollection = Backbone.Collection.extend
  model: SCModels.Edge
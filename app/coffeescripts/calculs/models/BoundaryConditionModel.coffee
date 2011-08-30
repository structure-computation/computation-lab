# Boundary Condition
# Contains all attributes of a boundary condition. 
# Attributes are retrieve from the model's JSON 
# Boundary Conditions are not stored in the database, they belong to a model. 
SCModels.BoundaryCondition = Backbone.Model.extend()


# Collection of Boundary Condition
SCModels.BoundaryConditionCollection = Backbone.Collection.extend
  model: SCModels.BoundaryCondition
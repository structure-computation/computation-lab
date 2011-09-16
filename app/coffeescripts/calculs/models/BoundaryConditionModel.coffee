# Boundary Condition
# Contains all attributes of a boundary condition. 
# Attributes are retrieve from the model's JSON 
# Boundary Conditions are not stored in the database, they belong to a model. 
SCModels.BoundaryCondition = Backbone.Model.extend
  defaults:
    name: "Condition"
  getId: ->
    @get("id_in_calcul")
    
# Collection of Boundary Condition
SCModels.BoundaryConditionCollection = Backbone.Collection.extend
  model: SCModels.BoundaryCondition

  initialize: ->
    @bind 'add', (boundaryCondition) =>
      boundaryCondition.set 'id_in_calcul' : @getNewId()

  # Return a new ID
  # Get the highest ID of the collection and add 1
  getNewId: ->
    newId = 1
    @each (model) ->
      newId = model.getId() if model.getId() > newId
    ++newId

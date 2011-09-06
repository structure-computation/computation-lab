# Boundary Condition
# Contains all attributes of a boundary condition. 
# Attributes are retrieve from the model's JSON 
# Boundary Conditions are not stored in the database, they belong to a model. 
SCModels.BoundaryCondition = Backbone.Model.extend
  defaults:
    name: "Condition"



# Collection of Boundary Condition
SCModels.BoundaryConditionCollection = Backbone.Collection.extend
  model: SCModels.BoundaryCondition

  initialize: ->
    # Have to initialize _meta for the meta function
    @._meta = {}
    # Get ID of the last model.
    # Last model because if models have been added and then removed, 
    # we can't presume the last ID will be the length of this.models
    @meta "id_last_model", ((@last() && @last().get('id_in_calcul') + 1) || 1) # @last() && is here to prevent from @last() = undefined
    @bind 'add', (boundaryCondition) =>
      boundaryCondition.set 'id_in_calcul' : @meta("id_last_model")
      @incrementIdLastModel()
  

  # Increment by 1 id_last_model
  incrementIdLastModel: ->
    @meta 'id_last_model', @meta('id_last_model') + 1
    
  # Meta function to have meta property on the Collection
  meta: (property, value) ->
    if value == undefined
      return @._meta[property]
    else
      @._meta[property] = value

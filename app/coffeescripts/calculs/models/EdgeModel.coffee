# Edge
SCModels.Edge = Backbone.Model.extend
  isAssigned: ->
    !_.isUndefined(@get("boundary_condition_id"))

# Collection of Step. Keep all steps up to date with each others.
SCModels.EdgeCollection = Backbone.Collection.extend
  model: SCModels.Edge

  # Set an increment to have the id of the last model which will be added
  initialize: ->
    # Have to initialize _meta for the meta function
    @._meta = {}
    
    # Get ID of the last model.
    # Last model because if models have been added and then removed, 
    # we can't presume the last ID will be the length of this.models
    @meta "id_last_model", ((@last() && @last().get('id_in_calcul') + 1) || 1) # @last() && is here to prevent from @last() = undefined
    @bind 'add', (edge) =>
      edge.set 'id_in_calcul' : @meta("id_last_model")
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

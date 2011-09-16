# Edge
SCModels.Edge = Backbone.Model.extend
  isAssigned: ->
    !_.isUndefined(@get("boundary_condition_id"))
  getId: ->
    @get('id_in_calcul')

# Collection of Step. Keep all steps up to date with each others.
SCModels.EdgeCollection = Backbone.Collection.extend
  model: SCModels.Edge

  # Set an increment to have the id of the last model which will be added
  initialize: ->
    @bind 'add', (edge) =>
      edge.set 'id_in_calcul' : @getNewId()


  # Return a new ID
  # Get the highest ID of the collection and add 1
  getNewId: ->
    newId = 1
    @each (model) ->
      newId = model.getId() if model.getId() > newId
    ++newId

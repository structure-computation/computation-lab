# MultiresolutionParameter
SCModels.MultiresolutionParameter = Backbone.Model.extend

  getId: ->
    @get('id_in_calcul')


# Collection of MultiresolutionParameter.
SCModels.MultiresolutionParameterCollection = Backbone.Collection.extend
  model: SCModels.Step
  
  initialize: ->
    @._meta = {}

    @bind 'add', (model) =>
      model.set 'id_in_calcul' : @getNewId()
      model.set 'name'         : "V#{model.getId() - 1}"

  # Return a new ID
  # Get the highest ID of the collection and add 1
  getNewId: ->
    newId = 1
    @each (step) ->
      newId = step.getId() if step.getId() > newId
    ++newId

  meta: (property, value) ->
    if value == undefined
      return @._meta[property]
    else
      @._meta[property] = value

# MultiresolutionParameter
SCModels.MultiresolutionParameter = Backbone.Model.extend

  getId: ->
    @get('id_in_calcul')


# Collection of MultiresolutionParameter.
SCModels.MultiresolutionParameterCollection = Backbone.Collection.extend
  model: SCModels.MultiresolutionParameter
  
  initialize: ->
    @._meta = {}

    @bind 'add', (model) =>
      model.set 'id_in_calcul' : @getNewId()
      model.set 'name'         : "PM_#{model.getId()}"
      model.set 'alias_name'   : "PM_" + model.getId()
      model.set 'parametric_function'   : "1"
      model.set 'max_value'   : 10
      model.set 'nominal_value'   : 5
      model.set 'min_value'   : 1
      model.set 'nb_value'   : 2
      

  # Return a new ID
  # Get the highest ID of the collection and add 1
  getNewId: ->
    newId = 0
    @each (step) ->
      newId = step.getId() if step.getId() > newId
    ++newId

  meta: (property, value) ->
    if value == undefined
      return @._meta[property]
    else
      @._meta[property] = value

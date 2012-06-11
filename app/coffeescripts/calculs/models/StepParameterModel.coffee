# Step
# A Step is depedent of all other existant step.
# When a step is updated, all existant one must be kept up to date.
SCModels.StepParameter = Backbone.Model.extend
  defaults: 
    id_param            : 0
    name                : "PT_"
    alias_name          : "PT_"

  initialize: ->
    @set 'description' : "description"

  getId: ->
    @get('id_param')
    
# Collection of Step. Keep all steps up to date with each others.
SCModels.StepParameterCollection = Backbone.Collection.extend
  model: SCModels.StepParameter
  initialize: ->
    @._meta = {}

    @bind 'add', (parameter) =>
      parameter.set 'id_param'     : @getNewId()
      parameter.set 'name'   : "PT_" + parameter.getId()
      parameter.set 'alias_name'   : "PT_" + parameter.getId()

  # Return a new ID
  # Get the highest ID of the collection and add 1
  getNewId: ->
    newId = 0
    @each (parameter) ->
      newId = parameter.getId() if parameter.getId() > newId
    ++newId

  meta: (property, value) ->
    if value == undefined
      return @._meta[property]
    else
      @._meta[property] = value

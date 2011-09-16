# Step
# A Step is depedent of all other existant step.
# When a step is updated, all existant one must be kept up to date.
SCModels.Step = Backbone.Model.extend
  defaults: 
    initial_time  : 0
    time_step     : 1
    nb_time_steps : 1
    final_time    : 1

  initialize: ->
    @updateFinalTime()
    @bind('add', @updateFinalTime)
    @bind('change', @updateFinalTime)

  # Update the final_time attribute according to its initial_time and the nb_time_steps
  updateFinalTime: ->
    newFinalTime = @get('initial_time') + (@get('nb_time_steps') * @get('time_step'))
    @set({ final_time: newFinalTime})

  getId: ->
    @get('id_in_calcul')
    
# Collection of Step. Keep all steps up to date with each others.
SCModels.StepCollection = Backbone.Collection.extend
  model: SCModels.Step
  initialize: ->
    @._meta = {}

    @bind 'add', (step) =>
      @updateModels()
      step.set 'id_in_calcul' : @getNewId()

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

  updateModels: ->
    for step, i in @models
      step.set({ name: "step_" + i})
      if i > 0
        step.set({ initial_time: @models[i - 1].get('final_time')})

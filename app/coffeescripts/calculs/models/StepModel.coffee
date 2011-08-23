# Step
# A Step is depedent of all other existant step.
# When a step is updated, all existant one must be kept up to date.
SCVisu.Step = Backbone.Model.extend
  initial_time  : 0
  nb_time_steps : 1
  time_step     : 1
  final_time    : 1
  name          : "default_name"
   
  initialize: ->
    @updateFinalTime()
    @bind('add', @updateFinalTime)
    @bind('change', @updateFinalTime)

  # Update the final_time attribute according to its initial_time and the nb_time_steps
  updateFinalTime: ->
    newFinalTime = @get('initial_time') + (@get('nb_time_steps') * @get('time_step'))
    @set({ final_time: newFinalTime})


# Collection of Step. Keep all steps up to date with each others.
SCVisu.StepCollection = Backbone.Collection.extend
  model: SCVisu.Step
  initialize: -> 
    @bind 'add', (step) ->
      @updateModels()
      
  updateModels: ->
    for step, i in @models
      step.set({ name: "step_" + i})
      if i > 0
        step.set({ initial_time: @models[i - 1].get('final_time')})

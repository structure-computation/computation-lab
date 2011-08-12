window.Step = Backbone.Model.extend
  defaults: {
    name            : "step_",
    initial_time    : 0,
    time_step       : 1,
    nb_time_steps   : 1,
    final_time      : 1,    
  }
  
  initialize: ->
    @updateFinalTime()
    @bind('add', @updateFinalTime)
    @bind('change', @updateFinalTime)
  updateFinalTime: ->
    newFinalTime = @get('initial_time') + (@get('nb_time_steps') * @get('time_step'))
    @set({ final_time: newFinalTime})


window.StepCollection = Backbone.Collection.extend
  model: Step
  initialize: -> 
    @bind('add', (step) ->
      if !@last_step?
        @last_step = step
        step.set({ name: step.get('name') + (@models.length - 1)})
      else
        @nb_step_model += 1
        # Incrémente le nom du step
        step.set({ name: step.get('name') + (@models.length - 1)})
        step.set({ initial_time: @last_step.get('final_time')})
        @last_step = step
    )

  updateModels: ->
    for step, i in @models
      if i > 0
        step.set({ initial_time: @models[i - 1].get('final_time')})
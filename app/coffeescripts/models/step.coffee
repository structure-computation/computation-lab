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
      @updateModels()
    )

  updateModels: ->
    for step, i in @models
      step.set({ name: "step_" + i})
      if i > 0
        step.set({ initial_time: @models[i - 1].get('final_time')})
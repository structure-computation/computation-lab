window.Step = Backbone.Model.extend ({
  name            : "",
  initial_time    : 0,
  time_step       : 1,
  nb_time_steps   : 1,
  final_time      : 1,

  updateFinalTime: ->
    newFinalTime = this.get('initial_time') + (this.get('nb_time_steps') * this.get('time_step'))
    this.set({ final_time: newFinalTime})
})

window.Steps = Backbone.Collection.extend({
  initialize: (step) ->
    this.stepViews = []
    this.stepViews.push(new StepView({model: step}))
    this.bind('add', (step) ->
      this.stepViews.push(new StepView({model: step}))
    )
  ,
  model: Step  
})

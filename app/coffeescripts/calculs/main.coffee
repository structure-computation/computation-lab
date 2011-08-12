$ ->
  Steps   = new StepCollection
  StepsView = new StepListView collection: Steps
  
  $("#add_step").click ->
    StepsView.addStep()

  $("#steps_table").keyup (event)->
    # Update fields only if input value is a number
    if (48 <= event.keyCode <= 57)
      StepsView.trigger 'step_changed'


  window.Calcul = Backbone.Model.extend
    initialize: ->
      company_id             = location.pathname.match(/\/companies\/([0-9]+)\/*/)[1]
      this.selectedMaterials = []
      this.selectedLinks     = []
      this.steps             = [] 

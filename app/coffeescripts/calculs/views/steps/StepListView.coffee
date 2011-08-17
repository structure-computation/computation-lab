## StepListView
window.StepListView = Backbone.View.extend

  el: "#steps"
  # Have to initialize the StepListView with {collection: StepCollection}
  initialize: ->
    step = new Step
      initial_time  : 0
      time_step     : 1
      nb_time_steps : 1
      final_time    : 1  
    @collection.add step
    @stepViews = []
    @stepViews.push new StepView model: step, parentView: this
    @stepViews[0].removeDeleteButton()
    @bind 'step_deleted', @deleteStep, @
    @disableAddButton() # Because the first select value is 'statique'
    @render()
    
  ## Create a model and associate it to a new view
  addStep: ->
    step = new Step
      initial_time  : @collection.models[@collection.models.length - 1].get 'final_time'
      time_step     : 1
      nb_time_steps : 1

    @collection.add step
    @stepViews.push new StepView model: step, parentView: this

  render : ->
    if $(@el).find('select#step_type').val() == "statique"
      @disableAddButton()
    for stepView in @stepViews
      stepView.render()
    if @stepViews.length == 1
      @stepViews[0].removeDeleteButton()


  ## -- Events
  events:
    'keyup'                   : 'updateFieldsKeyUp'
    'click button#add_step'   : 'addStep'
    'change select#step_type' : 'selectChanged'

  # Update all step fields if a number is typed
  updateFieldsKeyUp: (event) ->
#    if (48 <= event.keyCode <= 57)
    @updateFields()

  deleteStep: (step_deleted) ->
    for step, i in @stepViews
      if step == step_deleted
        # Don't need to delete models, they are deleted by the view and @collection.models keeps updated
        @stepViews.splice(i,1)
        break
    @updateFields()
    
  updateFields: ->
    for stepView in @stepViews
      stepView.update()
      @collection.updateModels()

  selectChanged: (event) ->
    if $(event.srcElement).val() == "statique"
      ## Delete all except first element
      for i in [0..@stepViews.length - 1]
        @stepViews[1].delete() if i > 0
      $(@el).find("button#add_step").enable(false)
    else
      $("#add_step").enable()

  disableAddButton: ->
    $(@el).find("button#add_step").enable(false)


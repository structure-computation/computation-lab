window.StepListView = Backbone.View.extend
  # Have to initialize the StepListView with {collection: StepCollection}
  initialize: ->
    @lastStep = new Step
      initial_time  : 0
      time_step     : 1
      nb_time_steps : 1
      final_time    : 1  
    @collection.add @lastStep
    @stepViews = []
    @stepViews.push new StepView model: @lastStep
    
    @bind("step_changed", ->
      @collection.updateModels()
      for stepView in @stepViews
        stepView.update()
    )
  addStep: ->
    step = new Step
      initial_time  : @lastStep.get 'final_time'
      time_step     : 1
      nb_time_steps : 1

    @lastStep     = step
    @collection.add step
    @stepViews.push new StepView model: step

  tagName   : "table"

window.StepView = Backbone.View.extend
  initialize: (step) ->
    @render()
  tagName   : "tr"
  render : ->
    htmlString = """
              <td class="name">
                <input type='text' value='#{@model.get("name")}' disabled> 
              </td> 
              <td class="initial_time">
                <input type='text' value='#{@model.get("initial_time")}' disabled> 
              </td> 
              <td class="time_step"> 
                <input type='text' value='#{@model.get("time_step")}'> 
              </td> 
              <td class="nb_time_steps">
                <input type='text' value='#{@model.get("nb_time_steps")}'> 
              </td> 
              <td class="final_time">
                <input type='text' value='#{@model.get("final_time")}' disabled> 
              </td> 
          """
    $(@el).html(htmlString)
    $('#steps_table tbody').append(@el)
    return this

  updateName: ->
    @model.set
      name          : $(@el).find('.name input').val()
  updateInitialTime: ->
    @model.set
      initial_time  : parseInt($(@el).find('.initial_time input').val())
  updateTimeStep: ->

    @model.set
      time_step     : parseInt($(@el).find('.time_step input').val())
  updateNbTimeStep: ->
    @model.set
      nb_time_steps : parseInt($(@el).find('.nb_time_steps input').val())
  update: ->
    @updateTimeStep()
    @updateNbTimeStep()
    $(@el).find('.name input')          .val(@model.get('name'))
    $(@el).find('.initial_time input')  .val(@model.get('initial_time'))
    $(@el).find('.time_step input')     .val(@model.get('time_step'))
    $(@el).find('.nb_time_steps input') .val(@model.get('nb_time_steps'))
    $(@el).find('.final_time input')    .val(@model.get('final_time'))

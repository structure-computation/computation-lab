## Step View
window.StepView = Backbone.View.extend
  ## @params: Option
  ##    model:          Model of the Step directly bind to the StepView
  ##    parentView: ListView object. Useful to get its element and be able to update all models when a step is removed
  initialize:  (options)->
    @parentView = options.parentView
    @render()
  tagName   : "tr"

  render : ->
    template = """
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
              <td class="final_time">
                <button class='delete'>X</button>
              </td> 
          """

    $(@el).html(template)
    $("#steps").find('tbody').append(@el)
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
  
  removeDeleteButton: ->
    $(@el).find("button").remove()
  
  ## -- Events
  events: 
    'click button.delete' : 'delete'
  delete: ->
    @model.destroy()
    @update()
    @parentView.trigger('step_deleted', this)
    @remove()
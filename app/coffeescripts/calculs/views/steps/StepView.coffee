## Step View
SCViews.StepView = Backbone.View.extend
  ## @params: Option
  ##    model:          Model of the Step directly bind to the StepView
  ##    parentElement: ListView object. Useful to get its element and be able to update all models when a step is removed
  initialize:  (options)->
    @parentElement = options.parentElement
    @render()
    $(@parentElement.el).find('tbody').append(@el)

  tagName   : "tr"

  render : ->
    template = _.template """
              <td class="name">
                <input type='text' value='<%= name %>' disabled> 
              </td> 
              <td class="initial_time">
                <input type='text' value='<%= initial_time %>' disabled> 
              </td> 
              <td class="time_step"> 
                <input type='number' value='<%= time_step %>'> 
              </td> 
              <td class="nb_time_steps">
                <input type='number' value='<%= nb_time_steps %>'> 
              </td> 
              <td class="final_time">
                <input type='text' value='<%= final_time %>' disabled> 
              </td> 
              <td class="final_time">
                <button class='delete'>x</button>
              </td> 
          """

    $(@el).html template
      name          : @model.get('name')
      initial_time  : @model.get('initial_time')
      time_step     : @model.get('time_step')
      nb_time_steps : @model.get('nb_time_steps')
      final_time    : @model.get('final_time')      
      
    return this

  updateName: ->
    @model.set
      name          : $(@el).find('.name input').val()
  updateInitialTime: ->
    @model.set
      initial_time  : parseInt($(@el).find('.initial_time input').val(), 10)
  updateTimeStep: ->

    @model.set
      time_step     : parseInt($(@el).find('.time_step input').val(), 10)
  updateNbTimeStep: ->
    @model.set
      nb_time_steps : parseInt($(@el).find('.nb_time_steps input').val(), 10)
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
    @remove()
## StepListView
window.StepListView = Backbone.View.extend

  tagName: 'div'
  id: 'steps'

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
    @bind('step_deleted', @deleteStep)
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
    htmlString = """
      <button id="add_step">Ajouter un Step</button>
      <select id="step_type">
        <option value="statique">Statique</option>
        <option value="quasistatique">Quasistatique</option>
        <option value="dynamique">Dynamique</option>
      </select>
      <table id="steps_table" class="grey">
         <thead> 
            <tr class='no_sorter'> 
              <th>Nom</th> 
              <th>Temps initial</th> 
              <th>Pas de temps</th> 
              <th>Nombre de pas de temps</th> 
              <th>Temps final</th> 
              <th></th> 
            </tr> 
          </thead> 
          <tbody></tbody>
      </table>
    """
    $(@el).html(htmlString)
    $('#content').append(@el)
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
        #Don't need to delete models, they are deleted by the view and @collection.models keeps updated
        @stepViews.splice(i,1)
        break
    @updateFields()
    
  updateFields: ->
    for stepView in @stepViews
      stepView.update()
      @collection.updateModels()

  selectChanged: (event) ->
    if $(event.srcElement).val() == "statique"
      for i in [0..@stepViews.length - 1]
        @stepViews[1].delete() if i > 0
      $(@el).find("button#add_step").enable(false)
    else
      $("#add_step").enable()

  disableAddButton: ->
    $(@el).find("button#add_step").enable(false)

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
              <td class="final_time">
                <button class='delete'>X</button>
              </td> 
          """
    $(@el).html(htmlString)
    $(@parentView.el).find('tbody').append(@el)
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
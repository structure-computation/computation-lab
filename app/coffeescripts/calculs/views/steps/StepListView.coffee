## StepListView
SCViews.StepListView = Backbone.View.extend

  el: "#steps"

  # Init the list with the new collection.
  # The init method is here to prevent having multiple reference of a step list view
  init: (collection) ->
    @stepViews = []
    @clearView()
    @collection = collection
    time_scheme = SCVisu.current_calcul.get('time_steps').time_scheme
    
    # Select the list item according to the JSON
    @setSelectList time_scheme
    @collection.meta 'time_scheme', time_scheme
    
    if @collection.size() == 0
      step = new SCModels.Step()
      @collection.add step

    for step in @collection.models
      @stepViews.push new SCViews.StepView model: step, parentElement: this

    if @collection.size() == 1 
      @disableAddButton() # Because the first select value is 'statique'
      
    @collection.bind 'destroy', @deleteStep, @
    @render()
    
  ## Create a model and associate it to a new view
  addStep: ->  
    step = new SCModels.Step
      initial_time  : @collection.last().get 'final_time'
      time_step     : 1
      nb_time_steps : 1
    @collection.add step
    @stepViews.push new SCViews.StepView model: step, parentElement: this

  render : ->
    if $(@el).find('select#step_type').val() == "static"
      @disableAddButton()
      $('#steps_table').hide()
    else
      $('#steps_table').show()
    for stepView in @stepViews
      stepView.render()
    @stepViews[0].removeDeleteButton()
      
  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#materials' element already exists in the DOM and every time we create a MaterialListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new MaterialListView 
  clearView: ->
    $(@el).find('table#steps_table tbody').html('')

  events:
    'keyup'                   : 'updateFields'
    'change'                  : 'updateFields'
    'click'                   : 'updateFields'
    'click button#add_step'   : 'addStep'
    'change select#step_type' : 'selectChanged'


  # Delete a step in the list
  deleteStep: (step_deleted) ->
    for step, i in @stepViews
      if step == step_deleted
        # Don't need to delete models, they are deleted by the view and @collection.models keeps updated
        @stepViews.splice(i,1)
        break
    @updateFields()
    
  # Update all steps as they all depend of each other 
  updateFields: ->
    for stepView in @stepViews
      stepView.update()
      @collection.updateModels()
    SCVisu.current_calcul.setTimeStepsCollection SCVisu.stepListView.collection.models
    
  selectChanged: (event) ->
    # Change the value of the calcul type according to the value of the select list
    @setTimeScheme($(event.srcElement).val())
  
    if $(event.srcElement).val() == "static"
      $('#steps_table').hide()
      # Delete all except first element
      for i in [0..@stepViews.length - 1]
        @stepViews[1].delete() if i > 0
      $(@el).find("button#add_step").attr('disabled', 'disabled')
    else
      $("#add_step").removeAttr('disabled')
      $('#steps_table').show()

  disableAddButton: ->
    $(@el).find("button#add_step").attr('disabled', 'disabled')
    
  setTimeScheme: (value) ->
    @collection.meta('time_scheme', value)
    SCVisu.current_calcul.setTimeScheme value
    
  setSelectList: (value) ->
    $(@el).find('select#step_type').val(value)    

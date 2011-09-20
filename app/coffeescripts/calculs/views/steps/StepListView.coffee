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
    if time_scheme == "static"
      @disableAddButton()
    else
      $(@el).find('button.add').removeAttr('disabled')

    # Select the list item according to the JSON
    @setSelectList time_scheme
    @collection.meta 'time_scheme', time_scheme
    
    if @collection.size() == 0
      step = new SCModels.Step()
      @collection.add step

    for step in @collection.models
      @stepViews.push new SCViews.StepView model: step, parentElement: this

    @render()
    
  ## Create a model and associate it to a new view
  addStep: ->  
    step = new SCModels.Step
      initial_time  : if @collection.size() > 0 then @collection.last().get 'final_time' else 0
      time_step     : 1
      nb_time_steps : 1
    @collection.add step
    @stepViews.push new SCViews.StepView model: step, parentElement: this

  render : ->
    for stepView in @stepViews
      stepView.render()
      
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
    'click button.add'        : 'addStep'
    'change select#step_type' : 'selectChanged'
    
  # Update all steps as they all depend of each other 
  updateFields: ->
    for stepView in @stepViews
      stepView.update()
      @collection.updateModels()
    SCVisu.current_calcul.trigger 'change'  
    SCVisu.current_calcul.setTimeStepsCollection SCVisu.stepListView.collection.models
  selectChanged: (event) ->
    # Change the value of the calcul type according to the value of the select list
    @setTimeScheme($(event.srcElement).val())
  
    if $(event.srcElement).val() == "static"
      if confirm "Êtes-vous sûr ? Cela va effacer tous vos pas de temps"
        # Delete all
        for i in [0..@stepViews.length - 1]
          @stepViews[i].delete(true)
        $(@el).find("button.add").attr('disabled', 'disabled')
      else
        $('#step_type').val('dynamic')
    else
      $(@el).find("button.add").removeAttr('disabled')

  disableAddButton: ->
    $(@el).find("button.add").attr('disabled', 'disabled')
    
  setTimeScheme: (value) ->
    @collection.meta('time_scheme', value)
    SCVisu.current_calcul.setTimeScheme value
    
  setSelectList: (value) ->
    $(@el).find('select#step_type').val(value)    

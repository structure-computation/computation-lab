SCViews.StepParameterListView = Backbone.View.extend

  el: "#steps"

  # Init the list with the new collection.
  # The init method is here to prevent having multiple reference of a step list view
  init: (collection) ->
    @stepParameterViews = []
    @clearView()
    @collection = collection
    @editView = new SCViews.EditStepParameterView()
    time_scheme = SCVisu.current_calcul.get('time_steps').time_scheme
    if time_scheme == "static"
      @disableAddButton()
    else
      @ableAddButton()
      #if @collection.size() == 0
      #  parameter = new SCModels.StepParameter()
      #  @collection.add parameter

    for parameter in @collection.models
      @stepParameterViews.push new SCViews.StepParameterView model: parameter, parentElement: this

    @render()
    
  events:
    'keyup'                             : 'updateFields'
    'change'                            : 'updateFields'
    'click'                             : 'updateFields'
    'click button.add_parameter'        : 'addStepParameter'
  
  ## Create a model and associate it to a new view
  addStepParameter: ->  
    parameter = new SCModels.StepParameter()
    @collection.add parameter
    @stepParameterViews.push new SCViews.StepParameterView model: parameter, parentElement: this

  render : ->
    for stepParameterView in @stepParameterViews
      stepParameterView.render()
    #$(@stepParameterViews[0].el).find('button.delete').remove() if @stepParameterViews[0]
      
  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#materials' element already exists in the DOM and every time we create a MaterialListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new MaterialListView 
  clearView: ->
    $(@el).find('table#parameters_table tbody#parameters').html('')  
    
  # Update all steps as they all depend of each other 
  updateFields: ->
    for stepParameterView in @stepParameterViews
      stepParameterView.update()
    SCVisu.current_calcul.trigger 'change'  
    SCVisu.current_calcul.setTimeStepsParameter SCVisu.stepParameterListView.collection.models

  disableAddButton: ->
    $(@el).find("button.add_parameter").attr('disabled', 'disabled')
    
  ableAddButton: ->
    $(@el).find('button.add_parameter').removeAttr('disabled')
    
    # Show edit view of the given model.
  showDetails: (model) ->
    @editView.setModel model
    
  delete_views: ()->
    for i in [0..@stepParameterViews.length - 1]
      @stepParameterViews[i].delete(true)
      

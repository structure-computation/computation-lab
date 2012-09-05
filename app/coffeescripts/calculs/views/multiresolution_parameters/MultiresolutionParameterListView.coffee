SCViews.MultiresolutionParameterListView = Backbone.View.extend

  el: "#multiresolution_parameters"

  # Init the list with the new collection.
  # The init method is here to prevent having multiple reference of a step list view
  init: (collection) ->
    @parameterViews = []
    @clearView()
    @editView = new SCViews.EditMultiresolutionParameterView()
    @collection = collection
    
    multiresolution_type = SCVisu.current_calcul.get('multiresolution_parameters').multiresolution_type
    @collection.meta 'multiresolution_type', multiresolution_type
    resolution_number = SCVisu.current_calcul.get('multiresolution_parameters').resolution_number
    @collection.meta 'resolution_number', resolution_number
    
    for parameter in @collection.models
      @parameterViews.push new SCViews.MultiresolutionParameterView model: parameter, parentElement: this  
    $(@el).find('select#multiresolution_type').val(multiresolution_type)
    $(@el).find('input.resolution_number').val(resolution_number)
    
    if multiresolution_type == "off"
      @setOffTable()
    else if multiresolution_type == "function"
      @setFunctionTable()
    else if multiresolution_type == "orthogonal_plan"
      @setOrthogonalPlanTable()
      
    @render()
    

  events:
    "change input.resolution_number"     : "updateResolutionNumber"
    "click button.add"                   : "addParameter"
    "change select#multiresolution_type" : "selectChanged"

  addParameter: ->
    parameter = new SCModels.MultiresolutionParameter()
    @collection.add parameter
    @parameterViews.push new SCViews.MultiresolutionParameterView model: parameter, parentElement: this
    SCVisu.current_calcul.trigger 'change' 

  selectChanged: (event) ->
    if $(event.srcElement).val() == "off"
      if confirm "Êtes-vous sûr ? Cela va effacer tous vos paramêtres."
        # Delete all except first element
        resolution_number = 1
        SCVisu.current_calcul.setMultiresolutionnumber resolution_number
        @collection.meta 'resolution_number', resolution_number
        $(@el).find('input.resolution_number').val(resolution_number)
        @setOffTable()
        if @parameterViews.length
          for i in [0..@parameterViews.length - 1]
            @parameterViews[i].delete(true)
        
      else
        $('#multiresolution_type').val(SCVisu.current_calcul.setMultiresolutionParameterType)
    else if $(event.srcElement).val() == "function"
      @setFunctionTable()
    else if $(event.srcElement).val() == "orthogonal_plan"
      @setOrthogonalPlanTable()
      
    SCVisu.current_calcul.trigger 'change'  
    SCVisu.current_calcul.setMultiresolutionParameterType $('#multiresolution_type').val()
    SCVisu.current_calcul.setMultiresolutionParameterCollection @collection.models
    
    @render()


  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#materials' element already exists in the DOM and every time we create a MaterialListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new MaterialListView 
  clearView: ->
    $(@el).find('table tbody').html('')

  render: ->
    for view in @parameterViews
      view.render()
    #$(@parameterViews[0].el).find('button.delete').remove() if @parameterViews[0]

  disableAddButton: ->
    $(@el).find("button.add").attr('disabled', 'disabled')
    
  ableAddButton: ->
    $(@el).find('button.add').removeAttr('disabled')
  
  setFunctionTable: ->
    @ableAddButton()
    $(@el).find('input.resolution_number').show()
    $(@el).find('table thead#orthogonal_plan').hide()
    $(@el).find('table thead#function').show()
    
  setOrthogonalPlanTable: ->
    @ableAddButton()
    $(@el).find('input.resolution_number').hide()
    $(@el).find('table thead#orthogonal_plan').show()
    $(@el).find('table thead#function').hide()
    
  setOffTable: ->
    @disableAddButton()
    $(@el).find('input.resolution_number').hide()
    $(@el).find('table thead#orthogonal_plan').hide()
    $(@el).find('table thead#function').hide()
  
  # Show edit view of the given model.
  showDetails: (model) ->
    $(@el).find('input.resolution_number').val(SCVisu.current_calcul.get('multiresolution_parameters').resolution_number)
    @editView.setModel model
    
  updateResolutionNumber: ->
    SCVisu.current_calcul.get('multiresolution_parameters').resolution_number = $(@el).find('input.resolution_number').val()
    #@set('resolution_number') $(@el).find('input.resolution_number').val()
    SCVisu.current_calcul.trigger 'change'
      
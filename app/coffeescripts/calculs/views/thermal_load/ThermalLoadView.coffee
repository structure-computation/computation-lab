## Option
SCViews.ThermalLoadView = Backbone.View.extend
  el: "#thermal_load"
  
  initialize: ->
    # If a model is passed to the constructor, the view will represent this one…
    if @model? 
      # Initialize the view from the informations get back in the JSON file      
      @setName(@model.get('name')) if @model.get('name')
      @setFunction(@model.get('function')) if @model.get('function')

    #… Otherwise, some defaults parameters are set
    else
      @setName("constant") 
      @setFunction("0")
      
  events:
    "change input"                    : "setValues"

  setInputValue: (inputId, value) ->
    $(@el).find("input#{inputId}").val(value)

  # Sets value of the input whose id is #convergence_rate
  setName: (value) ->
    @setInputValue('#thermal_load_name', value)
    
  # Sets value of the input whose id is #max_iteration
  setFunction: (value) ->
    @setInputValue('#thermal_load_function', value)
    
  # Sets value of the input whose id is #convergence_rate
  setValues: ->
    @model.set name             : $(@el).find('input#thermal_load_name').val() 
    @model.set function         : $(@el).find('input#thermal_load_function').val() 
    SCVisu.current_calcul.set thermal_load: @model
    SCVisu.current_calcul.trigger 'change'
    



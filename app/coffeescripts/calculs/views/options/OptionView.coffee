## Option
SCViews.OptionView = Backbone.View.extend
  el: "#calculus_option"
  
  initialize: ->
    # If a model is passed to the constructor, the view will represent this one…
    if @model? 
      # Initialize the view from the informations get back in the JSON file
      if @model.get('mode') == 'test'   
        @setCheckBoxOrRadioButtonChecked('#test_mode', true) 
  
      else if @model.get('mode') == 'normal'
        @setCheckBoxOrRadioButtonChecked('#normal_mode', true) 
        if @model.get('convergence_method_LATIN')
          @setLatinMethod true
          @setMultiScale(@model.get('convergence_method_LATIN').multiscale == 'on' ? true : false)        
          @setMaxIteration(@model.get('convergence_method_LATIN').max_iteration) if @model.get('convergence_method_LATIN').max_iteration
          @setConvergenceRate(@model.get('convergence_method_LATIN').convergence_rate) if @model.get('convergence_method_LATIN').convergence_rate
         
        if @model.get('precision_calcul')
          @setPrecisionCalcul true
          @setZoom(@model.get('precision_calcul').zoom) if @model.get('precision_calcul').zoom
          @setError(@model.get('precision_calcul').error) if @model.get('precision_calcul').error
    #… Otherwise, some defaults parameters are set
    else
      @setCheckBoxOrRadioButtonChecked('#normal_mode', true)
      @setLatinMethod true
      @setPrecisionCalcul true
      
  events:
    "change input#test_mode"         : "testModeSelected"
    "change input:not('#test_mode')" : "normalModeSelected"

  testModeSelected: ->
    $(@el).find('input:not("#test_mode, #normal_mode")').attr 'disabled', 'disabled'
    @model.resetAllAttributes()
    @model.set mode: 'test'
    SCVisu.current_calcul.set options: @model
        
  # Jquery returns an array, that's why you have to specify [0] to get the HTML Element
  normalModeSelected: (event) ->
    $(@el).find('input:not("#test_mode, #normal_mode")').removeAttr 'disabled'
    if $(@el).find('input#test_mode')[0].checked
      @model.set mode : 'test'
    else if $(@el).find('input#normal_mode')[0].checked
      @model.set mode : 'normal'
      if $(@el).find('input#latin_method')[0].checked      
        @model.set convergence_method_LATIN :
                        multiscale       : $(@el).find('input#multiscale_on').val() # on / off
                        max_iteration    : $(@el).find('input#max_iteration').val()
                        convergence_rate : $(@el).find('input#convergence_rate').val()

      if $(@el).find('input#calculus_precision')[0].checked      
        @model.set precision_calcul :
                        zoom  : $(@el).find('input#zoom').val()
                        error : $(@el).find('input#error').val()
    SCVisu.current_calcul.set options: @model

  # Generic method usefull to set value of an input whose ID is passed as a parameter.
  setInputValue: (inputId, value) ->
    $(@el).find("input#{inputId}").val(value)

  # Generic method usefull to set checked or not an input whose ID is passed as a parameter.    
  setCheckBoxOrRadioButtonChecked: (checkBoxId, boolean) ->
      $(@el).find("input#{checkBoxId}").attr 'checked', boolean
  
  # Sets value of the input whose id is #error
  setError: (value) ->
    @setInputValue('#error', value)

  # Sets value of the input whose id is #zoom
  setZoom: (value) ->
    @setInputValue('#zoom', value)

  # Sets value of the input whose id is #convergence_rate
  setConvergenceRate: (value) ->
    @setInputValue('#convergence_rate', value)
    
  # Sets value of the input whose id is #max_iteration
  setMaxIteration: (value) ->
    @setInputValue('#max_iteration', value)

  # Sets checked or not according to the boolean passed in parameters the input whose id is #precision_calcul
  setPrecisionCalcul: (boolean) ->
    @setCheckBoxOrRadioButtonChecked('#calculus_precision', boolean)    

  # Sets checked or not according to the boolean passed in parameters the input whose id is #latin_method
  setLatinMethod: (boolean) ->
    @setCheckBoxOrRadioButtonChecked('#latin_method', boolean)

  # Sets checked the correct radio button according the boolean passed in parameters the input whose id is #multiscale_on or #multiscale_off   
  setMultiScale: (boolean) ->
    if boolean
      @setCheckBoxOrRadioButtonChecked('#multiscale_on', true) 
    else 
     @setCheckBoxOrRadioButtonChecked('#multiscale_off', true) 

   
# "options": {
#   "mode"                      : "test " // Ou "normal"
# 
#   "convergence_method_LATIN"  : { // Null si la convergence méthode LATIN n'est pas séléctionné
#     "multiscale"        : "on"
#     "max_iteration"     : "..."
#     "convergence_rate"  : "..."
#   }
#   "precision_calcul"          : { // Null si la précision du calcul n'est pas séléctionné
#     "zoom"  : "..."
#     "error" : "..."
#   }
# }

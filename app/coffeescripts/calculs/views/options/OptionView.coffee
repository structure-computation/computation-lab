## Option
SCVisu.OptionView = Backbone.View.extend
  el: "#calculus_option"
  
  initialize: ->
    @model = new SCVisu.Option()

  events:
    "change input#test_mode"          : "testModeSelected"
    "change input:not('#test_mode')"  : "normalModeSelected"

  testModeSelected: ->
    $(@el).find('input:not("#test_mode, #normal_mode")').attr 'disabled', 'disabled'
    @model.resetAllAttributes()
        
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

#              
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

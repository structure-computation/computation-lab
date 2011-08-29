# Option
SCModels.Option = Backbone.Model.extend
  resetAllAttributes: ->
    @unset @attributes['mode']
    @unset @attributes['convergence_method_LATIN']
    @unset @attributes['precision_calcul']

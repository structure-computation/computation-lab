# Option
SCModels.Option = Backbone.Model.extend
  resetAllAttributes: ->
    @unset 'mode'
    @unset 'convergence_method_LATIN'
    @unset 'precision_calcul'

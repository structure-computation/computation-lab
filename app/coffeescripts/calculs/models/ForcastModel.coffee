# Option
SCModels.Forcast = Backbone.Model.extend
  initialize: (params)->
    @set sc_model_id  : SCVisu.current_model_id
    @set sc_calcul_id : SCVisu.current_calcul.get('id')
    @url = "/calculs/"
    @setAttributes params
    #alert @get('nb_proc')

  resetAllAttributes: ->
    @unset 'nb_proc'
    @unset 'estimated_time'
    @unset 'nb_token'
    
  resetUrl: ->
    @url = "/calculs/"
    
  setAttributes: (params) ->
    @set launch_autorisation    : "false"
    @set cpu_allocated          : params.cpu_allocated   
    @set estimated_time         : params.estimated_time
    @set nb_token               : params.nb_token
    @set launch_autorisation    : "true" if params.launch_autorisation == true
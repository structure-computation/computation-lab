window.Calcul = Backbone.Model.extend
  initialize: (calcul) ->
    @set gpu_allocated         : calcul.gpu_allocated
    @set launch_autorisation   : calcul.launch_autorisation
    @set name                  : calcul.name
    @set created_at            : calcul.created_at
    @set calcul_time           : calcul.calcul_time
    @set sc_model_id           : calcul.sc_model_id
    @set updated_at            : calcul.updated_at
    @set id                    : calcul.id
    @set used_memory           : calcul.used_memory
    @set launch_date           : calcul.launch_date
    @set user_id               : calcul.user_id
    @set description           : calcul.description
    @set ctype                 : calcul.ctype
    @set estimated_calcul_time : calcul.estimated_calcul_time
    @set result_date           : calcul.result_date
    @set D2type                : calcul.D2type
    @set log_type              : calcul.log_type
    @set state                 : calcul.state
    @set brouillon             :
      time_step: []
      materials: []
      
    @sc_model_id = calcul.sc_model_id
    
    @url = "/sc_models/#{@sc_model_id}/calculs/" + @id
    
    # Bind this object in order to react at the 'update_time_step' event
    @bind 'update_time_step', @update_time_step, @

  # Update time_step of the current model with the array of time_step passed in parameters
  update_time_step: (time_step_array) ->
    @get('brouillon').time_step = time_step_array

  update_materials: (params) ->
    @get('brouillon').time_step = params

window.Calculs = Backbone.Collection.extend
  model: Calcul

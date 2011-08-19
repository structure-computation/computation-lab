window.Calcul = Backbone.Model.extend
  initialize: (calcul) ->
    @gpu_allocated         = calcul.gpu_allocated
    @launch_autorisation   = calcul.launch_autorisation
    @name                  = calcul.name
    @created_at            = calcul.created_at
    @calcul_time           = calcul.calcul_time
    @sc_model_id           = calcul.sc_model_id
    @updated_at            = calcul.updated_at
    @id                    = calcul.id
    @used_memory           = calcul.used_memory
    @launch_date           = calcul.launch_date
    @user_id               = calcul.user_id
    @description           = calcul.description
    @ctype                 = calcul.ctype
    @estimated_calcul_time = calcul.estimated_calcul_time
    @result_date           = calcul.result_date
    @D2type                = calcul.D2type
    @log_type              = calcul.log_type
    @state                 = calcul.state


window.Calculs = Backbone.Collection.extend
  model: Calcul

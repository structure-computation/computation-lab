## StepListView
SCViews.ForcastView = Backbone.View.extend
  el: "#forcast"

  initialize: ->
    $("#forcast_ask_detail").hide()
    #alert @model.get('nb_proc')
    #@updateForcast()
    

  events:
    'click button#forcast_ask'     : 'askForcast'
    'click button#forcast_valid'   : 'validCalcul'  

  askForcast: ->
    $.post("/calculs/compute_forcast",{sc_model_id: @model.get('sc_model_id'), id: @model.get('sc_calcul_id')},
      (params) ->
        SCVisu.NOTIFICATIONS.close()
        SCVisu.forcastView.updateForcast1 params
    )
    
  updateForcast1: (params) ->
    @model.setAttributes params
    @updateForcast()
  
  updateForcast: ->
    $(@el).find('#forcast_cpu_allocated').html @model.get('cpu_allocated')
    $(@el).find('#forcast_estimated_time').html @model.get('estimated_time')
    $(@el).find('#forcast_nb_token').html @model.get('nb_token')
    $(@el).find('#forcast_launch_autorisation').html @model.get('launch_autorisation')
    if @model.get('launch_autorisation') == "true"
      $("#forcast_valid_div").show()
      $("#forcast_unvalid_div").hide()
    else if @model.get('launch_autorisation') == "false"
      $("#forcast_valid").hide()
      $("#forcast_unvalid_div").show()
      
    $("#forcast_ask_detail").show()
    
  validCalcul: ->
    $.post("/calculs/send_calcul",{sc_model_id: @model.get('sc_model_id'), id: @model.get('sc_calcul_id')},
      (params) ->
        SCVisu.NOTIFICATIONS.setText(params.message)
    )
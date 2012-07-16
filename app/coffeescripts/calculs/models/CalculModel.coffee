# Calcul
# Contains all attributes of a calcul : 
#   Steps
#   Pieces
#   Etc.
# The model is saved in the Database

SCModels.Calcul = Backbone.Model.extend
  initialize: ->
    #informatio sur le maillage
    @set mesh                  : []
    #geometry
    @set pieces                : []
    @set interfaces            : []
    @set edges                 : []
    #behaviour
    @set materials             : []
    @set links                 : []
    @set boundary_conditions   : []
    @set volumic_forces        : []
    @set thermal_load          : []
    #options parameters
    @set time_steps            :
      time_scheme           : "static"
      collection            : []
      parameter_collection  : []
    @set multiresolution_parameters :
      multiresolution_type : "off"
      resolution_number    : 1
      collection  : []
    @set options               : 
             convergence_method_LATIN : 
                  convergence_rate      : "0.0001",
                  max_iteration         : "100",
                  multiscale            : "on"
    @set forcasts :
       nb_proc                  : "0"
       estimated_time           : "0"
       nb_token                 : "0"
       launch_autorisation      : 0
      
    @sc_model_id  = SCVisu.current_model_id

    if _.isUndefined @get('id') 
      @url = "/sc_models/#{@sc_model_id}/calculs/"
    else 
      @url = "/sc_models/#{@sc_model_id}/calculs/" + @get 'id'
    @bind('change', @enableSaveButton)

  enableSaveButton: ->
    $('#save_calcul').removeAttr("disabled")
    
  resetUrl: ->
    @url = "/sc_models/#{@sc_model_id}/calculs/" + @get 'id'
     
  setElements: (params) ->
    #time_scheme
    @setTimeScheme params.time_steps.time_scheme
    @setTimeStepsCollection params.time_steps.collection
    @setTimeStepsParameter params.time_steps.parameter_collection
    
    @setMultiresolutionParameterCollection params.multiresolution_parameters.collection
    @setMultiresolutionParameterType params.multiresolution_parameters.multiresolution_type
    @setMultiresolutionnumber params.multiresolution_parameters.resolution_number
    @set mesh                   : params.mesh
    @set materials              : params.materials
    @set pieces                 : params.pieces  
    @set links                  : params.links  
    @set interfaces             : params.interfaces
    @set boundary_conditions    : params.boundary_conditions
    @set options                : params.options
    @set volumic_forces         : params.volumic_forces
    @set thermal_load           : params.thermal_load
    @set edges                  : params.edges
    @set last_saved             : params.last_saved
    
  setTimeScheme: (time_scheme) ->
    @get('time_steps').time_scheme = time_scheme
  
  setTimeStepsCollection: (time_steps) ->
    @get('time_steps').collection = time_steps
    
  setTimeStepsParameter: (time_steps_parameters) ->
    @get('time_steps').parameter_collection = time_steps_parameters

  setMultiresolutionParameterCollection: (multiresolution_parameters) ->
    @get('multiresolution_parameters').collection = multiresolution_parameters

  setMultiresolutionParameterType:   (multiresolution_type) ->
    @get('multiresolution_parameters').multiresolution_type = multiresolution_type
    
  setMultiresolutionnumber:   (resolution_number) ->
    @get('multiresolution_parameters').resolution_number = resolution_number
    
# Collection of Calcul
SCModels.Calculs = Backbone.Collection.extend
  model: SCModels.Calcul

# Calcul
# Contains all attributes of a calcul : 
#   Steps
#   Pieces
#   Etc.
# The model is saved in the Database

SCModels.Calcul = Backbone.Model.extend
  initialize: ->
    @set boundary_condition    : []
    @set materials             : []
    @set pieces                : []
    @set links                 : []
    @set interfaces            : []
    @set volumic_forces        : []
    @set time_steps            :
      time_scheme : "static"
      collection  : []
    @set options               : {}
      
    @sc_model_id  = @get 'sc_model_id'

    @url = "/sc_models/#{@sc_model_id}/calculs/" + @get 'id'

    
  setElements: (params) ->
    @setTimeStepsCollection params.time_steps.collection
    @setTimeScheme params.time_steps.time_scheme
    @set materials          : params.materials
    @set pieces             : params.pieces  
    @set links              : params.links  
    @set interfaces         : params.interfaces
    @set boundary_condition : params.boundary_condition
    @set options            : params.options
    @set volumic_forces     : params.volumic_forces
    
  setTimeStepsCollection: (time_steps) ->
    @get('time_steps').collection = time_steps

  setTimeScheme: (time_scheme) ->
    @get('time_steps').time_scheme = time_scheme
       
# Collection of Calcul
SCModels.Calculs = Backbone.Collection.extend
  model: SCModels.Calcul

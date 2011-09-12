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
    @set edges        : []
    @set time_steps            :
      time_scheme : "static"
      collection  : []
    @set options               : {}
      
    @sc_model_id  = SCVisu.current_model_id

    if _.isUndefined @get('id') 
      @url = "/sc_models/#{@sc_model_id}/calculs/"
    else 
      @url = "/sc_models/#{@sc_model_id}/calculs/" + @get 'id'
    @bind('change', @test)

  test: ->
    #console.log 'test' + new 
    
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
    @set edges              : params.edges
    @set last_saved         : params.last_saved
    
  setTimeStepsCollection: (time_steps) ->
    @get('time_steps').collection = time_steps

  setTimeScheme: (time_scheme) ->
    @get('time_steps').time_scheme = time_scheme
       
# Collection of Calcul
SCModels.Calculs = Backbone.Collection.extend
  model: SCModels.Calcul

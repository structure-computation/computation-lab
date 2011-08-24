# Calcul
# Contains all attributes of a calcul : 
#   Steps
#   Pieces
#   Etc.
# The model is saved in the Database

SCVisu.Calcul = Backbone.Model.extend
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
    @time_steps  = []
    @materials  = []
    @pieces     = []
    @links      = []
    @interfaces = []
      
    @sc_model_id  = calcul.sc_model_id

    @url = "/sc_models/#{@sc_model_id}/calculs/" + @get 'id'
    
    # Bind this object in order to react at the 'update_time_step' event
    @bind 'update_time_step', @updateTimeStep, @
    @bind 'update_materials', @updateMaterials, @
    @bind 'update_pieces', @updatePieces, @
    @bind 'update_links', @updateLinks, @
    @bind 'update_interfaces', @updateInterfaces, @

  # Update time_step of the current model with the array of time_step passed in parameters
  updateTimeStep: (timeStepsArray) ->
    @set 'time_steps' : timeStepsArray

  # Update materials of the current model with the array of materials passed in parameters
  updateMaterials: (materialsArray) ->
    @set 'materials': materialsArray

  # Update pieces of the current model with the array of pieces passed in parameters
  updatePieces: (piecesArray) ->
    @set 'pieces' : piecesArray

  # Update links of the current model with the array of links passed in parameters
  updateLinks: (linksArray) ->
    @set 'links' : linksArray
    
  updateInterfaces: (interfacesArray) ->
    @set 'interfaces' : interfacesArray
    
  setElements: (params) ->
    @updateTimeStep params.time_steps
    @updateMaterials params.materials
    @updatePieces params.pieces  
    @updateLinks params.links  
    @updateInterfaces params.interfaces  
# Collection of Calcul
SCVisu.Calculs = Backbone.Collection.extend
  model: SCVisu.Calcul

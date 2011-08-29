# Calcul
# Contains all attributes of a calcul : 
#   Steps
#   Pieces
#   Etc.
# The model is saved in the Database

SCModels.Calcul = Backbone.Model.extend
  initialize: ->
    @set time_steps            : []
    @set materials             : []
    @set pieces                : []
    @set links                 : []
    @set interfaces            : []
      
    @sc_model_id  = @get 'sc_model_id'

    @url = "/sc_models/#{@sc_model_id}/calculs/" + @get 'id'
    
    # Bind this object in order to react at the 'update_time_step' event
    @bind 'update_time_step', @updateTimeStep, @
    @bind 'update_materials', @updateMaterials, @
    @bind 'update_pieces', @updatePieces, @
    @bind 'update_links', @updateLinks, @
    @bind 'update_interfaces', @updateInterfaces, @

  # Update time_step of the current model with the array of time_step passed in parameters
  updateTimeStep: (timeStepsArray) ->
    @set time_steps : timeStepsArray

  # Update materials of the current model with the array of materials passed in parameters
  updateMaterials: (materialsArray) ->
    @set materials: materialsArray

  # Update pieces of the current model with the array of pieces passed in parameters
  updatePieces: (piecesArray) ->
    @set pieces : piecesArray

  # Update links of the current model with the array of links passed in parameters
  updateLinks: (linksArray) ->
    @set links : linksArray
    
  updateInterfaces: (interfacesArray) ->
    @set interfaces : interfacesArray
    
  setElements: (params) ->
    @updateTimeStep params.time_steps
    @updateMaterials params.materials
    @updatePieces params.pieces  
    @updateLinks params.links  
    @updateInterfaces params.interfaces
     
# Collection of Calcul
SCModels.Calculs = Backbone.Collection.extend
  model: SCModels.Calcul

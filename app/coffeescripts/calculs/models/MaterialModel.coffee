# Material
# Contains all attributes of a Material stored in the database
# Attributes can be retrieve from the model's JSON or from the database

SCModels.Material = Backbone.Model.extend
  initialize: ->
    @piece = null
    @workspace_id = if SCVisu.current_workspace? then SCVisu.current_workspace else 0
    @url = "/companies/#{@workspace_id}/materials/"

  # Get the ID of the material in the JSON
  getId: ->
    @get 'id_in_calcul'

SCModels.MaterialCollection = Backbone.Collection.extend
  model: SCModels.Material
  initialize: (options) ->
    @workspace_id = if SCVisu.current_workspace? then SCVisu.current_workspace else 0
    @url = "/companies/#{@workspace_id}/materials"
    # Have to initialize _meta for the meta function
    @._meta = {}

    # Get ID of the last model.
    # Last model because if models have been added and then removed, 
    # we can't presume the last ID will be the length of this.models
    @meta "id_last_model", ((@last() && @last().get('id_in_calcul') + 1) || 1) # @last() && is here to prevent from @last() = undefined
    @bind 'add', (material) =>
      material.set 'id_in_calcul' : @meta("id_last_model")
      @incrementIdLastModel()
  
  addAndSave: (material) ->
    material.save {},
      success: ->
        SCVisu.current_calcul.set materials: SCVisu.materialListView.collection.models

    

  # Increment by 1 id_last_model
  incrementIdLastModel: ->
    @meta 'id_last_model', @meta('id_last_model') + 1
    
  # Meta function to have meta property on the Collection
  meta: (property, value) ->
    if value == undefined
      return @._meta[property]
    else
      @._meta[property] = value

# Material
# Contains all attributes of a Material stored in the database
# Attributes can be retrieve from the model's JSON or from the database

SCModels.Material = Backbone.Model.extend
  initialize: ->
    @workspace_id = if SCVisu.current_workspace? then SCVisu.current_workspace else 0
    @url = "/workspaces/#{@workspace_id}/materials/"

  # Get the ID of the material in the JSON
  getId: ->
    @get 'id_in_calcul'

# Collection of Material
SCModels.MaterialCollection = Backbone.Collection.extend
  model: SCModels.Material
  initialize: (options) ->
    @workspace_id = if SCVisu.current_workspace? then SCVisu.current_workspace else 0
    @url = "/workspaces/#{@workspace_id}/materials"

    @bind 'add', (material) =>
      material.set 'id_in_calcul' : @getNewId()
  
  addAndSave: (material) ->
    material.save {},
      success: ->
        SCVisu.current_calcul.set materials: SCVisu.materialListView.collection.models

  # Return a new ID
  # Get the highest ID of the collection and add 1
  getNewId: ->
    newId = 1
    @each (model) ->
      newId = model.getId() if model.getId() > newId
    ++newId

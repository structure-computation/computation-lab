# Material
# Contains all attributes of a Material stored in the database
# Attributes can be retrieve from the model's JSON or from the database

SCModels.Material = Backbone.Model.extend
  initialize: ->
    @piece = null
    @company_id = if SCVisu.current_company? then SCVisu.current_company else 0
    @url = "/companies/#{@company_id}/materials/"

  # Get the ID of the material in the JSON
  getId: ->
    @get 'id_in_calcul'

SCModels.MaterialCollection = Backbone.Collection.extend
  model: SCModels.Material
  initialize: (options) ->
    @company_id = if SCVisu.current_company? then SCVisu.current_company else 0
    @url = "/companies/#{@company_id}/materials"
  
  addAndSave: (material) ->
    material.save {},
      success: ->
        SCVisu.current_calcul.set materials: SCVisu.materialListView.collection.models

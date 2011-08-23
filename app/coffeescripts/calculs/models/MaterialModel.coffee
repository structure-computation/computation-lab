# Material
# Contains all attributes of a Material stored in the database
# Attributes can be retrieve from the model's JSON or from the database

SCVisu.Material = Backbone.Model.extend
  initialize: ->
    @piece = null

  assignPiece: (piece) ->
    @piece = piece

  
SCVisu.MaterialCollection = Backbone.Collection.extend
  model: SCVisu.Material
  initialize: (options) ->
    @company_id = if SCVisu.current_company? then SCVisu.current_company else 0
    @url = "/companies/#{@company_id}/materials"

    @bind "add", (material) ->
      material.save {},
        success: ->
          SCVisu.current_calcul.trigger 'update_materials', MaterialViews.collection.models
# Material
# Contains all attributes of a Material stored in the database
# Attributes can be retrieve from the model's JSON or from the database

SCVisu.Material = Backbone.Model.extend
  initialize: ->
    @piece = null
    @company_id = if SCVisu.current_company? then SCVisu.current_company else 0
    @url = "/companies/#{@company_id}/materials/"
    @url += @get 'id' if !@isNew()

  assignPiece: (piece) ->
    @piece = piece

  isFromJson: ->
    if _.isUndefined @get 'library' then true else false

  isStandard: ->
    if @get 'library' == 'standard' then true else false

  isCompany: ->
    if @get 'library' == 'company' then true else false  

SCVisu.MaterialCollection = Backbone.Collection.extend
  model: SCVisu.Material
  initialize: (options) ->
    @company_id = if SCVisu.current_company? then SCVisu.current_company else 0
    @url = "/companies/#{@company_id}/materials"
  
  addAndSave: (material) ->
    material.save {},
      success: ->
        SCVisu.current_calcul.trigger 'update_materials', SCVisu.materialListView.collection.models

  setAs: (library) ->
    _.each @models, (model) ->
      model.set library : library
    return this

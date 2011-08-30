# Link
# Contains all attributes of a Link stored in the database
# Attributes can be retrieve from the model's JSON or from the database

SCModels.Link = Backbone.Model.extend
  initialize: ->
    @company_id = if SCVisu.current_company? then SCVisu.current_company else 0
    @url = "/companies/#{@company_id}/links/"
    @url += @get 'id' if !@isNew()
  
  getId: ->
    @get 'id_in_calcul'

# Collection of Link
SCModels.LinkCollection = Backbone.Collection.extend
  model: SCModels.Link
  initialize: (options) ->
    @company_id = if SCVisu.current_company? then SCVisu.current_company else 0
    @url = "/companies/#{@company_id}/links"

  addAndSave: (link) ->
      link.save {},
        success: ->
          SCVisu.current_calcul.trigger 'update_links', SCVisu.linkListView.collection.models

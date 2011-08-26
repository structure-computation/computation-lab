# Link
# Contains all attributes of a Link stored in the database
# Attributes can be retrieve from the model's JSON or from the database

SCVisu.Link = Backbone.Model.extend
  initialize: ->
    @company_id = if SCVisu.current_company? then SCVisu.current_company else 0
    @url = "/companies/#{@company_id}/links/"
    @url += @get 'id' if !@isNew()

  isFromJson: ->
    if _.isUndefined @set 'library' then true else false

  isStandard: ->
    if @get 'library' == 'standard' then true else false

  isCompany: ->
    if @get 'library' == 'company' then true else false  

# Collection of Link
SCVisu.LinkCollection = Backbone.Collection.extend
  model: SCVisu.Link
  initialize: (options) ->
    @company_id = if SCVisu.current_company? then SCVisu.current_company else 0
    @url = "/companies/#{@company_id}/links"

  addAndSave: (link) ->
      link.save {},
        success: ->
          SCVisu.current_calcul.trigger 'update_links', SCVisu.linkListView.collection.models

  setAs: (library) ->
    _.each @models, (model) ->
      model.set library : library
    return this

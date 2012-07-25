# Link
# Contains all attributes of a Link stored in the database
# Attributes can be retrieve from the model's JSON or from the database

SCModels.Link = Backbone.Model.extend
  initialize: ->
    @workspace_id = if SCVisu.current_workspace? then SCVisu.current_workspace else 0
    @url = "/workspaces/#{@workspace_id}/links/"
    @set "Ep_Type" : "0" if _.isUndefined(@get("Ep_Type"))

  # Get the ID of the link in the JSON
  getId: ->
    @get 'id_in_calcul'

# Collection of Link
SCModels.LinkCollection = Backbone.Collection.extend
  model: SCModels.Link
  initialize: (options) ->
    @workspace_id = if SCVisu.current_workspace? then SCVisu.current_workspace else 0
    @url = "/workspaces/#{@workspace_id}/links"
    @bind 'add', (link) =>
      link.set 'id_in_calcul' : @getNewId()

  addAndSave: (link) ->
    link.save {},
      success: ->
        SCVisu.current_calcul.set links: SCVisu.linkListView.collection.models

  # Return a new ID
  # Get the highest ID of the collection and add 1
  getNewId: ->
    newId = 1
    @each (model) ->
      newId = model.getId() if model.getId() > newId
    ++newId

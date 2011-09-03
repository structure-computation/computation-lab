# Link
# Contains all attributes of a Link stored in the database
# Attributes can be retrieve from the model's JSON or from the database

SCModels.Link = Backbone.Model.extend
  initialize: ->
    @company_id = if SCVisu.current_company? then SCVisu.current_company else 0
    @url = "/companies/#{@company_id}/links/"

  # Get the ID of the link in the JSON
  getId: ->
    @get 'id_in_calcul'

# Collection of Link
SCModels.LinkCollection = Backbone.Collection.extend
  model: SCModels.Link
  initialize: (options) ->
    @company_id = if SCVisu.current_company? then SCVisu.current_company else 0
    @url = "/companies/#{@company_id}/links"

    # Have to initialize _meta for the meta function
    @._meta = {}

    # Get ID of the last model.
    # Last model because if models have been added and then removed, 
    # we can't presume the last ID will be the length of this.models
    @meta "id_last_model", ((@last() && @last().get('id') + 1) || 1) # @last() && is here to prevent from @last() = undefined
    @bind 'add', (link) =>
      link.set 'id' : @meta("id_last_model")
      @incrementIdLastModel()

  addAndSave: (link) ->
      link.save {},
        success: ->
          SCVisu.current_calcul.set links: SCVisu.linkListView.collection.models

  # Increment by 1 id_last_model
  incrementIdLastModel: ->
    @meta 'id_last_model', @meta('id_last_model') + 1
    
  # Meta function to have meta property on the Collection
  meta: (property, value) ->
    if value == undefined
      return @._meta[property]
    else
      @._meta[property] = value

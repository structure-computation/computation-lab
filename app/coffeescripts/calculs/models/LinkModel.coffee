# Link
# Contains all attributes of a Link stored in the database
# Attributes can be retrieve from the model's JSON or from the database

SCVisu.Link = Backbone.Model.extend()

# Collection of Link
SCVisu.Links = Backbone.Collection.extend
  model: SCVisu.Link
  initialize: (options) ->
    @company_id = if SCVisu.current_company? then SCVisu.current_company else 0
    @url = "/companies/#{@company_id}/links"


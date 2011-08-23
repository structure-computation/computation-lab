SCVisu.Link = Backbone.Model.extend()

SCVisu.Links = Backbone.Collection.extend
  model: SCVisu.Link
  initialize: (options) ->
    @company_id = if SCVisu.current_company? then SCVisu.current_company else 0
    @url = "/companies/#{@company_id}/links"


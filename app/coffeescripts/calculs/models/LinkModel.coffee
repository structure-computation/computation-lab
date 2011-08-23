window.Link = Backbone.Model.extend()

window.Links = Backbone.Collection.extend
  model: Link
  initialize: (options) ->
    @company_id = if window.current_company? then window.current_company else 0
    @url = "/companies/#{@company_id}/links"


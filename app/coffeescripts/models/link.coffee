window.Link = Backbone.Model.extend()

window.Links = Backbone.Collection.extend
  model: Link
  initialize: (options) ->
    @company_id = if options.company_id? then options.company_id else 1
    @url = "/companies/#{@company_id}/links"


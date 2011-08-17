window.Material = Backbone.Model.extend()

window.Materials = Backbone.Collection.extend
  model: Material
  initialize: (options) ->
    @company_id = if options.company_id? then options.company_id else 1
    @url = "/companies/#{@company_id}/materials"



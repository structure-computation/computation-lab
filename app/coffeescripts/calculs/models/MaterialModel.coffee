window.Material = Backbone.Model.extend
  initialize: ->
    @piece = null

  assignPiece: (piece) ->
    @piece = piece

  
window.Materials = Backbone.Collection.extend
  model: Material
  initialize: (options) ->
    @company_id = if options.company_id? then options.company_id else 0
    @url = "/companies/#{@company_id}/materials"
    @bind "add", (ship) ->
      ship.save()
      
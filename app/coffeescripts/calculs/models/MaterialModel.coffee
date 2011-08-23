window.Material = Backbone.Model.extend
  initialize: ->
    @piece = null

  assignPiece: (piece) ->
    @piece = piece

  
window.Materials = Backbone.Collection.extend
  model: Material
  initialize: (options) ->
    @company_id = if window.current_company? then window.current_company else 0
    @url = "/companies/#{@company_id}/materials"
    @bind "add", (ship) ->
      console.log ship
      ship.save(
        success: (response) -> 
          console.log response
        error: (response) ->
          console.log response
      )
      
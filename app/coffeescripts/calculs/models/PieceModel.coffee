window.Piece = Backbone.Model.extend
  initialize: (piece) ->
    @group          = piece.group
    @name           = piece.name
    @origin         = piece.origin
    @assigned       = piece.assigned
    @id             = piece.id
    @identificateur = piece.identificateur
    @material_id    = piece.material_id || 0


window.Pieces = Backbone.Collection.extend
  model: Piece
  initialize: ->
    @add new Piece {
            "group": -1
            "name": "piece 0"
            "origine": "from_bulkdata"
            "assigned": 0
            "id": 0
            "identificateur": 26
          }

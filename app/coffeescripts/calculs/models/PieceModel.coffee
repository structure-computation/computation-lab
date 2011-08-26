# Piece
# Contains all attributes of a Piece.
# Attributes are retrieve from the model's JSON

SCVisu.Piece = Backbone.Model.extend
  isAssigned: ->
    if _.isUndefined(@get("material_id")) then false else true

SCVisu.PieceCollection = Backbone.Collection.extend
  model: SCVisu.Piece

# Piece
# Contains all attributes of a Piece.
# Attributes are retrieve from the model's JSON

SCModels.Piece = Backbone.Model.extend
  isAssigned: ->
    if _.isUndefined(@get("material_id")) then false else true

SCModels.PieceCollection = Backbone.Collection.extend
  model: SCModels.Piece

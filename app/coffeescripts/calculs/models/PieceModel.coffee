window.Piece = Backbone.Model.extend
  initialize: (piece) ->
    @group          = piece.group
    @name           = piece.name
    @origin         = piece.origin
    @assigned       = piece.assigned
    @id             = piece.id
    @identificateur = piece.identificateur
    @material_id    = piece.material_id || 0
    @bind 'set_material',  @set_material, this

  set_material: (material_id) ->
    @material_id = material_id

window.PieceCollection = Backbone.Collection.extend
  model: Piece

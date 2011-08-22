window.Piece = Backbone.Model.extend
  initialize: (piece) ->
    @group          = piece.group
    @name           = piece.name
    @origin         = piece.origin
    @assigned       = piece.assigned
    @id             = piece.id
    @identificateur = piece.identificateur
    @set material_id: piece.material_id || 0
    @bind 'set_material',  @set_material, this

  # Object or Id can be passed in parameter
  setMaterial: (material) ->
    if _.isNumber(material)
      @material_id = material
    else
      @material_id = material.get('id')
    @set material_id: @material_id

window.PieceCollection = Backbone.Collection.extend
  model: Piece

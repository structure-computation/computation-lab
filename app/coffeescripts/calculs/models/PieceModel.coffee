# Piece
# Contains all attributes of a Piece.
# Attributes are retrieve from the model's JSON

SCVisu.Piece = Backbone.Model.extend
  initialize: (piece) ->
    @set group          : piece.group
    @set name           : piece.name
    @set origin         : piece.origin
    @set assigned       : piece.assigned
    @set id             : piece.id
    @set identificateur : piece.identificateur
    @set material_id    : piece.material_id || 0
    
    @bind 'set_material',  @set_material, this

  # Object or Id can be passed in parameter
  setMaterial: (material) ->
    if _.isNumber(material)
      @material_id = material
    else
      @material_id = material.get('id')
    @set material_id: @material_id

SCVisu.PieceCollection = Backbone.Collection.extend
  model: SCVisu.Piece

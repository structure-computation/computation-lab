/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 20:49:19 GMT from
 * /Users/StephieChou/rails_project/sc_interface/app/coffeescripts/calculs/models/PieceModel.coffee
 */

(function() {
  window.Piece = Backbone.Model.extend({
    initialize: function(piece) {
      this.group = piece.group;
      this.name = piece.name;
      this.origin = piece.origin;
      this.assigned = piece.assigned;
      this.id = piece.id;
      this.identificateur = piece.identificateur;
      return this.material_id = piece.material_id || 0;
    }
  });
  window.PieceCollection = Backbone.Collection.extend({
    model: Piece
  });
}).call(this);

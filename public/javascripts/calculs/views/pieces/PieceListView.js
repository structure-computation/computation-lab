/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 20:49:21 GMT from
 * /Users/StephieChou/rails_project/sc_interface/app/coffeescripts/calculs/views/pieces/PieceListView.coffee
 */

(function() {
  window.PieceListView = Backbone.View.extend({
    el: 'ul#pieces',
    initialize: function(options) {
      return this.render();
    },
    render: function() {
      var piece, _i, _len, _ref;
      _ref = this.collection.models;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        piece = _ref[_i];
        $(this.el).append("<li>" + (piece.get('name')) + "</li>");
      }
      return this;
    }
  });
}).call(this);

/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 20:49:22 GMT from
 * /Users/StephieChou/rails_project/sc_interface/app/coffeescripts/calculs/views/materials/MaterialListView.coffee
 */

(function() {
  window.MaterialListView = Backbone.View.extend({
    el: 'ul#materials',
    initialize: function(options) {
      return this.render();
    },
    render: function() {
      var material, _i, _len, _ref;
      _ref = this.collection.models;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        material = _ref[_i];
        $(this.el).append("<li data-id='" + (material.get('id')) + "'>" + (material.get('name')) + "</li>");
      }
      return this;
    },
    events: {
      "click li": "showDetails"
    },
    showDetails: function(event) {
      var material, materialId, _i, _len, _ref, _results;
      materialId = parseInt($(event.srcElement).attr("data-id"));
      _ref = this.collection.models;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        material = _ref[_i];
        if (material.get('id') === materialId) {
          this.editView = new EditMaterialView({
            model: material,
            parentElement: this
          });
          break;
        }
      }
      return _results;
    }
  });
}).call(this);

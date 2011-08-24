/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 20:49:22 GMT from
 * /Users/StephieChou/rails_project/sc_interface/app/coffeescripts/calculs/views/materials/SelectedMaterialListView.coffee
 */

(function() {
  window.SelectedMaterialListView = Backbone.View.extend({
    el: '#materials_selected_table',
    initialize: function(options) {
      this.bind('materialRemoved', this.remove_selected_material, this);
      this.bind('editMaterial', this.edit_selected_material, this);
      this.editMaterialView = new EditMaterialView({
        parentElement: this
      });
      return this.materialViews = [];
    },
    render: function() {
      var materialView, _i, _len, _ref, _results;
      _ref = this.materialViews;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        materialView = _ref[_i];
        _results.push(materialView.render());
      }
      return _results;
    },
    edit_selected_material: function(material) {
      return this.editMaterialView.updateModel(material);
    },
    add_material: function(material) {
      var m;
      m = material.clone();
      m.set({
        name: m.get('name') + ' - copy'
      });
      this.materialViews.push(new SelectedMaterialView({
        model: m,
        parentElement: this
      }));
      return this.render();
    },
    remove_selected_material: function(material) {
      var i, materialView, _len, _ref, _results;
      _ref = this.materialViews;
      _results = [];
      for (i = 0, _len = _ref.length; i < _len; i++) {
        materialView = _ref[i];
        if (materialView.model === material) {
          this.materialViews.splice(i, 1);
          materialView.remove();
          this.render();
          break;
        }
      }
      return _results;
    }
  });
}).call(this);

/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 20:49:22 GMT from
 * /Users/StephieChou/rails_project/sc_interface/app/coffeescripts/calculs/views/materials/SelectedMaterialView.coffee
 */

(function() {
  window.SelectedMaterialView = Backbone.View.extend({
    initialize: function(params) {
      return this.parentElement = params.parentElement;
    },
    tagName: "tr",
    events: {
      "click .remove": "remove_selected_material",
      "click .edit": "edit_selected_material"
    },
    edit_selected_material: function() {
      return this.parentElement.trigger('editMaterial', this.model);
    },
    remove_selected_material: function() {
      this.parentElement.trigger('materialRemoved', this.model);
      return this.parentElement.render();
    },
    render: function() {
      var htmlString;
      htmlString = "<td class=\"name\">\n  " + (this.model.get("name")) + "\n</td>\n<td class=\"family\">\n  " + (this.model.get("family")) + "\n</td>\n<td>\n  <button class=\"edit\">Edit</button>\n</td>\n<td>\n  <button class=\"remove\">-</button>\n</td>\n";
      $(this.el).html(htmlString);
      $("#materials_selected_table tbody").append(this.el);
      return this;
    }
  });
}).call(this);

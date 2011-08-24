/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 20:49:21 GMT from
 * /Users/StephieChou/rails_project/sc_interface/app/coffeescripts/calculs/views/materials/MaterialView.coffee
 */

(function() {
  window.MaterialView = Backbone.View.extend({
    initialize: function(params) {
      return this.parentElement = params.parentElement;
    },
    tagName: "tr",
    events: {
      "click .add": "add_selected_material"
    },
    add_selected_material: function() {
      this.parentElement.trigger('material_added', this.model);
      return this.parentElement.render();
    },
    render: function() {
      var htmlString;
      htmlString = "<td class=\"name\">\n  " + (this.model.get("name")) + "\n</td>\n<td class=\"family\">\n  " + (this.model.get("family")) + "\n</td>\n<td>\n  <button class=\"add\">+</button>\n</td>";
      $(this.el).html(htmlString);
      $("#materials_table tbody").append(this.el);
      return this;
    }
  });
}).call(this);

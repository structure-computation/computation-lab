/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 20:49:19 GMT from
 * /Users/StephieChou/rails_project/sc_interface/app/coffeescripts/calculs/models/MaterialModel.coffee
 */

(function() {
  window.Material = Backbone.Model.extend();
  window.Materials = Backbone.Collection.extend({
    model: Material,
    initialize: function(options) {
      this.workspace_id = options.workspace_id != null ? options.workspace_id : 1;
      return this.url = "/companies/" + this.workspace_id + "/materials";
    }
  });
}).call(this);

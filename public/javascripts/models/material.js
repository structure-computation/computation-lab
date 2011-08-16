/* DO NOT MODIFY. This file was compiled Fri, 12 Aug 2011 12:35:38 GMT from
 * /Users/Nico/Development/Rails/sc_interface/app/coffeescripts/models/material.coffee
 */

(function() {
  $(function() {
    window.Material = Backbone.Model.extend;
    return window.Materials = Backbone.Collection.extend({
      model: Material,
      localStorage: new Store("material")
    });
  });
}).call(this);

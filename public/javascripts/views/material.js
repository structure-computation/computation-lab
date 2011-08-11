/* DO NOT MODIFY. This file was compiled Thu, 11 Aug 2011 12:09:21 GMT from
 * /Users/Nima/Sites/Stage/StructureComputation/sc_interface/app/coffeescripts/views/material.coffee
 */

(function() {
  window.MaterialView = Backbone.View.extend({
    initialize: function() {
      $('#materials_list').append(this.el);
      return this.render();
    },
    tagName: "li",
    events: {
      "click": "youhou"
    },
    youhou: function() {
      return alert(this.cid);
    },
    render: function() {
      $(this.el).text("" + (this.model.get('name')));
      return this;
    }
  });
}).call(this);

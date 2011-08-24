/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 20:49:20 GMT from
 * /Users/StephieChou/rails_project/sc_interface/app/coffeescripts/calculs/models/InterfaceModels.coffee
 */

(function() {
  window.Interface = Backbone.Model.extend({
    initialize: function(interface) {
      this.group = interface.group;
      this.name = interface.name;
      this.origine = interface.origine;
      this.assigned = interface.assigned;
      this.id = interface.id;
      this.type = interface.type;
      return this.adj_num_group = interface.adj_num_group;
    }
  });
  window.Interfaces = Backbone.Collection.extend({
    model: Interface,
    initialize: function(interfaceCollection) {
      return this.add(new Interface({
        "group": -1,
        "name": "piece 0",
        "origine": "from_bulkdata",
        "assigned": 0,
        "id": 0,
        "identificateur": 26
      }));
    }
  });
}).call(this);

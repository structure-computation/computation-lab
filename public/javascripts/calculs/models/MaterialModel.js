/* DO NOT MODIFY. This file was compiled Tue, 06 Sep 2011 14:34:40 GMT from
 * /Users/raphael/Documents/StructComp/SC_Interface/app/coffeescripts/calculs/models/MaterialModel.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  SCModels.Material = Backbone.Model.extend({
    initialize: function() {
      this.piece = null;
      this.workspace_id = SCVisu.current_company != null ? SCVisu.current_company : 0;
      return this.url = "/companies/" + this.workspace_id + "/materials/";
    },
    getId: function() {
      return this.get('id_in_calcul');
    }
  });
  SCModels.MaterialCollection = Backbone.Collection.extend({
    model: SCModels.Material,
    initialize: function(options) {
      this.workspace_id = SCVisu.current_company != null ? SCVisu.current_company : 0;
      this.url = "/companies/" + this.workspace_id + "/materials";
      this._meta = {};
      this.meta("id_last_model", (this.last() && this.last().get('id_in_calcul') + 1) ||  1);
      return this.bind('add', __bind(function(material) {
        material.set({
          'id_in_calcul': this.meta("id_last_model")
        });
        return this.incrementIdLastModel();
      }, this));
    },
    addAndSave: function(material) {
      return material.save({}, {
        success: function() {
          return SCVisu.current_calcul.set({
            materials: SCVisu.materialListView.collection.models
          });
        }
      });
    },
    incrementIdLastModel: function() {
      return this.meta('id_last_model', this.meta('id_last_model') + 1);
    },
    meta: function(property, value) {
      if (value === void 0) {
        return this._meta[property];
      } else {
        return this._meta[property] = value;
      }
    }
  });
}).call(this);

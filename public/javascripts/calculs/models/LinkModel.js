/* DO NOT MODIFY. This file was compiled Tue, 06 Sep 2011 14:34:40 GMT from
 * /Users/raphael/Documents/StructComp/SC_Interface/app/coffeescripts/calculs/models/LinkModel.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  SCModels.Link = Backbone.Model.extend({
    initialize: function() {
      this.workspace_id = SCVisu.current_company != null ? SCVisu.current_company : 0;
      return this.url = "/companies/" + this.workspace_id + "/links/";
    },
    getId: function() {
      return this.get('id_in_calcul');
    }
  });
  SCModels.LinkCollection = Backbone.Collection.extend({
    model: SCModels.Link,
    initialize: function(options) {
      this.workspace_id = SCVisu.current_company != null ? SCVisu.current_company : 0;
      this.url = "/companies/" + this.workspace_id + "/links";
      this._meta = {};
      this.meta("id_last_model", (this.last() && this.last().get('id') + 1) ||  1);
      return this.bind('add', __bind(function(link) {
        link.set({
          'id': this.meta("id_last_model")
        });
        return this.incrementIdLastModel();
      }, this));
    },
    addAndSave: function(link) {
      return link.save({}, {
        success: function() {
          return SCVisu.current_calcul.set({
            links: SCVisu.linkListView.collection.models
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

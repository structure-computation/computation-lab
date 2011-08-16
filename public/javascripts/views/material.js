/* DO NOT MODIFY. This file was compiled Fri, 12 Aug 2011 12:01:51 GMT from
 * /Users/Nico/Development/Rails/sc_interface/app/coffeescripts/views/material.coffee
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
  window.MaterialView = Backbone.View.extend({
    tagName: "li",
    initialize: function() {
      console.log(this.model);
      return this.model.bind('change', this.render, this);
    },
    render: function() {
      $(this.el).html(this.model.get('name'));
      this.setContent();
      return this;
    },
    setContent: function() {
      var name;
      name = this.model.get('name');
      return this.$('#materials_list').text(name);
    }
  });
  window.MaterialsListView = Backbone.View.extend({
    initialize: function() {
      _.bindAll(this, 'addOne', 'addAll');
      this.collection.bind('add', this.addOne).bind('refresh', this.addAll);
      return this.list = this.el.find('#materials_list');
    },
    addOne: function(material, collection) {
      var children, index, node;
      index = collection.indexOf(material);
      node = new MaterialView({
        model: material
      }).render().el;
      children = this.list.children();
      if (index === children.length) {
        return this.list.append(node);
      } else {
        return children.eq(index).before(node);
      }
    },
    addAll: function() {
      this.list.children().remove();
      return this.collection.each(__bind(function(item) {
        return this.addOne(item, this.collection);
      }, this));
    }
  });
}).call(this);

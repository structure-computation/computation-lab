/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 20:49:21 GMT from
 * /Users/StephieChou/rails_project/sc_interface/app/coffeescripts/calculs/views/links/EditLinkView.coffee
 */

(function() {
  window.EditLinkView = Backbone.View.extend({
    el: "#edit_link",
    initialize: function(params) {
      return this.parentElement = params.parentElement;
    },
    events: {
      'keyup': 'updateModelAttributes'
    },
    updateModel: function(model) {
      this.model = model;
      return this.render();
    },
    updateModelAttributes: function() {
      var h, input, key, value, _i, _len, _ref;
      _ref = $(this.el).find('input, textarea');
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        input = _ref[_i];
        key = $(input).attr('id').split('link_')[1];
        value = $(input).val();
        h = new Object();
        h[key] = value;
        this.model.set(h);
      }
      return this.parentElement.render();
    },
    render: function() {
      var input, _i, _len, _ref, _results;
      _ref = $(this.el).find('input, textarea');
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        input = _ref[_i];
        _results.push($(input).val(this.model.get($(input).attr('id').split("link_")[1])));
      }
      return _results;
    }
  });
}).call(this);

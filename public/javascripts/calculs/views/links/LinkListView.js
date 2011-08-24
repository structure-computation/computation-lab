/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 20:49:21 GMT from
 * /Users/StephieChou/rails_project/sc_interface/app/coffeescripts/calculs/views/links/LinkListView.coffee
 */

(function() {
  window.LinkListView = Backbone.View.extend({
    el: '#links_table',
    initialize: function(options) {
      var link, _i, _len, _ref;
      this.linkViews = [];
      this.localLinks = new LocalLinkListView;
      this.bind("linkAdded", this.addSelectedLink, this);
      _ref = this.collection;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        link = _ref[_i];
        this.linkViews.push(new LinkView({
          model: link,
          parentElement: this
        }));
      }
      return this.render();
    },
    addSelectedLink: function(selectedLink) {
      return this.localLinks.addLink(selectedLink);
    },
    render: function() {
      var linkView, _i, _len, _ref;
      _ref = this.linkViews;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        linkView = _ref[_i];
        linkView.render();
      }
      return this;
    }
  });
}).call(this);

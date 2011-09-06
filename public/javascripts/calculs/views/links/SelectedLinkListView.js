/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 20:49:22 GMT from
 * /Users/StephieChou/rails_project/sc_interface/app/coffeescripts/calculs/views/links/SelectedLinkListView.coffee
 */

(function() {
  window.LocalLinkListView = Backbone.View.extend({
    el: '#selected_links_table',
    initialize: function(options) {
      this.selectedLinkViews = [];
      this.bind("linkRemoved", this.removeLink, this);
      this.bind("editLink", this.editLink, this);
      return this.editLinkView = new EditLinkView({
        parentElement: this
      });
    },
    removeLink: function(linkToRemove) {
      var i, linkView, _len, _ref, _results;
      _ref = this.selectedLinkViews;
      _results = [];
      for (i = 0, _len = _ref.length; i < _len; i++) {
        linkView = _ref[i];
        if (linkView.model === linkToRemove) {
          this.selectedLinkViews.splice(i, 1);
          linkView.remove();
          this.render();
          break;
        }
      }
      return _results;
    },
    editLink: function(link) {
      return this.editLinkView.updateModel(link);
    },
    addLink: function(selectedLink) {
      var linkView, newLink, _i, _len, _ref;
      newLink = selectedLink.clone();
      _ref = this.selectedLinkViews;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        linkView = _ref[_i];
        if (linkView.model.get('name') === newLink.get('name')) {
          newLink.set({
            name: newLink.get('name') + " - copy"
          });
          break;
        }
      }
      this.selectedLinkViews.push(new SelectedLinkView({
        model: newLink,
        parentElement: this
      }));
      return this.render();
    },
    render: function() {
      var linkView, _i, _len, _ref;
      _ref = this.selectedLinkViews;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        linkView = _ref[_i];
        linkView.render();
      }
      return this;
    }
  });
}).call(this);

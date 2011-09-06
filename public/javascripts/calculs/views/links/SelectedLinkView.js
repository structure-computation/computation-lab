/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 20:49:21 GMT from
 * /Users/StephieChou/rails_project/sc_interface/app/coffeescripts/calculs/views/links/SelectedLinkView.coffee
 */

(function() {
  window.SelectedLinkView = Backbone.View.extend({
    tagName: "tr",
    initialize: function(params) {
      return this.parentElement = params.parentElement;
    },
    events: {
      'click .delete': 'deleteLink',
      'click .edit': 'editLink'
    },
    deleteLink: function() {
      return this.parentElement.trigger('linkRemoved', this.model);
    },
    editLink: function() {
      return this.parentElement.trigger('editLink', this.model);
    },
    render: function() {
      var template;
      template = "<td>" + (this.model.get('name')) + "</td>\n<td><button class='edit'>Editer</button></td>\n<td><button class='delete'>Supprimer</button></td>";
      $(this.el).html(template);
      $("#selected_links_table tbody").append(this.el);
      return this;
    }
  });
}).call(this);

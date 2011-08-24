/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 20:49:19 GMT from
 * /Users/StephieChou/rails_project/sc_interface/app/coffeescripts/calculs/views/links/LinkView.coffee
 */

(function() {
  window.LinkView = Backbone.View.extend({
    tagName: "tr",
    initialize: function(params) {
      return this.parentElement = params.parentElement;
    },
    events: {
      'click .add': 'addLink'
    },
    addLink: function() {
      return this.parentElement.trigger('linkAdded', this.model);
    },
    render: function() {
      var template;
      template = "<td>" + (this.model.get('name')) + "</td>\n<td><button class='add'>Ajouter</button></td>";
      $(this.el).html(template);
      $("#links_table tbody").append(this.el);
      return this;
    }
  });
}).call(this);

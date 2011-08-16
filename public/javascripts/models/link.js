/* DO NOT MODIFY. This file was compiled Fri, 12 Aug 2011 07:38:08 GMT from
 * /Users/Nico/Development/Rails/sc_interface/app/coffeescripts/models/link.coffee
 */

(function() {
  window.Link = Backbone.Model.extend();
  window.Links = Backbone.Collection.extend({
    model: Link,
    url: "/companies/" + this.company_id + "/links"
  });
}).call(this);

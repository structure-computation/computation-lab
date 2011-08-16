
window.Link = Backbone.Model.extend()

window.Links = Backbone.Collection.extend({
  model: Link,
  url : "/companies/#{this.company_id}/links"
})
window.Material = Backbone.Model.extend()

window.Materials = Backbone.Collection.extend({
  model: Material,
  url : "/companies/#{this.company_id}/materials"
})

window.Link = Backbone.Model.extend()

window.Links = Backbone.Collection.extend({
  model: Link,
  url : "/companies/#{this.company_id}/links"
})
  
window.materials  = new Materials({company_id: this.company_id})
window.materials.fetch()
window.links      = new Links({company_id: this.company_id})
window.links.fetch()

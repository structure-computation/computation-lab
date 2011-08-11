# window.Calcul = Backbone.Model.extend({
#   steps     : Steps,
#   materials : Materials,
#   links     : Links
#   
# })

window.Step = Backbone.Model.extend ({
  name          : "",
  initial_time  : 0,
  time_step     : 1,
  nb_time_steps : 1,
  final_time    : 1  
})

window.Steps = Backbone.Collection.extend({
  model: Step  
})

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

window.Calcul = Backbone.Model.extend ({
  initialize: ->
    company_id      = location.pathname.match(/\/companies\/([0-9]+)\/*/)[1]
    this.selectedMaterials = []
    this.selectedLinks     = []
    this.steps             = [] 
})

window.materials  = new Materials({company_id: this.company_id})
window.materials.fetch()
window.links      = new Links({company_id: this.company_id})
window.links.fetch()


StepView = Backbone.View.extend({
  initialize: ->
    this.render()
  ,
  el: "body",
  events: {
    "click" : "updateStep"
  },
  render : ->
    return this
  ,  
  updateStep : ->
    alert 'test'
})
window.stepView = new StepView()










MaterialView = Backbone.View.extend({
  initialize: ->
    this.father = "#materials_list"
    this.render()
  el        : "#materials_list_view17",
  events: {
    "click" : "youhou"
  },
  youhou: ->
    alert this.cid
  ,
  render:  ->
    $(this.father).append("<li id='#{this.father.slice(1)}_#{this.cid}'>" + this.model.get('name') + "</li>")
    return this
})

window.views = []
window.materials.fetch({
  success : ->
    for material in window.materials.models
      window.views.push(new MaterialView({
        model : material,
        id    : "main_menu" + this.id
      }))

})










/* DO NOT MODIFY. This file was compiled Tue, 09 Aug 2011 15:01:26 GMT from
 * /Users/Nima/Sites/Stage/StructureComputation/sc_interface/app/coffeescripts/calculs/calcul_model.coffee
 */

(function() {
  window.Calcul = Backbone.Model.extend({
    steps: Steps,
    materials: Materials,
    links: Links
  });
  window.Steps = Backbone.Collection.extend({
    model: Step
  });
  window.Step = Backbone.Model.extend({
    name: "",
    initial_time: 0,
    time_step: 1,
    nb_time_steps: 1,
    final_time: 1
  });
  window.Materials = Backbone.Collection.extend({
    model: Material
  });
  window.Material = Backbone.Model.extend({
    url: "/companies/" + this.company_id + "/materials",
    company_id: 1
  });
}).call(this);

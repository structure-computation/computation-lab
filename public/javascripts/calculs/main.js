<<<<<<< Updated upstream
/* DO NOT MODIFY. This file was compiled Fri, 12 Aug 2011 12:14:22 GMT from
 * /Users/Nima/Sites/Stage/StructureComputation/sc_interface/app/coffeescripts/calculs/main.coffee
 */

(function() {
  $(function() {
    var Steps;
    Steps = new StepCollection;
    window.StepsView = new StepListView({
      collection: Steps
    });
    return window.Calcul = Backbone.Model.extend({
      initialize: function() {
        var company_id;
        company_id = location.pathname.match(/\/companies\/([0-9]+)\/*/)[1];
        this.selectedMaterials = [];
        this.selectedLinks = [];
        return this.steps = [];
      }
    });
=======
/* DO NOT MODIFY. This file was compiled Fri, 12 Aug 2011 12:17:40 GMT from
 * /Users/Nico/Development/Rails/sc_interface/app/coffeescripts/calculs/main.coffee
 */

(function() {
  var steps;
  steps = new Steps(new Step({
    name: "First step",
    initial_time: 0,
    time_step: 1,
    nb_time_steps: 1,
    final_time: 1
  }));
  $("#add_step").click(function() {
    return steps.add([
      {
        name: "First step",
        initial_time: 0,
        time_step: 1,
        nb_time_steps: 1,
        final_time: 1
      }
    ]);
  });
  window.Calcul = Backbone.Model.extend({
    initialize: function() {
      var company_id;
      company_id = location.pathname.match(/\/companies\/([0-9]+)\/*/)[1];
      this.selectedMaterials = [];
      this.selectedLinks = [];
      return this.steps = [];
    }
>>>>>>> Stashed changes
  });
}).call(this);

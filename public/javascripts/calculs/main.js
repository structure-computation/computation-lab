/* DO NOT MODIFY. This file was compiled Thu, 11 Aug 2011 12:31:27 GMT from
 * /Users/Nima/Sites/Stage/StructureComputation/sc_interface/app/coffeescripts/calculs/main.coffee
 */

(function() {
  $((function() {
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
    return window.Calcul = Backbone.Model.extend({
      initialize: function() {
        var company_id;
        company_id = location.pathname.match(/\/companies\/([0-9]+)\/*/)[1];
        this.selectedMaterials = [];
        this.selectedLinks = [];
        return this.steps = [];
      }
    });
  }));
}).call(this);

/* DO NOT MODIFY. This file was compiled Fri, 12 Aug 2011 08:54:23 GMT from
 * /Users/Nima/Sites/Stage/StructureComputation/sc_interface/app/coffeescripts/calculs/main.coffee
 */

(function() {
  $(function() {
    var Steps, StepsView;
    Steps = new StepCollection;
    StepsView = new StepListView({
      collection: Steps
    });
    $("#add_step").click(function() {
      return StepsView.addStep();
    });
    $("#steps_table").keyup(function(event) {
      var _ref;
      if ((48 <= (_ref = event.keyCode) && _ref <= 57)) {
        return StepsView.trigger('step_changed');
      }
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
  });
}).call(this);

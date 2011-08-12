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
  });
}).call(this);

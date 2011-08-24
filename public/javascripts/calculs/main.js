/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 20:49:19 GMT from
 * /Users/StephieChou/rails_project/sc_interface/app/coffeescripts/calculs/main.coffee
 */

(function() {
  $(function() {
    var Steps, pieceCollection;
    Steps = new StepCollection;
    window.StepsView = new StepListView({
      collection: Steps
    });
    window.Calcul = Backbone.Model.extend({
      initialize: function() {
        var company_id;
        company_id = location.pathname.match(/\/companies\/([0-9]+)\/*/)[1];
        this.selectedMaterials = [];
        this.selectedLinks = [];
        return this.steps = [];
      }
    });
    pieceCollection = new PieceCollection([
      {
        "group": -1,
        "name": "piece 0",
        "origine": "from_bulkdata",
        "assigned": -1,
        "id": 0,
        "identificateur": 0
      }, {
        "group": -1,
        "name": "piece 1",
        "origine": "from_bulkdata",
        "assigned": -1,
        "id": 1,
        "identificateur": 1
      }, {
        "group": -1,
        "name": "piece 2",
        "origine": "from_bulkdata",
        "assigned": -1,
        "id": 2,
        "identificateur": 2
      }, {
        "group": -1,
        "name": "piece 3",
        "origine": "from_bulkdata",
        "assigned": -1,
        "id": 3,
        "identificateur": 3
      }
    ]);
    return window.PieceList = new PieceListView({
      collection: pieceCollection
    });
  });
}).call(this);

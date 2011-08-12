/* DO NOT MODIFY. This file was compiled Fri, 12 Aug 2011 12:06:44 GMT from
 * /Users/Nima/Sites/Stage/StructureComputation/sc_interface/app/coffeescripts/models/step.coffee
 */

(function() {
  window.Step = Backbone.Model.extend({
    defaults: {
      name: "step_",
      initial_time: 0,
      time_step: 1,
      nb_time_steps: 1,
      final_time: 1
    },
    initialize: function() {
      this.updateFinalTime();
      this.bind('add', this.updateFinalTime);
      return this.bind('change', this.updateFinalTime);
    },
    updateFinalTime: function() {
      var newFinalTime;
      newFinalTime = this.get('initial_time') + (this.get('nb_time_steps') * this.get('time_step'));
      return this.set({
        final_time: newFinalTime
      });
    }
  });
  window.StepCollection = Backbone.Collection.extend({
    model: Step,
    initialize: function() {
      return this.bind('add', function(step) {
        return this.updateModels();
      });
    },
    updateModels: function() {
      var i, step, _len, _ref, _results;
      _ref = this.models;
      _results = [];
      for (i = 0, _len = _ref.length; i < _len; i++) {
        step = _ref[i];
        step.set({
          name: "step_" + i
        });
        _results.push(i > 0 ? step.set({
          initial_time: this.models[i - 1].get('final_time')
        }) : void 0);
      }
      return _results;
    }
  });
}).call(this);

/* DO NOT MODIFY. This file was compiled Fri, 12 Aug 2011 08:39:38 GMT from
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
        if (!(this.last_step != null)) {
          this.last_step = step;
          return step.set({
            name: step.get('name') + (this.models.length - 1)
          });
        } else {
          this.nb_step_model += 1;
          step.set({
            name: step.get('name') + (this.models.length - 1)
          });
          step.set({
            initial_time: this.last_step.get('final_time')
          });
          return this.last_step = step;
        }
      });
    },
    updateModels: function() {
      var i, step, _len, _ref, _results;
      _ref = this.models;
      _results = [];
      for (i = 0, _len = _ref.length; i < _len; i++) {
        step = _ref[i];
        _results.push(i > 0 ? step.set({
          initial_time: this.models[i - 1].get('final_time')
        }) : void 0);
      }
      return _results;
    }
  });
}).call(this);

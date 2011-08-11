/* DO NOT MODIFY. This file was compiled Thu, 11 Aug 2011 12:34:02 GMT from
 * /Users/Nima/Sites/Stage/StructureComputation/sc_interface/app/coffeescripts/models/step.coffee
 */

(function() {
  window.Step = Backbone.Model.extend({
    name: "",
    initial_time: 0,
    time_step: 1,
    nb_time_steps: 1,
    final_time: 1,
    updateFinalTime: function() {
      var newFinalTime;
      newFinalTime = this.get('initial_time') + (this.get('nb_time_steps') * this.get('time_step'));
      return this.set({
        final_time: newFinalTime
      });
    }
  });
  window.Steps = Backbone.Collection.extend({
    initialize: function(step) {
      this.stepViews = [];
      this.stepViews.push(new StepView({
        model: step
      }));
      return this.bind('add', function(step) {
        return this.stepViews.push(new StepView({
          model: step
        }));
      });
    },
    model: Step
  });
}).call(this);

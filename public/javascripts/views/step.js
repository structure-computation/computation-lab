/* DO NOT MODIFY. This file was compiled Fri, 12 Aug 2011 08:54:23 GMT from
 * /Users/Nima/Sites/Stage/StructureComputation/sc_interface/app/coffeescripts/views/step.coffee
 */

(function() {
  window.StepListView = Backbone.View.extend({
    initialize: function() {
      this.lastStep = new Step({
        initial_time: 0,
        time_step: 1,
        nb_time_steps: 1,
        final_time: 1
      });
      this.collection.add(this.lastStep);
      this.stepViews = [];
      this.stepViews.push(new StepView({
        model: this.lastStep
      }));
      return this.bind("step_changed", function() {
        var stepView, _i, _len, _ref, _results;
        this.collection.updateModels();
        _ref = this.stepViews;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          stepView = _ref[_i];
          _results.push(stepView.update());
        }
        return _results;
      });
    },
    addStep: function() {
      var step;
      step = new Step({
        initial_time: this.lastStep.get('final_time'),
        time_step: 1,
        nb_time_steps: 1
      });
      this.lastStep = step;
      this.collection.add(step);
      return this.stepViews.push(new StepView({
        model: step
      }));
    },
    tagName: "table"
  });
  window.StepView = Backbone.View.extend({
    initialize: function(step) {
      return this.render();
    },
    tagName: "tr",
    render: function() {
      var htmlString;
      htmlString = "<td class=\"name\">\n  <input type='text' value='" + (this.model.get("name")) + "' disabled> \n</td> \n<td class=\"initial_time\">\n  <input type='text' value='" + (this.model.get("initial_time")) + "' disabled> \n</td> \n<td class=\"time_step\"> \n  <input type='text' value='" + (this.model.get("time_step")) + "'> \n</td> \n<td class=\"nb_time_steps\">\n  <input type='text' value='" + (this.model.get("nb_time_steps")) + "'> \n</td> \n<td class=\"final_time\">\n  <input type='text' value='" + (this.model.get("final_time")) + "' disabled> \n</td> ";
      $(this.el).html(htmlString);
      $('#steps_table tbody').append(this.el);
      return this;
    },
    updateName: function() {
      return this.model.set({
        name: $(this.el).find('.name input').val()
      });
    },
    updateInitialTime: function() {
      return this.model.set({
        initial_time: parseInt($(this.el).find('.initial_time input').val())
      });
    },
    updateTimeStep: function() {
      return this.model.set({
        time_step: parseInt($(this.el).find('.time_step input').val())
      });
    },
    updateNbTimeStep: function() {
      return this.model.set({
        nb_time_steps: parseInt($(this.el).find('.nb_time_steps input').val())
      });
    },
    update: function() {
      this.updateTimeStep();
      this.updateNbTimeStep();
      $(this.el).find('.name input').val(this.model.get('name'));
      $(this.el).find('.initial_time input').val(this.model.get('initial_time'));
      $(this.el).find('.time_step input').val(this.model.get('time_step'));
      $(this.el).find('.nb_time_steps input').val(this.model.get('nb_time_steps'));
      return $(this.el).find('.final_time input').val(this.model.get('final_time'));
    }
  });
}).call(this);

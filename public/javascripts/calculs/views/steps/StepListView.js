/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 20:49:20 GMT from
 * /Users/StephieChou/rails_project/sc_interface/app/coffeescripts/calculs/views/steps/StepListView.coffee
 */

(function() {
  window.StepListView = Backbone.View.extend({
    el: "#steps",
    initialize: function() {
      var step;
      step = new Step({
        initial_time: 0,
        time_step: 1,
        nb_time_steps: 1,
        final_time: 1
      });
      this.collection.add(step);
      this.stepViews = [];
      this.stepViews.push(new StepView({
        model: step,
        parentView: this
      }));
      this.stepViews[0].removeDeleteButton();
      this.bind('step_deleted', this.deleteStep, this);
      this.disableAddButton();
      return this.render();
    },
    addStep: function() {
      var step;
      step = new Step({
        initial_time: this.collection.models[this.collection.models.length - 1].get('final_time'),
        time_step: 1,
        nb_time_steps: 1
      });
      this.collection.add(step);
      return this.stepViews.push(new StepView({
        model: step,
        parentView: this
      }));
    },
    render: function() {
      var stepView, _i, _len, _ref;
      if ($(this.el).find('select#step_type').val() === "statique") {
        this.disableAddButton();
      }
      _ref = this.stepViews;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        stepView = _ref[_i];
        stepView.render();
      }
      if (this.stepViews.length === 1) {
        return this.stepViews[0].removeDeleteButton();
      }
    },
    events: {
      'keyup': 'updateFieldsKeyUp',
      'click button#add_step': 'addStep',
      'change select#step_type': 'selectChanged'
    },
    updateFieldsKeyUp: function(event) {
      return this.updateFields();
    },
    deleteStep: function(step_deleted) {
      var i, step, _len, _ref;
      _ref = this.stepViews;
      for (i = 0, _len = _ref.length; i < _len; i++) {
        step = _ref[i];
        if (step === step_deleted) {
          this.stepViews.splice(i, 1);
          break;
        }
      }
      return this.updateFields();
    },
    updateFields: function() {
      var stepView, _i, _len, _ref, _results;
      _ref = this.stepViews;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        stepView = _ref[_i];
        stepView.update();
        _results.push(this.collection.updateModels());
      }
      return _results;
    },
    selectChanged: function(event) {
      var i, _ref;
      if ($(event.srcElement).val() === "statique") {
        for (i = 0, _ref = this.stepViews.length - 1; 0 <= _ref ? i <= _ref : i >= _ref; 0 <= _ref ? i++ : i--) {
          if (i > 0) {
            this.stepViews[1]["delete"]();
          }
        }
        return $(this.el).find("button#add_step").enable(false);
      } else {
        return $("#add_step").enable();
      }
    },
    disableAddButton: function() {
      return $(this.el).find("button#add_step").enable(false);
    }
  });
}).call(this);

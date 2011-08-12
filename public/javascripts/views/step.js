/* DO NOT MODIFY. This file was compiled Fri, 12 Aug 2011 13:06:50 GMT from
 * /Users/Nima/Sites/Stage/StructureComputation/sc_interface/app/coffeescripts/views/step.coffee
 */

(function() {
  window.StepListView = Backbone.View.extend({
    tagName: 'div',
    id: 'steps',
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
      this.bind('step_deleted', this.deleteStep);
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
      var htmlString, stepView, _i, _len, _ref;
      htmlString = "<button id=\"add_step\">Ajouter un Step</button>\n<select id=\"step_type\">\n  <option value=\"statique\">Statique</option>\n  <option value=\"quasistatique\">Quasistatique</option>\n  <option value=\"dynamique\">Dynamique</option>\n</select>\n<table id=\"steps_table\" class=\"grey\">\n   <thead> \n      <tr class='no_sorter'> \n        <th>Nom</th> \n        <th>Temps initial</th> \n        <th>Pas de temps</th> \n        <th>Nombre de pas de temps</th> \n        <th>Temps final</th> \n        <th></th> \n      </tr> \n    </thead> \n    <tbody></tbody>\n</table>";
      $(this.el).html(htmlString);
      $('#content').append(this.el);
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
  window.StepView = Backbone.View.extend({
    initialize: function(options) {
      this.parentView = options.parentView;
      return this.render();
    },
    tagName: "tr",
    render: function() {
      var htmlString;
      htmlString = "<td class=\"name\">\n  <input type='text' value='" + (this.model.get("name")) + "' disabled> \n</td> \n<td class=\"initial_time\">\n  <input type='text' value='" + (this.model.get("initial_time")) + "' disabled> \n</td> \n<td class=\"time_step\"> \n  <input type='text' value='" + (this.model.get("time_step")) + "'> \n</td> \n<td class=\"nb_time_steps\">\n  <input type='text' value='" + (this.model.get("nb_time_steps")) + "'> \n</td> \n<td class=\"final_time\">\n  <input type='text' value='" + (this.model.get("final_time")) + "' disabled> \n</td> \n<td class=\"final_time\">\n  <button class='delete'>X</button>\n</td> ";
      $(this.el).html(htmlString);
      $(this.parentView.el).find('tbody').append(this.el);
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
    },
    removeDeleteButton: function() {
      return $(this.el).find("button").remove();
    },
    events: {
      'click button.delete': 'delete'
    },
    "delete": function() {
      this.model.destroy();
      this.update();
      this.parentView.trigger('step_deleted', this);
      return this.remove();
    }
  });
}).call(this);

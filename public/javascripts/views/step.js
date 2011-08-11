/* DO NOT MODIFY. This file was compiled Thu, 11 Aug 2011 12:33:19 GMT from
 * /Users/Nima/Sites/Stage/StructureComputation/sc_interface/app/coffeescripts/views/step.coffee
 */

(function() {
  window.StepView = Backbone.View.extend({
    initialize: function() {
      var updateModelViewFinalTime;
      this.render();
      updateModelViewFinalTime = _.bind(function() {
        this.model.updateFinalTime();
        return this.updateFinalTime();
      }, this);
      this.model.bind('change:initial_time', updateModelViewFinalTime);
      this.model.bind('change:time_step', updateModelViewFinalTime);
      return this.model.bind('change:nb_time_steps', updateModelViewFinalTime);
    },
    tagName: "tr",
    events: {
      "change .name input": "updateName",
      "change .initial_time input": "updateInitialTime",
      "change .time_step input": "updateTimeStep",
      "change .nb_time_steps input": "updateNbTimeStep"
    },
    render: function() {
      var htmlString;
      htmlString = "<td class=\"name\">\n  <input type='text' value='" + (this.model.get("name")) + "'> \n</td> \n<td class=\"initial_time\">\n  <input type='text' value='" + (this.model.get("initial_time")) + "'> \n</td> \n<td class=\"time_step\"> \n  <input type='text' value='" + (this.model.get("time_step")) + "'> \n</td> \n<td class=\"nb_time_steps\">\n  <input type='text' value='" + (this.model.get("nb_time_steps")) + "'> \n</td> \n<td class=\"final_time\">\n  <input type='text' value='" + (this.model.get("final_time")) + "' disabled> \n</td> ";
      $(this.el).html(htmlString);
      $('#step_table tbody').append(this.el);
      return this;
    },
    updateName: function() {
      this.model.set({
        name: $(this.el).find('.name input').val()
      });
      return this.updateFinalTime();
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
    updateFinalTime: function() {
      return $(this.el).find('.final_time input').val(this.model.get('final_time'));
    }
  });
}).call(this);

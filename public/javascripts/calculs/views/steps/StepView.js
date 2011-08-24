/* DO NOT MODIFY. This file was compiled Wed, 17 Aug 2011 20:49:19 GMT from
 * /Users/StephieChou/rails_project/sc_interface/app/coffeescripts/calculs/views/steps/StepView.coffee
 */

(function() {
  window.StepView = Backbone.View.extend({
    initialize: function(options) {
      this.parentView = options.parentView;
      return this.render();
    },
    tagName: "tr",
    render: function() {
      var template;
      template = "<td class=\"name\">\n  <input type='text' value='" + (this.model.get("name")) + "' disabled> \n</td> \n<td class=\"initial_time\">\n  <input type='text' value='" + (this.model.get("initial_time")) + "' disabled> \n</td> \n<td class=\"time_step\"> \n  <input type='text' value='" + (this.model.get("time_step")) + "'> \n</td> \n<td class=\"nb_time_steps\">\n  <input type='text' value='" + (this.model.get("nb_time_steps")) + "'> \n</td> \n<td class=\"final_time\">\n  <input type='text' value='" + (this.model.get("final_time")) + "' disabled> \n</td> \n<td class=\"final_time\">\n  <button class='delete'>X</button>\n</td> ";
      $(this.el).html(template);
      $("#steps").find('tbody').append(this.el);
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

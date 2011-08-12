/* DO NOT MODIFY. This file was compiled Thu, 11 Aug 2011 11:55:02 GMT from
 * /Users/Nima/Sites/Stage/StructureComputation/sc_interface/app/coffeescripts/calculs/calcul_models.coffee
 */

(function() {
  $((function() {
    var MaterialView, StepView, step;
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
      model: Step
    });
    window.Material = Backbone.Model.extend();
    window.Materials = Backbone.Collection.extend({
      model: Material,
      url: "/companies/" + this.company_id + "/materials"
    });
    window.Link = Backbone.Model.extend();
    window.Links = Backbone.Collection.extend({
      model: Link,
      url: "/companies/" + this.company_id + "/links"
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
    window.materials = new Materials({
      company_id: this.company_id
    });
    window.materials.fetch();
    window.links = new Links({
      company_id: this.company_id
    });
    window.links.fetch();
    StepView = Backbone.View.extend({
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
        $('#steps_table tbody').append(this.el);
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
    step = new Step({
      name: "First step",
      initial_time: 0,
      time_step: 1,
      nb_time_steps: 1,
      final_time: 1
    });
    window.stepView = new StepView({
      model: step
    });
    MaterialView = Backbone.View.extend({
      initialize: function() {
        $('#materials_list').append(this.el);
        return this.render();
      },
      tagName: "li",
      events: {
        "click": "youhou"
      },
      youhou: function() {
        return alert(this.cid);
      },
      render: function() {
        $(this.el).text("" + (this.model.get('name')));
        return this;
      }
    });
    window.views = [];
    return window.materials.fetch({
      success: function() {
        var material, _i, _len, _ref, _results;
        _ref = window.materials.models;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          material = _ref[_i];
          _results.push(window.views.push(new MaterialView({
            model: material
          })));
        }
        return _results;
      }
    });
  }));
}).call(this);

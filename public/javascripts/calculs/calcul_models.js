/* DO NOT MODIFY. This file was compiled Thu, 11 Aug 2011 08:24:26 GMT from
 * /Users/Nima/Sites/Stage/StructureComputation/sc_interface/app/coffeescripts/calculs/calcul_models.coffee
 */

(function() {
  var MaterialView, StepView;
  window.Step = Backbone.Model.extend({
    name: "",
    initial_time: 0,
    time_step: 1,
    nb_time_steps: 1,
    final_time: 1
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
      return this.render();
    },
    el: "body",
    events: {
      "click": "updateStep"
    },
    render: function() {
      return this;
    },
    updateStep: function() {
      return alert('test');
    }
  });
  window.stepView = new StepView();
  MaterialView = Backbone.View.extend({
    initialize: function() {
      this.father = "#materials_list";
      return this.render();
    },
    el: "#materials_list_view17",
    events: {
      "click": "youhou"
    },
    youhou: function() {
      return alert(this.cid);
    },
    render: function() {
      $(this.father).append(("<li id='" + (this.father.slice(1)) + "_" + this.cid + "'>") + this.model.get('name') + "</li>");
      return this;
    }
  });
  window.views = [];
  window.materials.fetch({
    success: function() {
      var material, _i, _len, _ref, _results;
      _ref = window.materials.models;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        material = _ref[_i];
        _results.push(window.views.push(new MaterialView({
          model: material,
          id: "main_menu" + this.id
        })));
      }
      return _results;
    }
  });
}).call(this);

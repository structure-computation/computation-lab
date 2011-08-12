$ ->
  Steps   = new StepCollection
  window.StepsView = new StepListView collection: Steps
  window.Calcul = Backbone.Model.extend
    initialize: ->
      company_id             = location.pathname.match(/\/companies\/([0-9]+)\/*/)[1]
      this.selectedMaterials = []
      this.selectedLinks     = []
      this.steps             = [] 

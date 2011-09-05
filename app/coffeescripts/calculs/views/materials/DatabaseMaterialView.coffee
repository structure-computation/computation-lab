# Database Material View
# View of all material which are in the database
# 'el' is passed at creation
SCViews.DatabaseMaterialView = Backbone.View.extend
  initialize: (params) ->
    @materialListView  = params.materialListView

  events:
    "click button.add" : "addToCalculus"
  
  addToCalculus: ->
    newModel         = @model.clone()
    newModel.set    'id_from_database' : @model.get 'id'
    newModel.unset  'id'
    @materialListView.add newModel

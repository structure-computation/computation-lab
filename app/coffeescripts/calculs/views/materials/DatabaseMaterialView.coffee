# Database Material View
# View of all material which are in the database
# 'el' is passed at creation
SCViews.DatabaseMaterialView = Backbone.View.extend
  initialize: (params) ->
    @materialListView  = params.materialListView

  events:
    "click button.add" : "addToCalculus"
    "click"            : "showDatabaseMaterialDetails"

  # Add the selected material to the list of calcul's materials
  # Clone the model before and unset its ID to not prevent for confusion and have two clear seperate references
  addToCalculus: ->
    newModel         = @model.clone()
    newModel.set    'id_from_database' : @model.get 'id'
    newModel.unset  'id'
    @materialListView.add newModel
  
  showDatabaseMaterialDetails: (event) ->
    if event.srcElement != $(@el).find('button.add')[0]
      @materialListView.showDetails @model, true
# Database Material View
# View of all material which are in the database
# 'el' is passed at creation
SCVisu.DatabaseMaterialView = Backbone.View.extend
  initialize: (params) ->
    @materialListView  = params.materialListView

  events:
    "click button.add"     : "addToCalculus"
  
  addToCalculus: ->
    @materialListView.add @model

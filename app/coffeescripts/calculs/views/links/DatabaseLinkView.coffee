# Database Link View
# View of all links which are in the database
# 'el' is passed at creation
SCViews.DatabaseLinkView = Backbone.View.extend
  initialize: (params) ->
    @linkListView  = params.linkListView

  events:
    "click button.add" : "addToCalculus"
  
  addToCalculus: ->
    @linkListView.add @model

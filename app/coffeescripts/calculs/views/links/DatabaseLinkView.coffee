# Database Link View
# View of all links which are in the database
# 'el' is passed at creation
SCViews.DatabaseLinkView = Backbone.View.extend
  initialize: (params) ->
    @linkListView  = params.linkListView

  events:
    "click button.add" : "addToCalculus"
    "click"            : "showDatabaseLinksDetails"
  
  # Add the selected link to the list of calcul's links
  # Clone the model before and unset its ID to not prevent for confusion and have two clear seperate references
  addToCalculus: ->
    newModel         = @model.clone()
    newModel.set    'id_from_database' : @model.get 'id'
    newModel.unset  'id'
    @linkListView.add newModel

  # Show details of the selected model but disable all inputs
  showDatabaseLinksDetails: (event) ->
    if event.srcElement != $(@el).find('button.add')[0]
      @linkListView.showDetails @model, true
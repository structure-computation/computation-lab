## BoundaryConditionView
SCViews.BoundaryConditionView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@parentElement.el).append(@el)
    
  tagName   : "li"
  className : "boundary_condition_view"

  events: 
    "click"           : "select"
    "click .remove"   : "removeCondition"
    "click .assign"   : "assignCondition"
    "click .unassign" : "unassignCondition"
  
  # Assign the current condition to the selected edge
  assignCondition: ->
    SCVisu.edgeListView.selectedEdgeView.model.set 'boundary_condition_id' : @model.get('id_in_calcul')
    SCVisu.edgeListView.selectedEdgeView.render()
    SCVisu.edgeListView.selectedEdgeView.highlight()
    SCVisu.edgeListView.updateCalcul()
    @showUnassignButton()

  # Unassign the model from the selected edge
  unassignCondition: ->
    SCVisu.edgeListView.selectedEdgeView.model.unset 'boundary_condition_id'
    SCVisu.edgeListView.selectedEdgeView.render()
    SCVisu.edgeListView.selectedEdgeView.highlight()
    SCVisu.edgeListView.updateCalcul()
    @parentElement.showAssignButtons()

  # Remove condition (model and view)
  removeCondition: ->
    SCVisu.edgeListView.conditionHasBeenRemoved(@model)
    @parentElement.collection.remove @model
    @parentElement.updateCalcul()
    @remove()

  # Show an assign button on the condition element
  showAssignButton: ->
    @render()
    $(@el).find('button.remove').after('<button class="assign">Assigner</button>')

  # Show an unassign button on the condition element
  showUnassignButton: ->
    @parentElement.selectedBoundaryCondition = this
    @parentElement.render()
    $(@el).find('button.remove').after('<button class="unassign">Désassigner</button>')

  # Set the current condition to be the selectedEdge and show the edit view
  select: (event) ->
    if event.srcElement.tagName != "BUTTON"
      @parentElement.setNewSelectedModel(this)

  render: ->
    $(@el).html(@model.get('id_in_calcul') + " - " + @model.get('name') + "<button class='remove''>X</button>").removeClass('selected')
    this
## BoundaryConditionView
SCViews.BoundaryConditionView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@parentElement.el).append(@el)
    
  tagName   : "li"
  className : "boundary_condition_view"

  events: 
    "click"                 : "selectionChanged"
    "click button.edit"     : "editCondition"
    "click button.remove"   : "removeCondition"
    "click button.assign"   : "assignCondition"
    "click button.unassign" : "unassignCondition"
  
  # Add class to the element to highlight it
  select: ->
    $(@el).addClass("selected")
  # Remove class from the element
  deselect: ->
    $(@el).removeClass("selected")

  # Inform the ListView that a boundary condition has been clicked
  selectionChanged: (event) ->
    if event.srcElement.tagName != "BUTTON"
      @parentElement.trigger("selection_changed:boundary_conditions", this)

  # Assign the current condition to the selected edge
  assignCondition: ->
    SCVisu.edgeListView.selectedEdgeView.model.set 'boundary_condition_id' : @model.get('id_in_calcul')
    SCVisu.edgeListView.selectedEdgeView.render()
    SCVisu.edgeListView.updateCalcul()
    @showUnassignButton()

  # Unassign the model from the selected edge
  unassignCondition: ->
    SCVisu.edgeListView.selectedEdgeView.model.unset 'boundary_condition_id'
    SCVisu.edgeListView.selectedEdgeView.render()
    SCVisu.edgeListView.updateCalcul()
    @parentElement.showAssignButtons()

  # Remove condition (model and view)
  removeCondition: ->
    SCVisu.edgeListView.trigger("action:removed_boundary_condition", this)
    @parentElement.collection.remove @model
    @parentElement.updateCalcul()
    @remove()

  # Show the edit part
  editCondition: ->
    @parentElement.showDetails(@model)

  # Show an assign button on the condition element
  showAssignButton: ->
    @renderWithButton 'assign', 'Assigner'
      
  # Show an unassign button on the condition element
  showUnassignButton: ->
    @parentElement.render() # To remove button from other link views
    @renderWithButton 'unassign', 'Désassigner'
    $(@el).addClass("selected")

    
  renderWithButton: (className, textButton) ->
    $(@el).html("#{@model.get('id_in_calcul')} - #{@model.get('name')}")
    $(@el).append("<button class='remove'>X</button>")
    $(@el).append("<button class='#{className}'>#{textButton}</button>")
    return this

  render: ->
    @renderWithButton 'edit', 'Editer'

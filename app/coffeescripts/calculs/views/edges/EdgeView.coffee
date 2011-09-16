## EdgeView
SCViews.EdgeView = Backbone.View.extend
  tagName   : 'tr'
  className : 'edge_view'

  initialize: (options) ->
    @parentElement = options.parentElement
    $(@parentElement.el).find('table tbody').append @el

  events:
    'click'                 : 'selectionChanged'
    "click button.edit"     : "editEdge"
    "click button.assign"   : "asssignCondition"
    "click button.unassign" : "unassignCondition"
    "click button.remove"   : "removeEdge"

  # Add class to the element to highlight it
  select: ->
    $(@el).addClass("selected")
  # Remove class from the element
  deselect: ->
    $(@el).removeClass("selected")

  # Inform the ListView that a piece has been clicked
  selectionChanged: (event) ->
    if event.srcElement.tagName != "BUTTON"
      @parentElement.trigger("selection_changed:edges", this)

  editEdge: ->
    @parentElement.editView.setModel @model
    # Trigger selection change only when the material selected change because it
    # makes lose the focus
    @parentElement.trigger("selection_changed:edges", this) if @parentElement.selectedEdgeView != this
    $('#visu_calcul').hide()

    
  removeEdge: ->
    if confirm "Êtes-vous sûr ?"
      SCVisu.boundaryConditionListView.trigger("action:removed_edge", this)
      @parentElement.collection.remove @model
      @parentElement.updateCalcul()
      @remove()

  # Assign the selected condition to the current model
  asssignCondition: ->
    @parentElement.asssignCondition(this)
    @showUnassignButton()

  # Unassign the condition from the current model    
  unassignCondition: ->
    @parentElement.unasssignCondition(this)
    @showAssignButton()
  
  # Show an assign button
  showAssignButton: ->
    $(@el).find('td.cl_id').html("<button class='assign'>Assigner</button>")

  # Show an unassign button  
  showUnassignButton: ->
    $(@el).find('td.cl_id').html("<button class='unassign'>Désassigner</button>")
      
  render: ->
    template = """
      <td>#{@model.getId()}</td>
      <td>#{@model.get('name')}</td>
    """
    $(@el).html(template).removeClass('selected')
    if @model.isAssigned()
      $(@el).append("<td class='cl_id'>#{@model.get('boundary_condition_id')}</td>")
    else
      $(@el).append('<td class="cl_id">-</td>')
    $(@el).append("<td>
          <button class='edit'>Editer</button>
          <button class='remove'>X</button>
        </td>")
    return this
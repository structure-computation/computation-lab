## EdgeView
SCViews.EdgeView = Backbone.View.extend
  tagName   : 'tr'
  className : 'edge_view'

  initialize: (options) ->
    @parentElement = options.parentElement
    $(@parentElement.el).find('table tbody').append @el

  events:
    "click"                 : "select"
    "click button.assign"   : "asssignCondition"
    "click button.unassign" : "unassignCondition"

  # Assign the selected condition to the current model
  asssignCondition: ->
    @parentElement.asssignCondition(this)
    @showUnassignButton()

  # Unassign the condition from the current model    
  unassignCondition: ->
    @parentElement.unasssignCondition(this)
    @showAssignButton()

  # Highlight correct boundary condition regarding the selected edge
  select: (event) ->
    if event.srcElement.tagName != "BUTTON"
      @parentElement.setNewSelectedModel(this)
  
  # Show an assign button
  showAssignButton: ->
    $(@el).find('td:last').html("<button class='assign'>Assigner</button>")

  # Show an unassign button  
  showUnassignButton: ->
    $(@el).find('td:last').html("<button class='unassign'>Désassigner</button>")
  
  # Highlight the current view
  highlight: ->
    $(@el).addClass('selected')
    
  render: ->
    template = """
      <td>#{@model.get('id')}</td>
      <td>#{@model.get('name')}</td>
    """
    $(@el).html(template).removeClass('selected')
    if @model.isAssigned()
      $(@el).append("<td class='is_assigned'>#{@model.get('boundary_condition_id')}</td>")
    else
      $(@el).append('<td>-</td>')

    return this
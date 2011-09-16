## EdgeView
SCViews.EdgeView = Backbone.View.extend
  tagName   : 'tr'
  className : 'edge_view'

  initialize: (options) ->
    @parentElement = options.parentElement
    $(@parentElement.el).find('table tbody').append @el

  events:
    'click'                 : 'selectionChanged'
    "click button.assign"   : "asssignCondition"
    "click button.unassign" : "unassignCondition"

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
    $(@el).find('td:last').html("<button class='assign'>Assigner</button>")

  # Show an unassign button  
  showUnassignButton: ->
    $(@el).find('td:last').html("<button class='unassign'>Désassigner</button>")
      
  render: ->
    template = """
      <td>#{@model.getId()}</td>
      <td>#{@model.get('name')}</td>
    """
    $(@el).html(template).removeClass('selected')
    if @model.isAssigned()
      $(@el).append("<td class='is_assigned'>#{@model.get('boundary_condition_id')}</td>")
    else
      $(@el).append('<td>-</td>')

    return this
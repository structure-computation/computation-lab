## Link View
SCViews.LinkView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@parentElement.el).append(@el)

  tagName   : "li"
  className : "link_view"
  events: 
    "click button.edit"     : "show_details"
    "click button.clone"    : "clone"
    "click button.assign"   : "assign"
    "click button.unassign" : "unassign"
    "click button.remove"   : "removeLink"
    "click"                 : "selectionChanged"

  # Add class to the element to highlight it
  select: ->
    $(@el).addClass("selected")
  # Remove class from the element
  deselect: ->
    $(@el).removeClass("selected")

  # Inform the ListView that a material has been clicked
  selectionChanged: (event) ->
    if event.srcElement.tagName != "BUTTON"
      @parentElement.trigger("selection_changed:links", this)
  
  
  # Removing model from collection passing silent prevent from destroying from database
  # Also removing the view
  removeLink: ->
    if confirm "Êtes-vous sûr ?"
      SCVisu.interfaceListView.trigger("action:removed_link", this)
      @parentElement.collection.remove @model
      SCVisu.current_calcul.trigger 'change'
      @remove()

  # Assign the link to the selected interface
  # Add an "Unassign" Button and remove all other "Assign" buttons (Because an interface can only have one link)
  # Highlight the current link and put others in gray
  assign: ->
    @parentElement.assignLinkToSelectedInterface @
    @showUnassignButton()

  # Unassign the link from the selected interface
  unassign: ->
    @parentElement.unassignLinkToSelectedInterface()
    @parentElement.showAssignButtons()
  
  show_details: ->
    @trigger 'show_details', @model

  clone: ->
    @parentElement.clone @model
  
  showUnassignButton: ->
    @parentElement.render() # To remove button from other link views
    @renderWithButton 'unassign', 'Désassigner'
    $(@el).addClass("selected")

  showAssignButton: ->
    @renderWithButton 'assign', 'Assigner'
    
  renderWithButton: (className, textButton) ->
    $(@el).html("#{@model.get('id_in_calcul')} - #{@model.get('name')}")
    $(@el).append("<button class='remove'>X</button>")
    $(@el).append("<button class='#{className}'>#{textButton}</button>")
    return this


  render: ->
    @renderWithButton 'edit', 'Editer'

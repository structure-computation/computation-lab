## Link View
SCViews.LinkView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@parentElement.el).append(@el)

  tagName   : "li"
  className : "link_view"
  events: 
    "click button.edit"     : "showDetails"
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
  assign: ->
    @parentElement.trigger "action:assign:link", this
    SCVisu.interfaceListView.trigger "action:assign:link", this    

  # Unassign the link from the selected interface
  unassign: ->
    @parentElement.trigger "action:unassign:link", this
    SCVisu.interfaceListView.trigger "action:unassign:link", this    
  
  showDetails: ->
    @parentElement.showDetails @model
    # Trigger selection change only when the material selected change because it
    # makes lose the focus
    @parentElement.trigger("selection_changed:links", this) if @parentElement.selectedLinkView != this

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

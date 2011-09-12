## Link View
SCViews.LinkView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
    @firstRendering = true

  tagName   : "li"
  className : "link_view"
  events: 
    "click button.edit"     : "show_details"
    "click button.clone"    : "clone"
    "click button.assign"   : "assign"
    "click button.unassign" : "unassign"
    "click button.remove"   : "removeLink"
    "click"                 : "select"
    
  # Removing model from collection passing silent prevent from destroying from database
  # Also removing the view
  removeLink: ->
    SCVisu.interfaceListView.linkHasBeenRemoved @model
    @parentElement.collection.remove @model
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

  # Tell the parent that a link have been selected.
  # The row will be highlighted and interfaces wich contains 
  # this link will also be highlighted.
  select: (event) ->
    if event.srcElement == @el
      @parentElement.render() # Clear all buttons from all link view
      @parentElement.selectLink @

  
  show_details: ->
    @trigger 'show_details', @model

  clone: ->
    @parentElement.clone @model
  
  showUnassignButton: ->
    @parentElement.render() # To remove button from other link views
    @renderWithButton 'unassign', 'Désassigner'
    @parentElement.highlightView(@)

  showAssignButton: ->
    @renderWithButton 'assign', 'Assigner'
    
  renderWithButton: (className, textButton) ->
    $(@el).html(@model.get('id_in_calcul') + " - " + @model.get('name'))
    $(@el).append("<button class='remove'>X</button>")
    $(@el).append("<button class='#{className}'>#{textButton}</button>")
    if @firstRendering
      $(@parentElement.el).append(@el)
      @firstRendering = false
    return this


  render: ->
    @renderWithButton 'edit', 'Editer'

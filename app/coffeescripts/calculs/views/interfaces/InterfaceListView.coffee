## InterfaceListView
SCViews.InterfaceListView = Backbone.View.extend
  el: '#interfaces'
  
  # You have to pass a InterfaceCollection at initialisation as follow:
  # new interfaceListView({ collection : myInterfaceCollection })
  initialize: ->
    @clearView()
    @interfaceViews = []
    for interface in @collection.models
      @interfaceViews.push new SCViews.InterfaceView model: interface, parentElement: this
    @selectedInterfaceView = null
    @render()
    $(@el).tablesorter()
    
     # Triggered when a interface is clicked
    @bind "selection_changed:interfaces", (selectedInterfaceView) =>
      @render() # Reset all views
      if @selectedInterfaceView == selectedInterfaceView
        @selectedInterfaceView.deselect()
        @selectedInterfaceView = null
        SCVisu.linkListView.trigger("selection_changed:interfaces", null)
      else
        @selectedInterfaceView.deselect() if @selectedInterfaceView
        @selectedInterfaceView = selectedInterfaceView
        @selectedInterfaceView.select()
        SCVisu.linkListView.trigger("selection_changed:interfaces", @selectedInterfaceView)


     # Triggered when a link is clicked
    @bind "selection_changed:links", (selectedLinkView) =>
      @selectedInterfaceView.deselect() if @selectedInterfaceView
      @selectedInterfaceView = null
      @render() # Reset all views
      if selectedLinkView != null
        $("button.assign_all, button.unassign_all").removeAttr('disabled')
        # On each interface, 
        # - If it is not assigned yet                                       -> we show an assign button
        # - If it is assigned and have the same id of the selected link -> We show Unassigned button
        # - Else, we do nothing
        _.each @interfaceViews, (interfaceView) =>
          if _.isUndefined(interfaceView.model.get('link_id'))
            interfaceView.showAssignButton()
          else if interfaceView.model.get('link_id') == selectedLinkView.model.getId()
            interfaceView.select()
            interfaceView.showUnassignButton()

    # Check if a interface had the link associated to it before. 
    # If it is the case, then it removes the association
    @bind "action:removed_link", (linkView) =>
      _.each @collection.models, (interface) ->
        if interface.get('link_id') == linkView.model.getId()
          interface.unset 'link_id'
      @render()
 

  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#interfaces' element already exists in the DOM and every time we create a InterfacesListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new InterfacesListView 
  clearView: ->
    $(@el).find('tbody').html('')

  # Assign the interfaceModel to the selected link.
  assignInterfaceToLink: (interfaceModel) ->
    interfaceModel.set link_id : SCVisu.linkListView.selectedLinkView.model.getId()
    SCVisu.current_calcul.set interfaces: SCVisu.interfaceListView.collection.models
    SCVisu.current_calcul.trigger 'change'

  # Assign the interfaceModel to the selected link.
  unassignInterfaceToLink: (interfaceModel) ->
    interfaceModel.unset "link_id"
    SCVisu.current_calcul.set interfaces: SCVisu.interfaceListView.collection.models
    SCVisu.current_calcul.trigger 'change'

  events:
    'change input#hide_assigned_interfaces' : 'toggleAssignedinterfaces'
    'click button.assign_all'               : 'assignAllVisibleInterfaces'
    'click button.unassign_all'             : 'unassignAllVisibleInterfaces'
  
  # If the checkbox is checked, hide all assigned interfaces
  toggleAssignedinterfaces: (event) ->
    if event.srcElement.checked
      _.each @interfaceViews, (interfaceView) ->
        $(interfaceView.el).hide() if interfaceView.model.isAssigned()
    else
      _.each @interfaceViews, (interfaceView) ->
        $(interfaceView.el).show()

  # Assign all visible interfaces which are visible to the selected link
  assignAllVisibleInterfaces: ->
    _.each @interfaceViews, (interfaceView) ->
      if $(interfaceView.el).is(':visible')
        interfaceView.model.set "link_id" : SCVisu.linkListView.selectedLinkView.model.getId()
        interfaceView.addUnassignButton()

  # Assign all visible interfaces which are visible to the selected link
  unassignAllVisibleInterfaces: ->
    _.each @interfaceViews, (interfaceView) ->
      if $(interfaceView.el).is(':visible')
        interfaceView.model.unset "link_id"
        interfaceView.addAssignButton()
    
  render : ->
    _.each @interfaceViews, (interface) ->
      interface.render()
      interface.deselect()
    return this

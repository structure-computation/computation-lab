## InterfaceListView
SCViews.InterfaceListView = Backbone.View.extend
  el: '#interfaces'
  
  # You have to pass a InterfaceCollection at initialisation as follow:
  # new interfaceListView({ collection : myInterfaceCollection })
  initialize: ->
    @clearView()
    @interfaceViews = []
    @filteredInterfaces = []
    for inter in @collection.models
      @interfaceViews.push new SCViews.InterfaceView model: inter, parentElement: this
    @selectedInterfaceView = null
    @render()
    $(@el).find('table').tablesorter()
    @filterValue = $(@el).find('select.between_two').val()
    
    @collection.bind 'add'   , @saveCalcul, this
    @collection.bind 'change', @saveCalcul, this
    @collection.bind 'remove', @saveCalcul, this
    
     # Triggered when a interface is clicked
    @bind "selection_changed:interfaces", (selectedInterfaceView) =>
      @render() # Reset all views
      $(@el).find("button.assign_all, button.unassign_all").attr('disabled', 'disabled')
      if @selectedInterfaceView == selectedInterfaceView
        @selectedInterfaceView.deselect()
        @selectedInterfaceView = null
        SCVisu.linkListView.trigger("selection_changed:interfaces", null)
      else
        @selectedInterfaceView.deselect() if @selectedInterfaceView
        @selectedInterfaceView = selectedInterfaceView
        @selectedInterfaceView.select()
        @selectedInterfaceView.showUnassignLinkButton() if @selectedInterfaceView.model.isAssigned()
        SCVisu.linkListView.trigger("selection_changed:interfaces", @selectedInterfaceView)


     # Triggered when a link is clicked
    @bind "selection_changed:links", (selectedLinkView) =>
      @selectedInterfaceView.deselect() if @selectedInterfaceView
      @selectedInterfaceView = null
      @render() # Reset all views
      if selectedLinkView != null
        $("button.assign_all, button.unassign_all").removeAttr('disabled') if !_.isEmpty @filteredInterfaces
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

    # Triggered when the unassigned button of a link is clicked.
    # Unassign the link from the current interface
    @bind "action:unassign:link", (linkView) =>
      @selectedInterfaceView.model.unset "link_id"
      @selectedInterfaceView.render()
      @selectedInterfaceView.select()

    # Triggered when the assigned button of a link is clicked.
    # Assign the current interface to the given link view
    @bind "action:assign:link", (linkView) =>
      @selectedInterfaceView.model.set link_id: linkView.model.getId()
      @selectedInterfaceView.render()
      @selectedInterfaceView.showUnassignLinkButton()
      @selectedInterfaceView.select()

    # Triggered when the assigned button of a interface is clicked.
    # Assign the current interface to the currently selected link
    @bind "action:assign:interface", (interfaceView) =>
      interfaceView.model.set link_id: SCVisu.linkListView.selectedLinkView.model.getId()
      interfaceView.showUnassignButton()
      interfaceView.select()
      
    # Triggered when the unassigned button of a interface is clicked.
    # Unassign the link from the current interface
    @bind "action:unassign:interface", (interfaceView) =>
      interfaceView.model.unset "link_id"
      interfaceView.showAssignButton()


  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#interfaces' element already exists in the DOM and every time we create a InterfacesListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new InterfacesListView 
  clearView: ->
    $(@el).find('tbody').html('')

  events:
    'change input#hide_assigned_interfaces' : 'toggleAssignedinterfaces'
    'change select.between_two'             : 'setBetweenFilter'
    'click button.assign_all'               : 'assignAllVisibleInterfaces'
    'click button.unassign_all'             : 'unassignAllVisibleInterfaces'
    'click button.filter'                   : 'executeFilter'
    'click button.cancel_filter'            : 'cancelFilter'
    
  ############################################################################# Filter functions - start

  # Set if the filter is between two "pieces" or two "materials"
  setBetweenFilter: (event) ->
    @filterValue = event.srcElement.value
  
  executeFilter: ->
    $(@el).find("button.cancel_filter").removeAttr('disabled') # Enable the button to cancel the filter

    @filteredInterfaces = []
    # Unhide every interface before filtering
    _.each @interfaceViews, (view) ->
      $(view.el).show()
      view.showView()
    firstID  = parseInt($(@el).find('input#first_input' ).val(), 10)
    secondID = parseInt($(@el).find('input#second_input').val(), 10)

    # Filters are not in the collection model, in order to change the view more easily
    if      @filterValue == "materials"
      @filterBetweenMaterials(firstID, secondID)
    else if @filterValue == "pieces"
      @filterBetweenPieces(firstID, secondID)

    # Remove assign or unassign interface from filter
    interfaceToFilter = $(@el).find('input:radio[name=interface_assigned]:checked').val()
    temp = [] # Used to store interface which will be used.
    for interfaceView, i in @filteredInterfaces
      # If user wants assigned interfaces, we remove unassigned interfaces
      # If user wants unassigned interfaces, we remove assigned interfaces
      if (interfaceToFilter == "assigned" and !interfaceView.model.isAssigned()) or (interfaceToFilter == "unassigned" and interfaceView.model.isAssigned())
        $(@filteredInterfaces[i].el).hide()
        interfaceView.hideView()
      else
        temp.push interfaceView
    @filteredInterfaces = temp

    # If a link is selected and the array of filtered interfaces is not empty => Enable 'assign all' and 'unassign all' button
    if !_.isEmpty(@filteredInterfaces) and SCVisu.linkListView.selectedLinkView != null
      $(@el).find("button.assign_all, button.unassign_all").removeAttr('disabled')
      
      
    @viewInterfaces()
  # Go through all the interfaces
  # Check get the two pieces it is attached to
  # Check if the material of those pieces correspond to the filter
  filterBetweenMaterials: (firstID, secondID) ->
    for interfaceView in @interfaceViews
      ids = interfaceView.model.get('adj_num_group').split(' ')
      piece1 = SCVisu.pieceListView.getPiece(ids[0])
      piece2 = SCVisu.pieceListView.getPiece(ids[1])
      materialIDs = [piece1.get('material_id'), piece2.get('material_id')]

      if materialIDs.indexOf(firstID) != -1 and materialIDs.indexOf(secondID) != -1
        # If firstID and secondID are the same (searching between an interface in contact with the same material)
        # Then materialIDs have to be the same
        @filteredInterfaces.push interfaceView if firstID != secondID or (materialIDs[0] == materialIDs[1])
      else
        $(interfaceView.el).hide()
        interfaceView.hideView()

  # Go throug all interfaces and check if the id of the pieces 
  # attached two correspond to the filter
  filterBetweenPieces: (firstID, secondID) ->
    for interfaceView in @interfaceViews
      # We have to make sure to get an array with numbers and not strings
      ids = [parseInt(interfaceView.model.get('adj_num_group').split(' ')[0], 10), parseInt(interfaceView.model.get('adj_num_group').split(' ')[1], 10)]
      # If the two ids are in the array and are not the same
      if ids.indexOf(firstID) != -1 and ids.indexOf(secondID) != -1 and ids.indexOf(firstID) != ids.indexOf(secondID)
        @filteredInterfaces.push interfaceView
      else
        $(interfaceView.el).hide() 
        interfaceView.hideView()

  cancelFilter: ->
    $("button.assign_all, button.unassign_all, button.cancel_filter").attr('disabled','disabled')
    @filteredInterfaces = []
    _.each @interfaceViews, (interfaceView) ->
        $(interfaceView.el).show()
        interfaceView.showView()
    @viewInterfaces()

  viewInterfaces: ->
    SCVisu.visualisation.view_filter("interfaces")   
    
  ############################################################################# Filter functions - end
  # If the checkbox is checked, hide all assigned interfaces
  toggleAssignedinterfaces: (event) ->
    if event.srcElement.checked
      _.each @interfaceViews, (interfaceView) ->
        $(interfaceView.el).hide() if interfaceView.model.isAssigned()
    else
      _.each @interfaceViews, (interfaceView) ->
        $(interfaceView.el).show()

  # Assign all filtered interfaces to the selected link
  assignAllVisibleInterfaces: ->
    _.each @filteredInterfaces, (interfaceView) ->
      interfaceView.model.set "link_id" : SCVisu.linkListView.selectedLinkView.model.getId()
      interfaceView.showUnassignButton()

  # Unassign all filtered interfaces
  unassignAllVisibleInterfaces: ->
    _.each @filteredInterfaces, (interfaceView) ->
      interfaceView.model.unset "link_id"
      interfaceView.showAssignButton()

  saveCalcul: ->
    SCVisu.current_calcul.set links: SCVisu.linkListView.collection.models
    SCVisu.current_calcul.set interfaces: @collection.models
    SCVisu.current_calcul.trigger 'change'

  render : ->
    _.each @interfaceViews, (interface) ->
      interface.render()
      interface.deselect()
    return this

  getInterface: (interfaceID) ->
    # I don't go through @collection.each because it would go through all 
    # elements and would not stop on return statement
    for interface in @collection.models
      if parseInt(interface.get('id'),10) == parseInt(interfaceID,10)
        return interface
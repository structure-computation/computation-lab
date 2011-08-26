## InterfaceListView
SCVisu.InterfaceListView = Backbone.View.extend
  el: 'ul#interfaces'
  
  # You have to pass a InterfaceCollection at initialisation as follow:
  # new PieceListView({ collection : myInterfaceCollection })
  initialize: ->
    @interfaceViews = []
    for interface in @collection.models
      @interfaceViews.push new SCVisu.InterfaceView model: interface, parentElement: this
    @selectedInterfaceModel = null
    @render()

  # Is executed when user click on an interface.
  # Highlight the selected interface and put others in gray.
  # If the selected interface is already assigned to a link, it will be highlighted and the user will have the 
  # possibility to unassign it.
  # Else, he will be able to select a link for the selected interface.
  selectInterface: (interfaceView) ->
    @selectedInterfaceModel = interfaceView.model
    _.each @interfaceViews, (interfaceView) ->
      $(interfaceView.el).addClass('gray').removeClass('selected')
    $(interfaceView.el).addClass('selected').removeClass('gray')
    if interfaceView.model.isAssigned()
      SCVisu.linkListView.highlightLink(interfaceView.model.get('link_id'))
    else
      SCVisu.linkListView.showAssignButtons()

  # Add an "Assign" button to each link view in order that the user can 
  # assign it to a selected interface. 
  # And an unassigned button to link whith which have the same link_id 
  # that the selected link.
  linkHasBeenSelected: (linkModel) ->
    _.each @interfaceViews, (interfaceView) ->
      $(interfaceView.el).addClass('selected').removeClass('gray')
      interfaceView.linkHasBeenSelected linkModel

  # Assign the pieceModel to the selected Material.
  assignInterfaceToLink: (interfaceModel) ->
    interfaceModel.set link_id : SCVisu.linkListView.selectedLinkModel.get('id')
    SCVisu.current_calcul.trigger 'update_interfaces', SCVisu.interfaceListView.collection.models

  # Assign the pieceModel to the selected Material.
  unassignInterfaceToLink: (interfaceModel) ->
    interfaceModel.unset "link_id"
    SCVisu.current_calcul.trigger 'update_interfaces', SCVisu.interfaceListView.collection.models    
    
  render : ->
    _.each @interfaceViews, (interface) ->
      interface.render()
    return this

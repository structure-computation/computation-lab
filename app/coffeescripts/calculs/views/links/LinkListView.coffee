## LinkListView
SCModels.LinkListView = Backbone.View.extend
  el: 'ul#links'
  
  initialize: (options) ->
    @clearView()
    @editView = new SCVisu.EditLinkView parentElement: this
    @linkViews = []
    for link in @collection.models
      @createLinkView(link)
    $('#links_database button.close').click -> $('#links_database').hide()
    @selectedLinkModel = null

  events: 
    "click button.add_link" : "showDatabaseLinks"
  
  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#links' element already exists in the DOM and every time we create a LinkListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new LinkListView 
  clearView: ->
    $(@el).html('')
  
  # Show links which are from database and hide edit view
  showDatabaseLinks: ->
    $('#links_database').show()
    @editView.hide()
  
  getNewMaterialId: ->
    @collection.last().get('id_in_calcul') + 1    

  # Add a model to the collection and creates an associated view
  add: (linkModel) ->
    linkModel.set id_in_calcul: @getNewMaterialId()
    @collection.model.push linkModel
    @createLinkView linkModel
    
  # Create a view giving it a model
  createLinkView: (link) ->
    l = new SCModels.LinkView model: link, parentElement: this
    l.bind 'show_details', @showDetails, this
    @linkViews.push l
    @render()

  # Show edit view for a given link
  showDetails: (model) ->
    $('#links_database').hide()
    @editView.updateModel model

  # Highlight the link which have link_id as id and add an "Unassign" button
  highlightLink: (link_id) ->
    _.each @linkViews, (view) ->
      if view.model.getId() == link_id
        $(view.el).addClass('selected').removeClass('gray')
        view.showUnassignButton()

  # Show an assign button to each link view
  showAssignButtons: ->
    _.each @linkViews, (view) ->
      $(view.el).removeClass('selected').removeClass('gray')
      view.showAssignButton()

  # Is executed when a link view has been clicked.
  # Tell the interfaces view to show all interfaces who have this link
  selectLink: (linkView) ->
    @highlightView linkView
    @selectedLinkModel = linkView.model
    SCVisu.interfaceListView.linkHasBeenSelected(linkView.model)
 
  # Add link to interface
  assignLinkToSelectedInterface: (linkView) ->
    SCVisu.interfaceListView.selectedInterfaceView.model.set link_id : linkView.model.getId()
    SCVisu.interfaceListView.renderAndHighlightCurrentInterface()
    SCVisu.current_calcul.set interfaces: SCVisu.interfaceListView.collection.models

  # Highlight the 'linkView' with adding css class
  highlightView: (linkView) ->
    _.each @linkViews, (view) -> 
      $(view.el).addClass('gray').removeClass('selected')
    $(linkView.el).addClass('selected').removeClass('gray')
  
  unassignLinkToSelectedInterface: ->
    SCVisu.interfaceListView.selectedInterfaceView.model.unset 'link_id'
    SCVisu.interfaceListView.renderAndHighlightCurrentInterface()
    SCVisu.current_calcul.set interfaces: SCVisu.interfaceListView.collection.models
   
  render : ->
    for l in @linkViews
      l.render()    
    $(@el).find(".add_link").remove() if $(@el).find(".add_link")
    $(@el).append('<button class="add_link">Ajouter une liaison</button>')
    return this

 
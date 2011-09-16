## LinkListView
SCViews.LinkListView = Backbone.View.extend
  el: 'ul#links'
    
  initialize: (options) ->    
    @clearView()
    @editView = new SCViews.EditLinkView parentElement: this
    @selectedLinkView = null

    @collection.bind 'change', (model) =>
      @render()
      @selectedLinkView.select() if @selectedLinkView != null and model == @selectedLinkView.model

    @collection.bind 'remove', (linkModel) =>
      if linkModel == @selectedLinkView.model
        @render()
        @editView.hide()

    @linkViews = []
    for link in @collection.models
      @createLinkView(link)
    $('#links_database').hide()
    $('#links_database button.close').click => 
      $('#links_database')   .slideUp()
      $('#list_calcul > div').slideDown()
      @editView.hide()

    # Triggered when a link is clicked
    @bind "selection_changed:links", (selectedLinkView) =>
      @render() # Reset all views
      # Hide edit view if the model selected is not the same as the one in the edit view
      @editView.hide() if @editView.model != selectedLinkView.model
      if @selectedLinkView == selectedLinkView
        @selectedLinkView.deselect()
        @selectedLinkView = null
        SCVisu.interfaceListView.trigger("selection_changed:links", null)
      else
        @selectedLinkView.deselect() if @selectedLinkView
        @selectedLinkView = selectedLinkView
        @selectedLinkView.select()
        SCVisu.interfaceListView.trigger("selection_changed:links", @selectedLinkView)
      
    # Triggered when an interface is clicked
    @bind "selection_changed:interfaces", (selectedInterfaceView) =>
      @selectedLinkView.deselect() if @selectedLinkView
      @selectedLinkView = null
      @editView.hide()
      @render() # Reset all views
      
      if selectedInterfaceView != null
        # If the selected interface is not null, then there is two possibilities:
        # The interface is already assigned to a link 
        if !_.isUndefined(selectedInterfaceView.model.get('link_id'))
          # Then we have to select this link and show an unassign button
          for linkView in @linkViews
            if linkView.model.getId() == selectedInterfaceView.model.get('link_id')
              linkView.select()
              linkView.showUnassignButton()
              break
        # The interface doesn't have a link assigned yet
        else
          # Then we have to show assign buttons
          _.each @linkViews, (linkView) =>
            linkView.showAssignButton()
            

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
    $('#list_calcul > div').slideUp()
    $('#links_database')   .slideDown()

  # getNewLinkId: ->
  #   @collection.last().get('id_in_calcul') + 1    

  # Add a model to the collection and creates an associated view
  add: (linkModel) ->
#    linkModel.set id_in_calcul: @getNewLinkId()
    @collection.add linkModel
    @createLinkView linkModel
    SCVisu.current_calcul.set links: @collection.models  
    SCVisu.current_calcul.trigger 'change'
    
  # Create a view giving it a model
  createLinkView: (link) ->
    l = new SCViews.LinkView model: link, parentElement: this
    @linkViews.push l
    @render()

  # Show edit view for a given link
  # If readonly = true, all inputs will be disabled
  showDetails: (model, readonly = false) ->
    @editView.updateModel model, readonly

  # Show an assign button to each link view
  showAssignButtons: ->
    _.each @linkViews, (view) ->
      $(view.el).removeClass('selected')
      view.showAssignButton()

  # Add link to interface
  assignLinkToSelectedInterface: (linkView) ->
    SCVisu.interfaceListView.selectedInterfaceView.model.set link_id : linkView.model.getId()
    SCVisu.current_calcul.set interfaces: SCVisu.interfaceListView.collection.models
    SCVisu.current_calcul.trigger 'change'
    
  
  unassignLinkToSelectedInterface: ->
    SCVisu.interfaceListView.selectedInterfaceView.model.unset 'link_id'
    SCVisu.current_calcul.set interfaces: SCVisu.interfaceListView.collection.models
    SCVisu.current_calcul.trigger 'change'
    
  render : ->
    for linkView in @linkViews
      linkView.render()    
      linkView.deselect()
    $(@el).find(".add_link").remove() if $(@el).find(".add_link")
    $(@el).append('<button class="add_link">Ajouter une liaison</button>')
    return this

 
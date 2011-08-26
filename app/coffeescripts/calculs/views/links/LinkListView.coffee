## LinkListView
SCVisu.LinkListView = Backbone.View.extend
  el: 'ul#links'
  
  initialize: (options) ->
    @editView = new SCVisu.EditLinkView parentElement: this
    @linkViews = []
    for link in @collection.models
      @createLinkView(link)
    @render() 
    @selectedLinkModel = null

  createLinkView: (link) ->
    l = new SCVisu.LinkView model: link, parentElement: this
    l.bind 'update_details_model', @update_details, this
    @linkViews.push l
    
  update_details: (model) ->
    @editView.updateModel model   

  # Highlight the link which have link_id as id and add an "Unassign" button
  highlightLink: (link_id) ->
    _.each @linkViews, (view) ->
      if view.model.get('id') == link_id
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
    SCVisu.interfaceListView.selectedInterfaceModel.set link_id : linkView.model.get('id')
    SCVisu.current_calcul.trigger 'update_interfaces', SCVisu.interfaceListView.collection.models

  # Highlight the 'linkView' with adding css class
  highlightView: (linkView) ->
    _.each @linkViews, (view) -> 
      $(view.el).addClass('gray').removeClass('selected')
    $(linkView.el).addClass('selected').removeClass('gray')
  
  unassignLinkToSelectedInterface: ->
    SCVisu.interfaceListView.selectedInterfaceModel.unset 'link_id'
    SCVisu.current_calcul.trigger 'update_interfaces', SCVisu.interfaceListView.collection.models
    
  render : ->
    for l in @linkViews
      l.render()
    return this

 
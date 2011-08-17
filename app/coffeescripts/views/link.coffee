## LinkListView
window.LinkListView = Backbone.View.extend
  el: '#links_table'
  
  initialize: (options) ->
    @linkViews          = []
    @localLinks = new LocalLinkListView
    @bind "linkAdded", @addSelectedLink, this
    
    for link in @collection
      @linkViews.push new LinkView model: link, parentElement: this
    @render()
    
  addSelectedLink: (selectedLink) ->
    @localLinks.addLink(selectedLink)
    
  render : ->

    for linkView in @linkViews
      linkView.render()
    return this


## Link View
window.LinkView = Backbone.View.extend
  tagName   : "tr"
  initialize: (params) ->
    @parentElement = params.parentElement
  events: 
    'click .add' : 'addLink'

  addLink: ->
    @parentElement.trigger 'linkAdded', @model
    
  render: ->
    template = """
        <td>#{@model.get('name')}</td>
        <td><button class='add'>Ajouter</button></td>
            """
    $(@el).html(template)
    $("#links_table tbody").append(@el)
    return this


## LocalLinkListView
window.LocalLinkListView = Backbone.View.extend
  el: '#selected_links_table'

  initialize: (options) ->
    @selectedLinkViews = []
    @bind "linkRemoved", @removeLink, @
    @bind "editLink", @editLink, @
    @editLinkView = new EditLinkView parentElement: this
    
  removeLink: (linkToRemove) ->
    for linkView, i in @selectedLinkViews
      if linkView.model == linkToRemove
        @selectedLinkViews.splice(i, 1)
        linkView.remove()
        @render()
        break
  editLink: (link) ->
    @editLinkView.updateModel link

  addLink: (selectedLink) ->
    newLink = selectedLink.clone()

    for linkView in @selectedLinkViews
      if linkView.model.get('name') == newLink.get('name')
        newLink.set name : newLink.get('name') + " - copy"
        break
    @selectedLinkViews.push new SelectedLinkView model: newLink, parentElement: this
    @render()

  render : ->
    for linkView in @selectedLinkViews
      linkView.render()
    return this


## Selected Link View
window.SelectedLinkView = Backbone.View.extend
  tagName   : "tr"
  initialize: (params) ->
    @parentElement = params.parentElement

  events: 
    'click .delete' : 'deleteLink'
    'click .edit' : 'editLink'

  deleteLink: ->
    @parentElement.trigger 'linkRemoved', @model
  editLink: ->
    @parentElement.trigger 'editLink', @model
  render: ->
    template = """
        <td>#{@model.get('name')}</td>
        <td><button class='edit'>Editer</button></td>
        <td><button class='delete'>Supprimer</button></td>
            """
    $(@el).html(template)
    $("#selected_links_table tbody").append(@el)
    return this

## Edit Link View
window.EditLinkView = Backbone.View.extend
  el: "#edit_link"
  initialize: (params) ->
    @parentElement = params.parentElement
    
  events: 
    'keyup': 'updateModelAttributes'

  updateModel: (model) ->
    @model = model
    @render()
    
  updateModelAttributes: ->
    @model.set name:          $(@el).find('#link_name')       .val()
    @model.set description:   $(@el).find('#link_description').val()
    @model.set Ep:            $(@el).find('#link_Ep')         .val()
    @model.set jeu:           $(@el).find('#link_jeu')        .val()
    @model.set R:             $(@el).find('#link_R')          .val()
    @model.set Lp:            $(@el).find("#link_Lp")         .val()
    @model.set Dp:            $(@el).find("#link_Dp")         .val()
    @model.set p:             $(@el).find("#link_p")          .val()
    @model.set Lr:            $(@el).find("#link_Lr")         .val()
    @model.set f:             $(@el).find("#link_f")          .val()

    @parentElement.render()
    
  render: ->
    $(@el).find('#link_name')         .val(@model.get("name"))
    $(@el).find('#link_description')  .val(@model.get("description"))
    $(@el).find('#link_Ep')           .val(@model.get("Ep"))
    $(@el).find('#link_jeu')          .val(@model.get("jeu"))
    $(@el).find('#link_R')            .val(@model.get("R"))
    $(@el).find("#link_Lp")           .val(@model.get("Lp"))
    $(@el).find("#link_Dp")           .val(@model.get("Dp"))
    $(@el).find("#link_p")            .val(@model.get("p"))
    $(@el).find("#link_Lr")           .val(@model.get("Lr"))
    $(@el).find("#link_f")            .val(@model.get("f"))

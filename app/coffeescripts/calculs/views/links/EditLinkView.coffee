## Edit Link View
SCVisu.EditLinkView = Backbone.View.extend
  el: "#edit_link"
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@el).append('<button class="save_in_workspace">Sauvegarder dans le workspace</button>')    
    $(@el).append('<button class="close">Fermer</button>')
    $(@el).hide()

  events: 
    'change'              : 'updateModelAttributes'
    'click button.close'  : 'hide'
    'click button.save_in_workspace': 'saveInWorkspace'

  # Save the model in the Database in the urser's workspace
  saveInWorkspace: ->
    @model.unset 'id'
    @model.save()
  
  # Update edit view with the given model
  updateModel: (model) ->
    @model = model
    @render()

  # Hide itself
  hide: ->
    $(@el).hide()
  
  # Update model from all input values
  updateModelAttributes: ->
    for input in $(@el).find('input, textarea')
      key = $(input).attr('id').split('link_')[1]
      value = $(input).val()
      h = new Object()
      h[key] = value
      @model.set h
  
  # Reset all fields of the edit view
  resetFields: ->
    for input in $(@el).find('input, textarea')
      $(input).val("")

  
  render: (resetFields = false) ->
    $(@el).show()
    @parentElement.render()
    for input in $(@el).find('input, textarea')
      $(input).val(@model.get($(input).attr('id').split("link_")[1]))
  

SCViews.EditMaterialView = Backbone.View.extend
  el: "#edit_material"
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@el).append('<button class="save_in_workspace">Sauvegarder dans le workspace</button>')    
    $(@el).append('<button class="close_edit_view">Fermer</button>')    
    @hide()

  events: 
    'change'                        : 'updateModelAttributes'
    'click button.close_edit_view'  : 'hide'
    'click button.save_in_workspace': 'saveInWorkspace'

  # Save the model in the Database in the urser's workspace
  saveInWorkspace: ->
    @model.unset 'id'
    @model.save()

  # Hide itself
  hide: ->
    $(@el).hide()
    
  # Update moddel with values which are in inputs
  updateModelAttributes: ->
    for input in $(@el).find('input, textarea')
      # Get the name of the attribute
      # HTML Is formatted as follow: <input id="material_family"...
      key = $(input).attr('id').split('material_')[1] 
      value = $(input).val()
      h = new Object()
      h[key] = value
      @model.set h
    SCVisu.current_calcul.set materials: SCVisu.materialListView.collection.models  

  # Update view with the given model
  updateModel: (model) ->
    @model = model
    @render()
        
  # Reset all fields of the view
  resetFields: ->
    for input in $(@el).find('input, textarea')
      $(input).val("")
    
  
  render: (resetFields = false) ->
    $(@el).show()
    @parentElement.render()
    if resetFields
      @resetFields()
    else
      for input in $(@el).find('input, textarea')
        $(input).val(@model.get($(input).attr('id').split("material_")[1]))


SCVisu.EditMaterialView = Backbone.View.extend
  el: "#edit_material"
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@el).append('<button class="close_edit_view">Fermer</button>')    
    @hide()

  events: 
    'keyup'                         : 'updateModelAttributes'
    'click button.close_edit_view'  : 'hide'


  #Hide itself
  hide: ->
    $(@el).hide()
    
  # Update moddel with values which are in inputs
  updateModelAttributes: ->
    for input in $(@el).find('input, textarea')
      key = $(input).attr('id').split('material_')[1]
      value = $(input).val()
      h = new Object()
      h[key] = value
      @model.set h
    SCVisu.current_calcul.trigger 'update_materials', SCVisu.materialListView.collection.models  

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


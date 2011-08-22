window.EditMaterialView = Backbone.View.extend
  el: "#edit_material"
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@el).append('<button class="save">Sauvegarder</button>')
    $(@el).append("<button class='save_as_new'>Sauver en tant que nouveau matériau</button>")
    @disableButtons()

  events: 
    # 'keyup'       : 'updateModelAttributes'
    'click .save'       : 'save'
    'click .save_as_new' : 'saveAsNew'
  
  saveAsNew: ->
    @disableButtons()
    m = new Material
    for input in $(@el).find('input, textarea')
      key = $(input).attr('id').split('material_')[1]
      value = $(input).val()
      h = new Object()
      h[key] = value
      m.set h
    @parentElement.collection.add m
    @parentElement.createMaterialView m
    @render(true)

  save: ->
    for input in $(@el).find('input, textarea')
      key = $(input).attr('id').split('material_')[1]
      value = $(input).val()
      h = new Object()
      h[key] = value
      @model.set h
    @model.save()
    @render(true)

  updateModel: (model) ->
    @model = model
    @enableButtons()
    @render()
        
  
  resetFields: ->
    for input in $(@el).find('input, textarea')
      $(input).val("")
    @disableButtons()
    
  disableButtons: ->
    $(@el).find('button').attr('disabled', 'disabled')
  enableButtons: ->
    $(@el).find('button').removeAttr('disabled')
    
  render: (resetFields = false) ->
    @parentElement.render()
    if resetFields
      @resetFields()
    else
      for input in $(@el).find('input, textarea')
        $(input).val(@model.get($(input).attr('id').split("material_")[1]))


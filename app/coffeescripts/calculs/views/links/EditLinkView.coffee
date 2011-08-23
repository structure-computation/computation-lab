## Edit Link View
SCVisu.EditLinkView = Backbone.View.extend
  el: "#edit_link"
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@el).append('<button class="save">Sauvegarder</button>')
    $(@el).append("<button class='save_as_new'>Sauver en tant que nouveau link</button>")
    @disableButtons()

  events: 
    # 'keyup'       : 'updateModelAttributes'
    'click .save'       : 'updateModelAttributes'
    'click .save_as_new' : 'saveAsNew'
  
  saveAsNew: ->
    @disableButtons()
    l = new Link
    for input in $(@el).find('input, textarea')
      key = $(input).attr('id').split('link_')[1]
      value = $(input).val()
      h = new Object()
      h[key] = value
      l.set h
    @parentElement.collection.add l
    @parentElement.createLinkView l
    @render()
    
  updateModel: (model) ->
    @model = model
    @enableButtons()
    @render()

        
  updateModelAttributes: ->
    for input in $(@el).find('input, textarea')
      key = $(input).attr('id').split('link_')[1]
      value = $(input).val()
      h = new Object()
      h[key] = value
      @model.set h
    @model.save()
    @resetFields()
  
  resetFields: ->
    for input in $(@el).find('input, textarea')
      $(input).val("")
    @disableButtons()
    
  disableButtons: ->
    $(@el).find('button').attr('disabled', 'disabled')
  enableButtons: ->
    $(@el).find('button').removeAttr('disable')
    
  render: ->
    @parentElement.render()
    for input in $(@el).find('input, textarea')
      $(input).val(@model.get($(input).attr('id').split("link_")[1]))


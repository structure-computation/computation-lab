## Edit Link View
SCViews.EditLinkView = Backbone.View.extend
  el: "#edit_link"
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@el).append('<button class="close">Fermer</button>')
    $(@el).hide()

  events: 
    'change'                         : 'updateModelAttributes'
    'click button.close'             : 'hide'
  
  # Update edit view with the given model
  updateModel: (model, readonly = false) ->
    @model = model
    if readonly then @disableAllInputs() else @enableAllInputs()
    @render()

  # Enable all inputs
  enableAllInputs: ->
    $(@el).find('input, textarea').removeAttr 'disabled'

  # Disable all inputs
  disableAllInputs: ->
    $(@el).find('input, textarea').attr 'disabled', 'disabled'

  # Hide itself
  hide: ->
    # Put back the visu
    $('#visu_calcul').show()
    $(@el).hide()
  
  # Update model from all input values
  updateModelAttributes: ->
    for input in $(@el).find('input, textarea')
      key    = $(input).attr('id').split('link_')[1]
      value  = $(input).val()
      h      = new Object()
      h[key] = value
      @model.set h
  
  # Reset all fields of the edit view
  resetFields: ->
    for input in $(@el).find('input, textarea')
      $(input).val("")

  
  render: (resetFields = false) ->
    $('#visu_calcul').hide()
    $(@el).show()
    @parentElement.render()
    for input in $(@el).find('input, textarea')
      $(input).val(@model.get($(input).attr('id').split("link_")[1]))
  

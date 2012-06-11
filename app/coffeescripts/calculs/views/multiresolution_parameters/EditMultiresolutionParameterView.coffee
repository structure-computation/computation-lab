# View for editing and creating a boundary condition
# Each condition has stepFunctions for each step in the calcul
SCViews.EditMultiresolutionParameterView = Backbone.View.extend
  el: '#multiresolution_parameter_form'
  
  initialize: ->
    @hide()
    @model = null
    
  events:
    "change"             : "updateModelAttributes"
    "click button.close" : "hide"
    
  # Show the good function form. Relative to the step selected
  showFunctionPart: (event) ->
    $(@el).find('.functionPart > div').hide()
    $(@el).find(".#{event.srcElement.value}").show()

  # Update the model attributes reguarding the inputs
  updateModelAttributes: ->
    
    @model.set
      alias_name          : $(@el).find('input.alias_name')               .val()
      description         : $(@el).find('textarea.description')           .val()
      parametric_function : $(@el).find('input.parametric_function')      .val()
    
    SCVisu.current_calcul.trigger 'change'

  # Set the inputs reguarding the model passed
  setModel: (model) ->
    $("#visu_calcul").hide()
    @show()
    @model = model
    $(@el).find('input.alias_name')               .val(@model.get('alias_name'))
    $(@el).find('textarea.description')           .val(@model.get('description'))
    $(@el).find('input.parametric_function')      .val(@model.get('parametric_function'))

  # Hide itself and show the visu
  hide: ->
    $(@el).hide()
    $('#visu_calcul').show()

  # Show itself and hide the visu
  show: ->
    $(@el).show()
    $('#visu_calcul').hide()
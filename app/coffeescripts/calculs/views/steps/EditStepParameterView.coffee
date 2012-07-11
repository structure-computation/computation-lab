# View for editing and creating a boundary condition
# Each condition has stepFunctions for each step in the calcul
SCViews.EditStepParameterView = Backbone.View.extend
  el: '#time_parameter_form'
  
  initialize: ->
    @hide()
    @model = null
    
  events:
    "change"             : "updateModelAttributes"
    "click button.close" : "hide"
    "change select.steps": "showFunctionPart"
    
  # Show the good function form. Relative to the step selected
  showFunctionPart: (event) ->
    $(@el).find('.functionPart > div').hide()
    $(@el).find(".#{event.srcElement.value}").show()

  # Update the model attributes reguarding the inputs
  updateModelAttributes: ->
    @model.set
      alias_name          : $(@el).find('input.alias_name')               .val()
      description         : $(@el).find('textarea.description')           .val()

    # Each function is related to a step in the calcul
    stepFunctions = []
    for stepFunctionElement in $(@el).find('.functionPart div')
      stepFunctionElement = $(stepFunctionElement)
      stepFunctions.push
        step_id             : stepFunctionElement.data("step_id")
        temporal_function_t : stepFunctionElement.find('input.ft').val()
    @model.set stepFunctions: stepFunctions
    SCVisu.current_calcul.trigger 'change'

  # Set the inputs reguarding the model passed
  setModel: (model) ->
    $("#visu_calcul").hide()
    $(@el).find('select.steps, .functionPart').html('')
    @show()
    @model = model
    $(@el).find('input.alias_name')               .val(@model.get('alias_name'))
    $(@el).find('textarea.description')           .val(@model.get('description'))
    @render()
    @fillInputsFromModel()
    
  fillInputsFromModel: ->
    # If the type is symetry, then it doesn't ave step functions
    for stepFunction in @model.get('stepFunctions')
      stepFunctionElement               = $($(@el).find(".step_#{stepFunction['step_id']}"))
      stepFunctionElement.find('input.ft').val(stepFunction['temporal_function_t'])

  render: ->
    $(@el).find('.functionPart').html('')
    $(@el).find('.functionPartHeader').show()
    SCVisu.stepListView.collection.each (step) =>
      $(@el).find('select.steps').append("<option value='step_#{step.getId()}'>#{step.get('name')}</option>")
      $(@el).find('.functionPart').append(@functionPartTemplate(step))
      
    $(@el).find('.functionPart > div:not(:first)').hide()

  # Hide itself and show the visu
  hide: ->
    $(@el).hide()
    $('#visu_calcul').show()

  # Show itself and hide the visu
  show: ->
    $(@el).show()
    $('#visu_calcul').hide()
    $('#multiresolution_parameter_form').hide()

  # Template for inputs for step function part
  functionPartTemplate: (step) ->
    """
    <div class="step_#{step.getId()}" data-step_id="#{step.getId()}">
      <table class="grey">
        <tbody>
          <tr>
            <th>
              Fonction temporelle f(t) = 
            </th>
            <td>
              <input class="ft" data-type="number" class="time_function" name="" placeholder="" size="10" type="text">
            </td>
          </tr>
        </tbody>
      </table>
    </div>
    """ 
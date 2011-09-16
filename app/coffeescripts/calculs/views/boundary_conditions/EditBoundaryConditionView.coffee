# View for editing and creating a boundary condition
# Each condition has stepFunctions for each step in the calcul
SCViews.EditBoundaryConditionView = Backbone.View.extend
  el: '#boundary_condition_form'
  
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
      condition_type      : $(@el).find('select.boundary_condition_type') .val()
      name                : $(@el).find('input.name')                     .val()
      description         : $(@el).find('textarea.description')           .val()

    # Each function is related to a step in the calcul
    stepFunctions = []
    for stepFunctionElement in $(@el).find('.functionPart div')
      stepFunctionElement = $(stepFunctionElement)
      stepFunctions.push
        step_id             : stepFunctionElement.data("step_id")
        spatial_function_x  : stepFunctionElement.find('input.x') .val()
        spatial_function_y  : stepFunctionElement.find('input.y') .val()
        spatial_function_z  : stepFunctionElement.find('input.z') .val()
        temporal_function_t : stepFunctionElement.find('input.ft').val()
    @model.set stepFunctions: stepFunctions
    SCVisu.current_calcul.trigger 'change'

  # Set the inputs reguarding the model passed
  setModel: (model) ->
    $("#edge_form, #visu_calcul").hide()
    $(@el).find('select.steps, .functionPart').html('')
    SCVisu.stepListView.collection.each (step) =>
      $(@el).find('select.steps').append("<option value='step_#{step.getId()}'>#{step.get('name')}</option>")
      $(@el).find('.functionPart').append(@functionPartTemplate(step))
    $(@el).find('.functionPart > div:not(:first)').hide()

    @show()
    @model = model
    $(@el).find('select.boundary_condition_type') .val(@model.get('condition_type'))
    $(@el).find('input.name')                     .val(@model.get('name'))
    $(@el).find('textarea.description')           .val(@model.get('description'))

    if !_.isUndefined(@model.get('stepFunctions'))
      for stepFunction in @model.get('stepFunctions')
        stepFunctionElement = $($(@el).find(".step_#{stepFunction['step_id']}"))
        stepFunctionElement.find('input.x') .val(stepFunction['spatial_function_x'])
        stepFunctionElement.find('input.y') .val(stepFunction['spatial_function_y'])
        stepFunctionElement.find('input.z') .val(stepFunction['spatial_function_z'])
        stepFunctionElement.find('input.ft').val(stepFunction['temporal_function_t'])
          
  # Hide itself and show the visu
  hide: ->
    $(@el).hide()
    $('#visu_calcul').show()

  # Show itself and hide the visu
  show: ->
    $(@el).show()
    $('#visu_calcul').hide()
  # Template for inputs for step function part
  functionPartTemplate: (step) ->
    """
    <div class="step_#{step.getId()}" data-step_id="#{step.getId()}">
      <table class="grey">
        <tbody>
          <tr>
            <th>
              Fonction spatiale (x, y, z)
            </th>
            <td>
              <input class="x" data-type="number" class="spatial_function_x" name="" placeholder="x" size="10" type="text">
            </td>
            <td>
              <input class="y" data-type="number" class="spatial_function_y" name="" placeholder="y" size="10" type="text">
            </td>
            <td>
              <input class="z" data-type="number" class="spatial_function_z" name="" placeholder="z" size="10" type="text">
            </td>
          </tr>
        </tbody>
      </table>
      <table class="grey">
        <tbody>
          <tr>
            <th>
              Fonction temporelle (ft) = 0 = 
            </th>
            <td>
              <input class="ft" data-type="number" class="time_function" name="" placeholder="" size="10" type="text">
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  """
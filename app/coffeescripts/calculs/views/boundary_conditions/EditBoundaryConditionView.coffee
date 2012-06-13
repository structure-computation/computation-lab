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
    "change select.boundary_condition_type" : "typeChanged"
  
  typeChanged: (event) ->    
    @boundaryConditionType = event.srcElement.value
    # Unset certain attributes regarding the condition type. 
    # I do this to prevent to have useless and unappropriate attributes
    switch @boundaryConditionType
      when "effort_normal", "depl_normal"    
        @model.set 'spatial_function_x' : undefined
        @model.set 'spatial_function_y' : undefined
        @model.set 'spatial_function_z' : undefined
      when "symetry"
        @model.unset('spatial_function_x')
        @model.unset('spatial_function_y')
        @model.unset('spatial_function_z')
      else
        @model.set 'spatial_function_x'  : undefined
    @render()
    @fillInputsFromModel()

  # Update the model attributes reguarding the inputs
  updateModelAttributes: ->
    @model.set
      condition_type      : $(@el).find('select.boundary_condition_type') .val()
      name                : $(@el).find('input.name')                     .val()
      description         : $(@el).find('textarea.description')           .val()
      
    stepFunctionElement = $($(@el).find(".step_1")) 
    @model.set
      spatial_function_x  : stepFunctionElement.find('input.x')           .val()
      spatial_function_y  : stepFunctionElement.find('input.y')           .val()
      spatial_function_z  : stepFunctionElement.find('input.z')           .val()
      normal_function     : stepFunctionElement.find('input.normal_function')           .val()
    
    SCVisu.current_calcul.trigger 'change'

  # Set the inputs reguarding the model passed
  setModel: (model) ->
    $("#edge_form, #visu_calcul").hide()
    @show()
    @model = model
    @boundaryConditionType = @model.get('condition_type')
    $(@el).find('select.boundary_condition_type') .val(@boundaryConditionType)
    $(@el).find('input.name')                     .val(@model.get('name'))
    $(@el).find('textarea.description')           .val(@model.get('description'))
    @render()
    @fillInputsFromModel()
    
  fillInputsFromModel: ->
    #alert @model.get('normal_function')
    # If the type is symetry, then it doesn't ave step functions
    if @boundaryConditionType!= "symetry"
      if @boundaryConditionType == "effort_normal" or @boundaryConditionType == "depl_normal"
        stepFunctionElement = $($(@el).find(".step_1"))
        stepFunctionElement.find('input.x') .val(@model.get('spatial_function_x'))
      else
        stepFunctionElement = $($(@el).find(".step_1"))
        stepFunctionElement.find('input.x') .val(@model.get('spatial_function_x'))
        stepFunctionElement.find('input.y') .val(@model.get('spatial_function_y'))
        stepFunctionElement.find('input.z') .val(@model.get('spatial_function_z'))

  render: ->
    $(@el).find('.functionPart').html('')
    $(@el).find('.functionPartHeader').show()
    switch @boundaryConditionType
      when "effort_normal", "depl_normal"   
        $(@el).find('.functionPart').append(@functionNormalPartTemplate())
      when "symetry"
        $(@el).find('.functionPartHeader').hide()
      else
        $(@el).find('.functionPart').append(@functionPartTemplate())
      
    $(@el).find('.functionPart > div:not(:first)').hide()

  # Hide itself and show the visu
  hide: ->
    $(@el).hide()
    $('#visu_calcul').show()

  # Show itself and hide the visu
  show: ->
    $(@el).show()
    $('#visu_calcul').hide()

  # Template for inputs for step function part
  functionPartTemplate: () ->
    """
    <div class="step_1">
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
    </div>
  """  
  # Template for inputs for step function part when type is normal
  functionNormalPartTemplate: () ->
    """
    <div class="step_1">
      <table class="grey">
        <tbody>
          <tr>
            <th>
              Fonction normale 
            </th>
            <td>
              <input class="x" data-type="number" name="spatial_function_x" size="10" type="text">
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  """
## MultiresolutionParameter View
SCViews.MultiresolutionParameterView = Backbone.View.extend
  initialize:  (options)->
    @parentElement = options.parentElement
    @render()
    $(@parentElement.el).find('tbody').append(@el)

  tagName   : "tr"

  clearView: ->
    $(@el).html('')
  
    
  render : ->
    if SCVisu.current_calcul.get('multiresolution_parameters').multiresolution_type == "function"
      @render_function()
    else if SCVisu.current_calcul.get('multiresolution_parameters').multiresolution_type == "orthogonal_plan"
      @render_orthogonal_plan()
    
  render_orthogonal_plan : ->
    # Using Underscore "_" template
    template = _.template """
              <td class="name">
                <input type='text' value='<%= name %>' disabled> 
              </td> 
              <td class="nominal_value">
                <input type='number' value='<%= nominal_value %>'> 
              </td> 
              <td class="min_value"> 
                <input type='number' value='<%= min_value %>'> 
              </td> 
              <td class="max_value">
                <input type='number' value='<%= max_value %>'> 
              </td> 
              <td class="nb_value">
                <input type='number' value='<%= nb_value %>'> 
              </td> 
              <td>
                <button class='delete'>X</button>
              </td> 
          """
    $(@el).html template
      name          : @model.get('name')
      nominal_value : @model.get('nominal_value')
      min_value     : @model.get('min_value')
      max_value     : @model.get('max_value')
      nb_value      : @model.get('nb_value')
  
  
  render_function : ->
    # Using Underscore "_" template
    template = _.template """
              <td class="name">
                <input type='text' value='<%= name %>' disabled> 
              </td> 
              <td class="nominal_value">
                <input type='number' value='<%= nominal_value %>'> 
              </td> 
              <td class="parametric_function"> 
                <input type='text' value='<%= parametric_function %>'> 
              </td> 
              <td>
                <button class='delete'>X</button>
              </td> 
          """
    $(@el).html template
      name          : @model.get('name')
      nominal_value : @model.get('nominal_value')
      parametric_function     : @model.get('parametric_function')

  events:
    'click button.delete' : 'delete'
    'change input'        : 'updateModel'
    'click button.edit'   : 'edit'
  
  # Show the edit part
  edit: ->
    @parentElement.showDetails(@model)
    # Trigger selection change only when the material selected change because it
    $('#visu_calcul').hide()  
    
    
  updateModel: ->
    SCVisu.current_calcul.trigger 'change'
    if SCVisu.current_calcul.get('multiresolution_parameters').multiresolution_type == "function"
      @model.set 
        'nominal_value'           : $(@el).find('.nominal_value input').val()
        'parametric_function'     : $(@el).find('.parametric_function input').val()
    else if SCVisu.current_calcul.get('multiresolution_parameters').multiresolution_type == "orthogonal_plan"
      @model.set 
        'nominal_value'           : $(@el).find('.nominal_value input').val()
        'min_value'               : $(@el).find('.min_value input')    .val()
        'max_value'               : $(@el).find('.max_value input')    .val()
        'nb_value'                : $(@el).find('.nb_value input')     .val()
    SCVisu.current_calcul.trigger 'change'  
    SCVisu.current_calcul.setMultiresolutionParameterCollection @parentElement.collection.models


  delete: (withoutPrompting = false)->
    if withoutPrompting
      @model.destroy()
      SCVisu.current_calcul.trigger 'change'
      @remove()
    else if confirm "Êtes-vous sûr ?"
      @model.destroy()
      SCVisu.current_calcul.trigger 'change'
      @remove()
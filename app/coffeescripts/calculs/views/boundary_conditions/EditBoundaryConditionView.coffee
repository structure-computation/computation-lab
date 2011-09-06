SCViews.EditBoundaryConditionView = Backbone.View.extend
  el: '#boundary_condition_form'
  
  initialize: ->
    @hide()
    @model = null
    
  events:
    "change" : "updateModelAttributes"

  updateModelAttributes: ->
    @model.set
      condition_type      : $(@el).find('select.boundary_condition_type') .val()
      name                : $(@el).find('input.name')                     .val()
      description         : $(@el).find('textarea.description')           .val()
      spatial_function_x  : $(@el).find('input.x')                        .val()
      spatial_function_y  : $(@el).find('input.y')                        .val()
      spatial_function_z  : $(@el).find('input.z')                        .val()
      temporal_function_t : $(@el).find('input.ft')                       .val()



  setModel: (model) ->
    @show()
    @model = model
    $(@el).find('select.boundary_condition_type')       .val(@model.get('condition_type'))
    $(@el).find('input.name')           .val(@model.get('name'))
    $(@el).find('textarea.description') .val(@model.get('description'))
    $(@el).find('input.x')              .val(@model.get('spatial_function_x'))
    $(@el).find('input.y')              .val(@model.get('spatial_function_y'))
    $(@el).find('input.z')              .val(@model.get('spatial_function_z'))
    $(@el).find('input.ft')             .val(@model.get('temporal_function_t'))
          

  hide: ->
    $(@el).hide()
  show: ->
    $(@el).show()

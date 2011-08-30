SCViews.EditBoundaryConditionView = Backbone.View.extend
  el: '#boundary_condition'
  
  initialize: ->
    @hide()
    @model = null
    
  setModel: (model) ->
    @show()
    @model = model
    console.log @model
    $(@el).find('.name input')        .val(@model.get('name'))
    $(@el).find('.description input') .val(@model.get('description'))
    $(@el).find('.x input')           .val(@model.get('time_step'))
    $(@el).find('.y input')           .val(@model.get('nb_time_steps'))
    $(@el).find('.y input')           .val(@model.get('final_time'))
    $(@el).find('.ft input')          .val(@model.get('final_time'))
          

  hide: ->
    $(@el).hide()
  show: ->
    $(@el).show()

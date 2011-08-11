window.StepView = Backbone.View.extend({
  initialize: ->
    this.render()
    updateModelViewFinalTime = _.bind( ->
      this.model.updateFinalTime()
      this.updateFinalTime()        
    , this)
    
    this.model.bind('change:initial_time', updateModelViewFinalTime)
    this.model.bind('change:time_step', updateModelViewFinalTime)
    this.model.bind('change:nb_time_steps', updateModelViewFinalTime)
  ,
  tagName   : "tr"
  events: {
    "change .name input" : "updateName",
    "change .initial_time input" : "updateInitialTime",
    "change .time_step input" : "updateTimeStep",
    "change .nb_time_steps input" : "updateNbTimeStep"
  },
  render : ->
    htmlString = """
              <td class="name">
                <input type='text' value='#{this.model.get("name")}'> 
              </td> 
              <td class="initial_time">
                <input type='text' value='#{this.model.get("initial_time")}'> 
              </td> 
              <td class="time_step"> 
                <input type='text' value='#{this.model.get("time_step")}'> 
              </td> 
              <td class="nb_time_steps">
                <input type='text' value='#{this.model.get("nb_time_steps")}'> 
              </td> 
              <td class="final_time">
                <input type='text' value='#{this.model.get("final_time")}' disabled> 
              </td> 
          """
    $(this.el).html(htmlString)
    $('#step_table tbody').append(this.el)
    return this
  ,
  updateName: ->
    this.model.set( {
      name          : $(this.el).find('.name input').val()
    })
    this.updateFinalTime()
  updateInitialTime: ->
    this.model.set( {
      initial_time  : parseInt($(this.el).find('.initial_time input').val())
    })
  updateTimeStep: ->
    this.model.set( {
      time_step     : parseInt($(this.el).find('.time_step input').val())
    })

  updateNbTimeStep: ->
    this.model.set( {
      nb_time_steps : parseInt($(this.el).find('.nb_time_steps input').val())
    })
  updateFinalTime: ->
    $(this.el).find('.final_time input').val(this.model.get('final_time'))

})

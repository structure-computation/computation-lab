$ ( ->
  
  steps = new Steps(new Step({
    name          : "First step",
    initial_time  : 0,
    time_step     : 1,
    nb_time_steps : 1,
    final_time    : 1  
  }))
  
  $("#add_step").click( ->
    steps.add([{
      name          : "First step",
      initial_time  : 0,
      time_step     : 1,
      nb_time_steps : 1,
      final_time    : 1  
    }])
  )
  window.Calcul = Backbone.Model.extend ({
    initialize: ->
      company_id             = location.pathname.match(/\/companies\/([0-9]+)\/*/)[1]
      this.selectedMaterials = []
      this.selectedLinks     = []
      this.steps             = [] 
  })
)

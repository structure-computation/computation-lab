## VolumicForceListView

# TODO: Le render doit réagir à l'ajout ou la suppression d'un élément de la collection.
SCVisu.VolumicForceListView = Backbone.View.extend
  # el: 'table#volumic_force_table > tbody'
  el: '#volumic_forces'
  ## -- Events
  events:
    'click button#add_volumic_force'   : 'addVolumicForce'
  
  # A VolumicForceListView is use to render and populate a table of "VolumicForces" (weight, centrifugal accelleration, accelleration...).
  # Each model of this collection is declared "not selected" when initialized. 
  initialize: ->
    # Set all models unselected
    @collection.each( (model)-> model.unset('selected') )
    @selectedVolumicForce = null
    
    # Bind to collection event
    @collection.bind('add'   , this.render, this)
    @collection.bind('remove', this.render, this)
    
    @render()
        
  # setNewSelectedModel is executed when a child view indicate it has been selected.
  # It set the current selected model to "non selected" (which trigger an event that redraw its line).

  setNewSelectedModel: (volumicForceView) ->
    @selectedVolumicForce.unset "selected"   if @selectedVolumicForce
    @selectedVolumicForceView = volumicForceView
  
  
  render : ->
    vf_table = $(@el).find("#volumic_force_table_content") 
    vf_table.empty()
    parent   = this
    @collection.each ( volumicForce ) ->
      subview = new SCVisu.VolumicForceView model: volumicForce, parentElement: parent
      subview.render()
      vf_table.append(subview.el)

    return this

  ## Create add a new volumic_force model and view.
  addVolumicForce: ->  
    newVolForce = new SCVisu.VolumicForce
    @collection.add newVolForce
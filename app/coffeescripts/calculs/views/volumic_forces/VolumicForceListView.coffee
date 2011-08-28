## VolumicForceListView
SCVisu.VolumicForceListView = Backbone.View.extend
  el: 'ul#pieces'
  
  # A VolumicForceListView is use to render and populate a table of "VolumicForces" (weight, centrifugal accelleration, accelleration...).
  # It is created with a VolumicForceCollection as follow:
  # new SCVisu.volumicForceListView({ collection : myVolumicForceListView })
  # Each model of this collection is used to make a single VolumicForceView
  initialize: ->
    @volumicForceViews = []
    for volumicForce in @collection.models
      @volumicForceViews.push new SCVisu.VolumicForceView model: volumicForce, parentElement: this
    @selectedVolumicForceView = null
    @render()
        
  # selectLine is executed when user click on a line (here a VolumicForce).
  # Highlight the selected line and put others in gray.
  # In the case of VolumicForce, the user has the right to delete it.
  selectLine: (volumicForceView) ->
    @selectedVolumicForceView = volumicForceView
    
    _.each @VolumicForceViews, (lineView) ->                  # For each line :
      $(lineView.el).addClass('gray').removeClass('selected') # supress the "selected" class and add the "gray" class
    
    # and do the reverse only for the selected line.
    $(volumicForceView.el).addClass('selected').removeClass('gray')
    # TODO: show details

    
  render : ->
    _.each @volumicForceViews, (volumicForce) ->
      volumicForce.render()
    return this

# Piece View
SCVisu.VolumicForceView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
    @firstRendering = true
    
  tagName   : "li"                    # TODO: plutôt une table row ?
  className : "volumic_force_view"    # TODO: add to style.

  events: 
    'click'                 : 'select'
    'click button.destroy'  : 'destroyVolumicForce'

    
  # Highlight the selected line and tell the volumic force list to 
  # show the details of this line.
  select: (event) ->
    if event.srcElement == @el
      @parentElement.selectPiece @

  destroyVolumicForce: (event) ->
    if event.srcElement == @el # est-ce necessaire ?
      @model.destroy()
    
  # Render with an action button
  renderWithButton: (className, textButton)->
    $(@el).html(@model.get('name'))
    $(@el).append("<button class='#{className}'>#{textButton}</button>")
    return this

  render: ->
    if @firstRendering
      $(@parentElement.el).append(@el)
      @firstRendering = false
    $(@el).html(@model.get('name'))
    $(@el).removeClass('selected').removeClass('gray')
    return this


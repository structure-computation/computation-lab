# Piece View
SCViews.VolumicForceView = Backbone.View.extend
  initialize: (params) ->
    @parentElement  = params.parentElement  # La vue tableau comportant la ligne crée et gérée par cet objet vue.
    # @model.bind('change', this.render, this) Ne fonctionne pas dans la pratique : fait perdre le focus sur les champs input.
    @model.bind('change:selected', @showSelectedState, this)
    
  tagName   : "tr"                    # TODO: plutôt une table row ?
  className : "volumic_force_view"    # TODO: add to style.

  events: 
    'click'                 : 'select'
    'click button.destroy'  : 'destroyVolumicForce'
    'keyup'                 : 'updateFields'
    'change'                : 'updateFields'
    'click button.remove'   : 'removeVolumicForce'
    
  removeVolumicForce: ->
    if confirm "Êtes-vous sûr ?"
      @parentElement.collection.remove @model
      @remove()

  # Ask the parent table to supress the "selected" status on the currently selected model
  # (which trigger a change:selected event that supress highlight on this line) and set 
  # the "selected" attribute on current model, which trigger again a change:selected event
  # which is handled by highlight the selected line.
  select: (event) ->
    # if event.srcElement == @el # Utilisé pour savoir si l'on clique sur le bouton ou la ligne.
      @parentElement.setNewSelectedModel(@model)
      @model.set({selected:true}) 

  # this functions set or unset CSS classes indicating a line is (or is not) selected.
  # It is called either by hand (in render) or in a change:selected event on the model.
  showSelectedState  : (event) ->
    if ( @model.get('selected') )
      $(@el).addClass(   'selected').removeClass('gray')
    else
      $(@el).removeClass('selected').removeClass('gray')
    
  # As named...
  destroyVolumicForce: (event) ->
    if event.srcElement == @el # est-ce necessaire ?
      @model.destroy()


  render: ->
    template = """
              <td class="name" > <input type='text'   value='#{@model.get("name")}'  > </td> 
              <td class="gamma"> <input type='text'   value='#{@model.get("gamma")}' > </td>                 
              <td class="dx"   > <input type='text'   value='#{@model.get("dx")}'    > </td> 
              <td class="dy"   > <input type='text'   value='#{@model.get("dy")}'    > </td> 
              <td class="dz"   > <input type='text'   value='#{@model.get("dz")}'    > </td> 
              <td              > <button class="remove">X</button>                     </td> 
          """ 
    $(@el).html(template) 
    @showSelectedState()  

    
    return this
    
  updateFields: (event) ->
    nameValue    = $(@el).find('.name  input').val()
    gammaValue   = $(@el).find('.gamma input').val()
    dxValue      = $(@el).find('.dx    input').val()
    dyValue      = $(@el).find('.dy    input').val()
    dzValue      = $(@el).find('.dz    input').val()
    @model.set {name: nameValue, gamma: gammaValue, dx: dxValue, dy: dyValue, dz: dzValue } 


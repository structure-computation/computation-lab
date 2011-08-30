# Piece View
SCModels.VolumicForceView = Backbone.View.extend
  initialize: (params) ->
    @parentElement  = params.parentElement  # La vue tableau comportant la ligne crée et gérée par cet objet vue.
    @model.bind('change', this.render, this)
    
  tagName   : "tr"                    # TODO: plutôt une table row ?
  className : "volumic_force_view"    # TODO: add to style.

  events: 
    'click'                 : 'select'
    'click button.destroy'  : 'destroyVolumicForce'
    'keyup'                 : 'updateFields'
    'change'                : 'updateFields'
    
  # Ask the parent table to supress the "selected" status on the currently selected model
  # (which trigger a onchange that supress highlight on this line) and set the "selected" attribute
  # on current model, which trigger a new render and higlight the model. 
  # Highlight the selected line and tell the volumic force list to 
  # show the details of this line.
  select: (event) ->
    # if event.srcElement == @el # Utilisé pour savoir si l'on clique sur le bouton ou la ligne.
      @parentElement.setNewSelectedModel(@model)
      @model.set({selected:true}) 

  destroyVolumicForce: (event) ->
    if event.srcElement == @el # est-ce necessaire ?
      @model.destroy()

  render: ->
    template = """
              <td class="name" > <input type='text'   value='#{@model.get("name")}'  > </td> 
              <td class="gamma"> <input type='number' value='#{@model.get("gamma")}' > </td>                 
              <td class="dx"   > <input type='number' value='#{@model.get("dx")}'    > </td> 
              <td class="dy"   > <input type='number' value='#{@model.get("dy")}'    > </td> 
              <td class="dz"   > <input type='number' value='#{@model.get("dz")}'    > </td> 
          """ 
    $(@el).html(template) 
      
    if ( @model.get('selected') )
      $(@el).addClass(   'selected').removeClass('gray')
    else
      $(@el).removeClass('selected').removeClass('gray')
    
    return this
    
  updateFields: (event) ->
    nameValue    = $(@el).find('.name  input').val()
    gammaValue   = $(@el).find('.gamma input').val()
    dxValue      = $(@el).find('.dx    input').val()
    dyValue      = $(@el).find('.dy    input').val()
    dzValue      = $(@el).find('.dz    input').val()
    @model.set {name: nameValue, gamma: gammaValue, dx: dxValue, dy: dyValue, dz: dzValue }

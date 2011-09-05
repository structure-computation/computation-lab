SCViews.CalculView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
  
  tagName   : "tr"
  className : "calcul_view" 
  
  events:
    "click"                         : "selectCalcul"
    "click button.rename"           : "renameCalcul"
    "click button.delete"           : "deleteCalcul"
  
  
  deleteCalcul: (event) ->
    that = this
    @model.destroy(
      error: ->
        alert "An error occured during suppression..."
      success: ->
        that.remove()
    )
    
  renameCalcul: (event) ->
    if $(event.srcElement).hasClass('validateRenaming')
      @model.set name: $(@el).find('.name input').val()
      @model.save()
      $(@el).find('.name').html "#{@model.get('name')}"
      $(event.srcElement).html("Renommer").removeClass('validateRenaming')
    else
      $(@el).find('.name').html("<input type='text' value='#{@model.get('name')}' />")
      $(@el).find('.name input').focus()
      $(event.srcElement).html("Valider").addClass('validateRenaming')
    
  # Calls the parent's method to select a calcul 
  selectCalcul: ->
    @parentElement.selectCalcul this
    
  render: ->
    template = """
      <td>#{@model.get('id')}</td>
      <td class="name">#{@model.get('name')}</td>
      <td>#{if @model.get('state') == 'temp' then 'Brouillon' else 'Lancé'} </td>
      <td>
        <button class="rename">Renommer</button>
        <button class="delete">Supprimer</button>
      </td>
    """
    $(@el).html(template)
    $(@parentElement.el).find('tbody').append(@el)
    return this



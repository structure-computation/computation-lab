SCViews.CalculView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@parentElement.el).find('tbody').append(@el)
    
  tagName   : "tr"
  className : "calcul_view" 
  
  events:
    "click"                         : "selectCalcul"
    "click button.delete"           : "deleteCalcul"
    "click button.duplicate"        : "duplicateCalcul"
  
  # Delete the calcul from the database
  deleteCalcul: (event) ->
    if confirm "Êtes-vous sûr ?"
      that = this
      @model.destroy(
        error: ->
          alert "An error occured during suppression..."
        success: ->
          that.remove()
      )
    
  # Calls the parent's method to select a calcul 
  selectCalcul: ->
    $('#visu_calcul').hide()
    @parentElement.selectCalcul this
    @parentElement.calculInformationView.setCalculView this
    
  # Calls the parent's method to select a calcul 
  duplicateCalcul: ->
    $('#visu_calcul').hide()
    @parentElement.duplicateCalcul this
    
  render: ->
    template = """
      <td>#{@model.get('id')}</td>
      <td class="name">#{@model.get('name')}</td>
      <td>#{if @model.get('state') == 'temp' then 'Brouillon' else 'Lancé'} </td>
      <td>
        <button class="delete">Supprimer</button>
        <button class="duplicate">Dupliquer</button>
      </td>
    """
    $(@el).html(template)
    return this



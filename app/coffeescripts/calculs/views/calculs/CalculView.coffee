SCViews.CalculView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
    $(@parentElement.el).find('tbody').append(@el)
    
  tagName   : "tr"
  className : "calcul_view" 
  
  events:
    "click"                         : "selectCalcul"
    "click button.delete"           : "deleteCalcul"
  
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
    
  render: ->
    template = """
      <td>#{@model.get('id')}</td>
      <td class="name">#{@model.get('name')}</td>
      <td>#{if @model.get('state') == 'temp' then 'Brouillon' else 'Lancé'} </td>
      <td>
        <button class="delete">Supprimer</button>
      </td>
    """
    $(@el).html(template)
    return this



SCViews.CalculView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
    
    # Creates a row right after itself containing its description
    after = """
      <tr>
        <td>
          <button class="edit_information">Editer</button>
        </td>
        <td class='description' colspan="3">
          #{@model.get('description')}
        </td>
      </tr>
    """
    $(@parentElement.el).find('tbody').append(@el)
    $(@el).after(after)
    $(@el).next().hide()
    
    # Click handler for the description edit button
    $(@el).next().find('button.edit_information').click( =>
      # When user validate
      if $(@el).next().find('button.edit_information').hasClass('confirm')
        @model.set description : $(@el).next().find('td.description textarea').val()
        @model.save("update_db_info" : "true")
        $(@el).next().find('td.description').html "#{@model.get('description')}"
        $(@el).next().find('button.edit_information').html("Editer").removeClass("confirm")
        
      # When user edit
      else
        $(@el).next().find('td.description').html """
          <textarea rows="5" cols="50">#{@model.get('description')}</textarea>
        """
        $(@el).next().find('td.description textarea').focus() # Set the focus to the textarea 
        $(@el).next().find('button.edit_information').html("Valider").addClass("confirm")

    )
  
  tagName   : "tr"
  className : "calcul_view" 
  
  events:
    "click"                         : "selectCalcul"
    "click button.rename"           : "renameCalcul"
    "click button.delete"           : "deleteCalcul"
    "click button.information"      : "toggleInfo"
  
  
  toggleInfo: (event) ->
    $(@el).next().toggle()
    if $(@el).next().is(':visible')
      $(event.srcElement).html('Cacher les informations')
    else
      $(event.srcElement).html('Montrer les informations')

  # Delete the calcul from the database
  deleteCalcul: (event) ->
    that = this
    @model.destroy(
      error: ->
        alert "An error occured during suppression..."
      success: ->
        that.remove()
    )
    
  # Let the user rename the calcul selected by adding an input fields
  # The model is kept to date and is saved in the database.
  renameCalcul: (event) ->
    if $(event.srcElement).hasClass('validateRenaming')
      @model.set name: $(@el).find('.name input').val()
      @model.save("update_db_info" : "true")
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
        <button class="information">Montrer les informations</button>
      </td>
    """
    $(@el).html(template)
    return this



SCViews.CalculInformation = Backbone.View.extend
  el: "#calcul_information"

  initialize: (params) ->
    @currentCalcul        = null
    @isEditingDescription = false
    @isRenaming           = false
  
  events:
    "click .edit_name"        : "editName"
    "click .edit_description" : "editDescription"
    
  # Replaces the name by an input for editing the name
  # Saves the model when the user click on the save button
  editName: ->
    @isRenaming = !@isRenaming
    if @isRenaming
      $(@el).find('.edit_name').html('Sauver')
      $(@el).find('.name').html "<input size='40' type='text' value='#{@currentCalcul.get('name')}' />"
      $(@el).find('.name input').focus()
    else
      $(@el).find('.edit_name').html('Renommer')
      # Silent because the name is saved in the database and if the calcul is not loaded
      @currentCalcul.set {name: $(@el).find('.name input').val()}, {silent: true}
      @currentCalcul.save({"update_db_info" : "true"}, {silent: true}) # Saves in databbase
      @calculView.render()
      @render()
      
  # Replaces the description by a text area to let the user modify the model description
  # Saves the model when the user click on the save button
  editDescription: ->
    @isEditingDescription = !@isEditingDescription
    if @isEditingDescription
      $(@el).find('.edit_description').html('Sauver')
      $(@el).find('.description').html """
        <textarea rows="5" cols="10">#{@currentCalcul.get('description')}</textarea>
      """
    else
      $(@el).find('.edit_description').html('Editer')
      @currentCalcul.set description : $(@el).find('.description textarea').val()
      @currentCalcul.save("update_db_info" : "true")
      @render()
  
  # Set the current model
  setCalculView: (calculView) ->
    @calculView = calculView
    @currentCalcul = calculView.model
    @render()
  
  # Render the calcul details
  render: ->
    $(@el).show()
    $(@el).find('.id')          .html @currentCalcul.get('id')
    $(@el).find('.name')        .html @currentCalcul.get('name')
    $(@el).find('.status')      .html if @currentCalcul.get('state') == 'temp' then 'Brouillon' else 'Lancé'
    $(@el).find('.description') .html @currentCalcul.get('description')
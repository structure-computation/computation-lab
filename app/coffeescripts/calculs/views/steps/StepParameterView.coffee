SCViews.StepParameterView = Backbone.View.extend
  ## @params: Option
  ##    model:          Model of the Step directly bind to the StepView
  ##    parentElement: ListView object. Useful to get its element and be able to update all models when a step is removed
  initialize:  (options)->
    @parentElement = options.parentElement
    @render()
    $(@parentElement.el).find('tbody#parameters').append(@el)

  tagName   : "tr"

  render : ->
    template = _.template """
              <td class="id_param">
                <input type='text' value='<%= id_param %>' disabled> 
              </td> 
              <td class="name">
                <input type='text' value='<%= name %>' disabled> 
              </td> 
              <td class="alias_name"> 
                <input type='text' value='<%= alias_name %>'> 
              </td> 
              <td>
                <button class='edit'>Editer</button>
              </td> 
              <td>
                <button class='delete'>X</button>
              </td> 
          """

    $(@el).html template
      id_param      : @model.get('id_param')
      name          : @model.get('name')
      alias_name    : @model.get('alias_name')      
      
    return this

  updateAliasName: ->
    @model.set alias_name : $(@el).find('.alias_name input').val()
      
  update: ->
    $(@el).find('.alias_name input')    .val(@model.get('name'))
    
    
  ## -- Events
  events: 
    'click button.delete' : 'delete'
    'click button.edit'   : 'edit'

  # Show the edit part
  edit: ->
    @parentElement.showDetails(@model)
    # Trigger selection change only when the material selected change because it
    # makes lose the focus
    $('#visu_calcul').hide()  
    
    
  delete: (withoutPrompting = false)->
    if withoutPrompting
      @model.destroy()
      SCVisu.current_calcul.trigger 'change'
      @remove()
    else if confirm "Êtes-vous sûr ?"
      @model.destroy()
      SCVisu.current_calcul.trigger 'change'
      @remove()
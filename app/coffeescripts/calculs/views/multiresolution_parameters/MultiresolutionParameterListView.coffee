SCViews.MultiresolutionParameterListView = Backbone.View.extend

  el: "#multiresolution_parameters"

  # Init the list with the new collection.
  # The init method is here to prevent having multiple reference of a step list view
  init: (collection) ->
    @parameterViews = []
    @clearView()
    @collection = collection
    
    multiresolution_type = SCVisu.current_calcul.get('multiresolution_parameters').multiresolution_type
    @collection.meta 'multiresolution_type', multiresolution_type
    if multiresolution_type == "fatigue"
      $(@el).find('button.add').attr('disabled','disabled')
    else
      $(@el).find('button.add').removeAttr('disabled')
    $(@el).find('select#multiresolution_type').val(multiresolution_type)

    @collection.bind "add", (model) =>
      @parameterViews.push new SCViews.MultiresolutionParameterView model: model, parentElement: this

    if @collection.size() == 0
      @collection.add new SCModels.MultiresolutionParameter()
      
    @render()
    

  events:
    "click button.add"                   : "addParameter"
    "change select#multiresolution_type" : "selectChanged"

  addParameter: ->
    @collection.add new SCModels.MultiresolutionParameter()

  selectChanged: (event) ->
    if $(event.srcElement).val() == "fatigue"
      if confirm "Êtes-vous sûr ? Cela va effacer tous vos paramêtre (sauf le premier)."
        $(@el).find('button.add').attr('disabled','disabled')
        # Delete all except first element
        if @parameterViews.length > 1
          for i in [1..@parameterViews.length - 1]
            @parameterViews[i].delete(true)
        $(@el).find("button.add").attr('disabled', 'disabled')
      else
        $('#multiresolution_type').val('expert_plan')
    else
      $(@el).find("button.add").removeAttr('disabled')
    SCVisu.current_calcul.trigger 'change'  
    SCVisu.current_calcul.setMultiresolutionParameterType $('#multiresolution_type').val()
    SCVisu.current_calcul.setMultiresolutionParameterCollection @collection.models
    


  # Clears all elements previously loaded in the DOM. 
  # Indeed, the 'ul#materials' element already exists in the DOM and every time we create a MaterialListView, 
  # we render the view and we add some element inside. And even if we have many different view, 
  # each time we render we add elements to the same view. 
  # So we have to clear the content each time we create a new MaterialListView 
  clearView: ->
    $(@el).find('table tbody').html('')

  render: ->
    for view in @parameterViews
      view.render()
    $(@parameterViews[0].el).find('button.delete').remove() if @parameterViews[0]

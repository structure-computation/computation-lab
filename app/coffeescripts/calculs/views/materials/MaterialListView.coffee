## Old Material List View - Appears in a table
# ## MaterialListView
# window.MaterialListView = Backbone.View.extend
#   el: '#materials_table'
# 
#   initialize: (options) ->
#     @bind 'material_added', @add_selected_material, this
#     @materialViews = []
#     @localMaterialList = new SelectedMaterialListView
#     window.localMaterialList = @localMaterialList
#     for material in @collection
#       @materialViews.push new MaterialView model: material, parentElement: this
#     @render()
# 
#   render : ->
#     for materialView in @materialViews
#       materialView.render()
#       
#   add_selected_material: (material) ->
#     @localMaterialList.add_material material


## MaterialListView
window.MaterialListView = Backbone.View.extend
  el: 'ul#materials'

  initialize: (options) ->
    @render()
    
  render : ->
    for material in @collection.models
      $(@el).append("<li data-id='#{material.get('id')}'>#{material.get('name')}</li>")
    return this

  events: 
    "click li" : "showDetails"

  showDetails: (event) ->
    materialId = parseInt($(event.srcElement).attr("data-id"))
    for material in @collection.models
      if material.get('id') == materialId
        @editView = new EditMaterialView model: material,  parentElement: this
        break
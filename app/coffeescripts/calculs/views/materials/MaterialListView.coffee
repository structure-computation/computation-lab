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
    @editView = new EditMaterialView parentElement: this
    @materialViews = []
    for material in @collection.models
      @createMaterialView(material)
    @render()

  createMaterialView: (material) ->
    m = new MaterialView model: material, parentElement: this
    m.bind 'update_details_model', @update_details, this
    @materialViews.push m
    
  update_details: (model) ->
    @editView.updateModel model   

  render : ->
    for m in @materialViews
      m.render()
    return this

 
## MaterialListView
window.MaterialListView = Backbone.View.extend
  el: '#materials_table'

  initialize: (options) ->
    @bind 'material_added', @add_selected_material, this
    @materialViews = []
    @localMaterialList = new SelectedMaterialListView
    window.localMaterialList = @localMaterialList
    for material in @collection
      @materialViews.push new MaterialView model: material, parentElement: this
    @render()

  render : ->
    for materialView in @materialViews
      materialView.render()
      
  add_selected_material: (material) ->
    @localMaterialList.add_material material

SCVisu.SelectedMaterialListView = Backbone.View.extend
  el: '#materials_selected_table'

  initialize: (options) ->
    @bind 'materialRemoved', @remove_selected_material, this
    @bind 'editMaterial', @edit_selected_material, this
    @editMaterialView = new EditMaterialView parentElement: this
    @materialViews = []

  render : ->
    for materialView in @materialViews
      materialView.render()    
  
  edit_selected_material: (material) ->
    @editMaterialView.updateModel material
    
  add_material: (material) ->
    m = material.clone()
    m.set({name: m.get('name') + ' - copy'})
    @materialViews.push new SelectedMaterialView model: m, parentElement: this
    @render()
  
  remove_selected_material: (material) ->
    for materialView, i in @materialViews
      if materialView.model == material
        @materialViews.splice(i, 1)
        materialView.remove()
        @render()
        break
    
    
## MaterialListView
window.MaterialListView = Backbone.View.extend
  el: '#materials_table'

  initialize: (options) ->
    @bind 'material_added', @add_selected_material, this
    @materialViews = []
    @localMaterialList = new MaterialLocalListView
    window.localMaterialList = @localMaterialList
    for material in @collection
      @materialViews.push new MaterialView model: material, parentElement: this
    @render()

  render : ->
    for materialView in @materialViews
      materialView.render()
      
  add_selected_material: (material) ->
    @localMaterialList.add_material material

window.MaterialLocalListView = Backbone.View.extend
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
    
# Material View
window.MaterialView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
 
  tagName   : "tr"
 
  events:
    "click .add": "add_selected_material"
  
  add_selected_material: ->
    @parentElement.trigger 'material_added', @model
    @parentElement.render()
  
  render: ->
    htmlString = """
              <td class="name">
                #{@model.get("name")}
              </td>
              <td class="family">
                #{@model.get("family")}
              </td>
              <td>
                <button class="add">+</button>
              </td>
          """
    $(@el).html(htmlString)
    $("#materials_table tbody").append(@el)
    return this
    
# Material View
window.SelectedMaterialView = Backbone.View.extend
  initialize: (params) ->
    @parentElement = params.parentElement
    
  tagName   : "tr"
 
  events:
    "click .remove" : "remove_selected_material"
    "click .edit"   : "edit_selected_material"
  
  edit_selected_material: ->
    @parentElement.trigger 'editMaterial', @model
    
  remove_selected_material: ->
    @parentElement.trigger 'materialRemoved', @model
    @parentElement.render()
  
  render: ->
    htmlString = """
              <td class="name">
                #{@model.get("name")}
              </td>
              <td class="family">
                #{@model.get("family")}
              </td>
              <td>
                <button class="edit">Edit</button>
              </td>
              <td>
                <button class="remove">-</button>
              </td>

          """
    $(@el).html(htmlString)
    $("#materials_selected_table tbody").append(@el)
    return this

window.EditMaterialView = Backbone.View.extend
  el: "#edit_material"
  initialize: (params) ->
    @parentElement = params.parentElement
    
  events: 
    'keyup': 'updateModelAttributes'

  updateModel: (model) ->
    @model = model
    @render()
    
  updateModelAttributes: ->
    for input in $(@el).find('input, textarea')
      key = $(input).attr('id').split('material_')[1]
      value = $(input).val()
      h = new Object()
      h[key] = value
      @model.set h
    @parentElement.render()
    
  render: ->
    for input in $(@el).find('input, textarea')
      $(input).val(@model.get($(input).attr('id').split("material_")[1]))


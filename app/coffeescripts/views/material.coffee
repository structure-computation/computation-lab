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
    @bind 'material_added', @add_selected_material, this
    @bind 'material_removed', @remove_selected_material, this
    @materialViews = []

  render : ->
    for materialView in @materialViews
      materialView.render()    
      
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
    "click .remove": "remove_selected_material"
  
  remove_selected_material: ->
    @parentElement.trigger 'material_removed', @model
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
    @model.set name:          $(@el).find('#link_name')       .val()
    @model.set description:   $(@el).find('#link_description').val()
    @model.set Ep:            $(@el).find('#link_Ep')         .val()
    @model.set jeu:           $(@el).find('#link_jeu')        .val()
    @model.set R:             $(@el).find('#link_R')          .val()
    @model.set Lp:            $(@el).find("#link_Lp")         .val()
    @model.set Dp:            $(@el).find("#link_Dp")         .val()
    @model.set p:             $(@el).find("#link_p")          .val()
    @model.set Lr:            $(@el).find("#link_Lr")         .val()
    @model.set f:             $(@el).find("#link_f")          .val()

    @parentElement.render()
    
  render: ->
    $(@el).find('#link_name')         .val(@model.get("name"))
    $(@el).find('#link_description')  .val(@model.get("description"))
    $(@el).find('#link_Ep')           .val(@model.get("Ep"))
    $(@el).find('#link_jeu')          .val(@model.get("jeu"))
    $(@el).find('#link_R')            .val(@model.get("R"))
    $(@el).find("#link_Lp")           .val(@model.get("Lp"))
    $(@el).find("#link_Dp")           .val(@model.get("Dp"))
    $(@el).find("#link_p")            .val(@model.get("p"))
    $(@el).find("#link_Lr")           .val(@model.get("Lr"))
    $(@el).find("#link_f")            .val(@model.get("f"))

# Selected Material View
SCVisu.SelectedMaterialView = Backbone.View.extend
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


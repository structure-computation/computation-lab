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



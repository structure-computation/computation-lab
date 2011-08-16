## MaterialListView
window.MaterialListView = Backbone.View.extend
  tagName: 'table'
  className: 'grey'
  id: 'materials_table'

  initialize: (options) ->
    @materialViews = []
    for material in @collection
      @materialViews.push new MaterialView model: material
    @render()

  render : ->
    htmlString = """
         <thead> 
            <tr class='no_sorter'> 
              <th>Nom</th> 
            </tr> 
          </thead> 
          <tbody></tbody>
    """
    $(@el).html(htmlString)
    $('#content').append(@el)
    for materialView in @materialViews
      materialView.render()



## Material View
window.MaterialView = Backbone.View.extend
  tagName   : "tr"
  render: ->
    htmlString = """
              <td class="name">
                #{@model.get("name")}
              </td> 
          """
    $(@el).html(htmlString)
    $("#materials_table tbody").append(@el)
    return this
## LinkListView
window.LinkListView = Backbone.View.extend
  tagName: 'table'
  className: 'grey'
  id: 'links_table'

  initialize: (options) ->
    @linkViews = []
    for link in @collection
      @linkViews.push new LinkView model: link
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
    for linkView in @linkViews
      linkView.render()



## Link View
window.LinkView = Backbone.View.extend
  tagName   : "tr"
  render: ->
    htmlString = """
              <td class="name">
                #{@model.get("name")}
              </td> 
          """
    $(@el).html(htmlString)
    $("#links_table tbody").append(@el)
    return this
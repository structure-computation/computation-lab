## PieceListView
window.PieceListView = Backbone.View.extend
  el: 'ul#pieces'
  
  # You have to pass a PieceCollection at initialisation as follow:
  # new PieceListView({ collection : myPieceCollection })
  initialize: (options) ->
    @render()
    
  render : ->
    for piece in @collection.models
      $(@el).append("<li>#{piece.get('name')}</li>")
    return this

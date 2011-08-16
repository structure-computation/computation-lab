window.MaterialView = Backbone.View.extend
  tagName   : "li"
  
  initialize: ->
    console.log @model
    @model.bind('change', @render, this)
    
  render: ->
    $(@el).html(@model.get('name'))
    @setContent()
    this

  setContent: ->
      name = @model.get('name')
      this.$('#materials_list').text(name)
      
      
window.MaterialsListView = Backbone.View.extend
  initialize: ->
    _.bindAll this, 'addOne', 'addAll'

    @collection
      .bind('add',      @addOne)
      .bind('refresh',  @addAll)

    @list = @el.find '#materials_list'

  addOne: (material, collection) ->

    index    = collection.indexOf material
    node     = new MaterialView(model: material).render().el
    children = @list.children()

    if index == children.length
      @list.append node
    else
      children.eq(index).before node

  addAll: ->
    @list.children().remove()
    @collection.each (item) => @addOne item, @collection
window.MaterialView = Backbone.View.extend({
  initialize: ->
    $('#materials_list').append(this.el)
    this.render()
  ,
  tagName   : "li"
  events: {
    "click" : "youhou"
  },
  youhou: ->
    alert this.cid
  ,
  render:  ->
    $(this.el).text("#{this.model.get('name')}")
    return this
})
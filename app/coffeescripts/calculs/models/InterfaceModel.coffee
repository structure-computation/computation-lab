window.Interface = Backbone.Model.extend
  initialize: (interface) ->
    @group            = interface.group        
    @name             = interface.name         
    @origine          = interface.origine      
    @assigned         = interface.assigned     
    @id               = interface.id           
    @type             = interface.type         
    @adj_num_group    = interface.adj_num_group
    @set      link_id : interface.link_id || 0 # When 0, link is not associated

window.Interfaces = Backbone.Collection.extend
  model: Interface
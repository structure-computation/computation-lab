window.Interface = Backbone.Model.extend
  initialize: (interface) ->
    @group         = interface.group        
    @name          = interface.name         
    @origine       = interface.origine      
    @assigned      = interface.assigned     
    @id            = interface.id           
    @type          = interface.type         
    @adj_num_group = interface.adj_num_group
  
window.Interfaces = Backbone.Collection.extend
  model: Interface
  initialize: (interfaceCollection)->
    @add new Interface {
            "group": -1
            "name": "piece 0"
            "origine": "from_bulkdata"
            "assigned": 0
            "id": 0
            "identificateur": 26
          }

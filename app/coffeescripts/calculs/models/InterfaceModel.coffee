# Interface
# Contains all attributes of an interface. 
# Attributes are retrieve from the model's JSON 
# Interfaces are not stored in the database, they belong to a model. 
SCVisu.Interface = Backbone.Model.extend
  initialize: (interface) ->
    @group            = interface.group        
    @name             = interface.name         
    @origine          = interface.origine      
    @assigned         = interface.assigned     
    @id               = interface.id           
    @type             = interface.type         
    @adj_num_group    = interface.adj_num_group
    @set      link_id : interface.link_id || 0 # When 0, link is not associated

# Collection of Interface
SCVisu.Interfaces = Backbone.Collection.extend
  model: SCVisu.Interface
  initialize: (interfaceCollection)->
    # Fake initialization
    @add new SCVisu.Interface {
            "group": -1
            "name": "piece 0"
            "origine": "from_bulkdata"
            "assigned": 0
            "id": 1
            "identificateur": 26
          }
    @add new SCVisu.Interface {
            "group": -1
            "name": "piece 1"
            "origine": "from_bulkdata"
            "assigned": 0
            "id": 2
            "identificateur": 26
          }
    @add new SCVisu.Interface {
            "group": -1
            "name": "piece 2"
            "origine": "from_bulkdata"
            "assigned": 0
            "id": 3
            "identificateur": 26
          }
    @add new SCVisu.Interface {
            "group": -1
            "name": "piece 3"
            "origine": "from_bulkdata"
            "assigned": 0
            "id": 4
            "identificateur": 26
          }

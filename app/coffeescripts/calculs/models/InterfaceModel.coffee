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
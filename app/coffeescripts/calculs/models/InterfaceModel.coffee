# Interface
# Contains all attributes of an interface. 
# Attributes are retrieve from the model's JSON 
# Interfaces are not stored in the database, they belong to a model. 
SCVisu.Interface = Backbone.Model.extend
  isAssigned: ->
    if _.isUndefined(@get("link_id")) then false else true


# Collection of Interface
SCVisu.Interfaces = Backbone.Collection.extend
  model: SCVisu.Interface
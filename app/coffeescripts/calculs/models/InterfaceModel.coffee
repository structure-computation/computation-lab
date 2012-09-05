# Interface
# Contains all attributes of an interface. 
# Attributes are retrieve from the model's JSON 
# Interfaces are not stored in the database, they belong to a model. 
SCModels.Interface = Backbone.Model.extend
  #initialize: ->
  #  @set "link_id" : -1 if _.isUndefined(@get("link_id"))
    
  isAssigned: ->
    !_.isUndefined(@get("link_id"))


# Collection of Interface
SCModels.Interfaces = Backbone.Collection.extend
  model: SCModels.Interface
  
  
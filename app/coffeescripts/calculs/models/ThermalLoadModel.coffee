# ThermalLoad
# A Thermal load is a temperature applied on all parts of the model
# Name : Name of this Thermal load (constant temperature... )
# Parameters is : function (value of temperaure / x,y,z,t,n)
SCModels.ThermalLoad = Backbone.Model.extend
  defaults: 
    name : "Constant"
    function:  "0"

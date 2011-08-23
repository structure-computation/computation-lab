# SCVisu is initialized in the header in order that it is initialize at first
# window.SCVisu = {} 
$ ->
  interfaceCollection = new SCVisu.Interfaces()
  SCVisu.interfaceListView = new SCVisu.InterfaceListView collection : interfaceCollection
  
  SCVisu.router = new SCVisu. Router
  Backbone.history.start()

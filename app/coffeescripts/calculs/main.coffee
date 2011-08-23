$ ->
  
  interfaceCollection = new Interfaces()
  window.interfaceListView = new InterfaceListView collection : interfaceCollection
  
  window.router = new Router
  Backbone.history.start()

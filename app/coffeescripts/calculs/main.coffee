$ ->
  
  window.initializeFromJSON = () ->
    # /!\ Le nom des variables suivantes ne doit pas être changé ! Ces variables sont appelées à plusieurs endroits /!\        
    # Creation of the pieceCollection from the JSON file
    window.pieceCollection = new PieceCollection window.current_calcul.get('brouillon').pieces
    window.pieceListView = new PieceListView collection : pieceCollection

    window.MaterialCollection = new Materials window.current_calcul.get('brouillon').materials
    window.MaterialViews = new MaterialListView collection: MaterialCollection
    
    window.Steps = new StepCollection window.current_calcul.get('brouillon').time_step
    window.StepsView = new StepListView collection: Steps
    
    window.Links = new Links window.current_calcul.get('brouillon').links
    window.LinksView = new LinkListView collection: Links
  
  interfaceCollection = new Interfaces()
  window.interfaceListView = new InterfaceListView collection : interfaceCollection
  
  window.router = new Router
  Backbone.history.start()

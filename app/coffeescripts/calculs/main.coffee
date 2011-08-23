# SCVisu is initialized in the header in order that it is initialize at first
# window.SCVisu = {} 
$ ->
  interfaceCollection = new SCVisu.Interfaces()
  SCVisu.interfaceListView = new SCVisu.InterfaceListView collection : interfaceCollection
  
  window.initializeFromJSON = () ->
    # /!\ Le nom des variables suivantes ne doit pas être changé ! Ces variables sont appelées à plusieurs endroits /!\        
    # Creation of the pieceCollection from the JSON file
    pieceCollection = new SCVisu.PieceCollection SCVisu.current_calcul.get('brouillon').pieces
    SCVisu.pieceListView = new SCVisu.PieceListView collection : pieceCollection

    MaterialCollection = new SCVisu.Materials SCVisu.current_calcul.get('brouillon').materials
    SCVisu.MaterialViews = new SCVisu.MaterialListView collection: MaterialCollection
    
    Steps = new SCVisu.StepCollection SCVisu.current_calcul.get('brouillon').time_step
    SCVisu.StepsView = new SCVisu.StepListView collection: Steps
    
    Links = new SCVisu.Links SCVisu.current_calcul.get('brouillon').links
    SCVisu.LinksView = new SCVisu.LinkListView collection: Links
  
  interfaceCollection = new SCVisu.Interfaces()
  SCVisu.interfaceListView = new SCVisu.InterfaceListView collection : interfaceCollection
  
  SCVisu.router = new SCVisu. Router
  Backbone.history.start()

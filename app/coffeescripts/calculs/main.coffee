# SCVisu is initialized in the header in order that it is initialize at first
# window.SCVisu = {} 
$ ->
  interfaceCollection = new SCVisu.Interfaces()
  SCVisu.interfaceListView = new SCVisu.InterfaceListView collection : interfaceCollection
  
  # Initialize all variables and views with data retrieved from the JSON sent by the "Visualisateur"
  # /!\ Variable's name must not be changed! They are used in multiple place in the code. /!\
  SCVisu.initializeFromJSON = () ->

    # Initialization of the PieceListView
    pieceCollection = new SCVisu.PieceCollection SCVisu.current_calcul.get('brouillon').pieces
    SCVisu.pieceListView = new SCVisu.PieceListView collection : pieceCollection

    # Initialization of the MaterialListView
    materialCollection = new SCVisu.MaterialCollection SCVisu.current_calcul.get('brouillon').materials
    SCVisu.materialListView = new SCVisu.MaterialListView collection: materialCollection

    # Initialization of the StepListView    
    steps = new SCVisu.StepCollection SCVisu.current_calcul.get('brouillon').time_step
    SCVisu.stepListView = new SCVisu.StepListView collection: steps
    
    # Initialization of the LinkListView
    links = new SCVisu.Links SCVisu.current_calcul.get('brouillon').links
    SCVisu.linkListView = new SCVisu.LinkListView collection: links
  
    interfaceCollection = new Interfaces SCVisu.current_calcul.get('brouillon').interfaces
    SCVisu.interfaceListView = new SCVisu.InterfaceListView collection : interfaceCollection
  
  # Initialization of the Router
  SCVisu.router = new SCVisu. Router
  # Force the redirection to first part of the wizard
  # Backbone.history.start() returns true when the url contains an anchor
  SCVisu.router.initialize() if Backbone.history.start()

# SCVisu is initialized in the header in order that it is initialize at first
# window.SCVisu = {} 
$ ->
  interfaceCollection = new SCVisu.Interfaces()
  SCVisu.interfaceListView = new SCVisu.InterfaceListView collection : interfaceCollection
  
  # Return an array without duplicate element. Check is done by the id of the element in the array.
  # When there is a duplicate element, keeps the element from the JSON
  # Params : Two arrays of element (each element must have an id)
  SCVisu.removeDuplicate = (arrayFromDatabase, arrayFromJSON) ->
    _.map arrayFromDatabase, (standardElement) ->
      for fromJSONElement in arrayFromJSON
        if standardElement.get('id') == fromJSONElement.id
          return fromJSONElement
        else
          return standardElement.attributes
  
  # Initialize all variables and views with data retrieved from the JSON sent by the "Visualisateur"
  # /!\ Variable's name must not be changed! They are used in multiple place in the code. /!\
  SCVisu.initializeFromJSON = () ->

    # Initialization of the PieceListView
    pieceCollection = new SCVisu.PieceCollection SCVisu.current_calcul.get('pieces')
    SCVisu.pieceListView = new SCVisu.PieceListView collection : pieceCollection

    # Initialization of the MaterialListView
    materials = SCVisu.removeDuplicate SCVisu.standardLibraryMaterial.models, SCVisu.current_calcul.get('materials')          
    materialCollection = new SCVisu.MaterialCollection
    materialCollection.add materials
    
    SCVisu.materialListView = new SCVisu.MaterialListView collection: materialCollection

    # Initialization of the LinkListView
    links = SCVisu.removeDuplicate SCVisu.standardLibraryLink.models, SCVisu.current_calcul.get('links')          
    linkCollection = new SCVisu.LinkCollection
    linkCollection.add links
    
    SCVisu.linkListView = new SCVisu.LinkListView collection: linkCollection

    # Initialization of the StepListView    
    steps = new SCVisu.StepCollection SCVisu.current_calcul.get('time_steps')
    SCVisu.stepListView = new SCVisu.StepListView collection: steps
  
    interfaceCollection = new Interfaces SCVisu.current_calcul.get('interfaces')
    SCVisu.interfaceListView = new SCVisu.InterfaceListView collection : interfaceCollection
  
  # Initialization of the Router
  SCVisu.router = new SCVisu. Router
  # Force the redirection to first part of the wizard
  # Backbone.history.start() returns true when the url contains an anchor
  SCVisu.router.initialize() if Backbone.history.start()

# SCVisu is initialized in the header in order that it is initialize at first
# window.SCVisu = {} 
$ ->
  interfaceCollection = new SCVisu.Interfaces()
  SCVisu.interfaceListView = new SCVisu.InterfaceListView collection : interfaceCollection
  
  # # Return an array without duplicate element. Check is done by the id of the element in the array.
  # # When there is a duplicate element, keeps the element from the JSON
  # # Params : Two arrays of element (each element must have an id)
  # SCVisu.removeDuplicate = (arrayFromDatabase, arrayFromJSON) ->
  #   # Retains only the elements of the standard library that are different from those contained in the JSON file.
  #   tmpArray = _.map arrayFromDatabase, (standardElement) ->
  #     for fromJSONElement in arrayFromJSON 
  #       if standardElement.get('id') == fromJSONElement.id
  #         return
  #       else
  #         return standardElement.attributes
  #   # Adds the array that containing all the elements which are in the JSON file
  #   tmpArray.push arrayFromJSON
  #   # Flattens the nested array in order to have only one depth and return this array
  #   _.flatten tmpArray
  
  
  # Initialize all variables and views with data retrieved from the JSON sent by the "Visualisateur"
  # /!\ Variable's name must not be changed! They are used in multiple place in the code. /!\
  SCVisu.initializeFromJSON = () ->

    # Initialization of the PieceListView
    pieceCollection           = new SCVisu.PieceCollection SCVisu.current_calcul.get('pieces')
    SCVisu.pieceListView      = new SCVisu.PieceListView collection : pieceCollection

    # Initialization of the MaterialListView
    SCVisu.standardLibraryMaterial.setAs('standard')
    SCVisu.companyLibraryMaterial.setAs ("company")
    standardMaterials         = SCVisu.standardLibraryMaterial.models
    companyMaterials          = SCVisu.companyLibraryMaterial.models
    jsonMaterials             = SCVisu.current_calcul.get('materials') 
    materialCollection        = new SCVisu.MaterialCollection
    materialCollection.add jsonMaterials
    materialCollection.add standardMaterials
    materialCollection.add companyMaterials
    
    SCVisu.materialListView   = new SCVisu.MaterialListView collection: materialCollection

    # Initialization of the LinkListView
    SCVisu.standardLibraryLink.setAs('standard')
    SCVisu.companyLibraryLink.setAs ("company")
    standardLinks         = SCVisu.standardLibraryLink.models
    companyLinks          = SCVisu.companyLibraryLink.models
    jsonLinks             = SCVisu.current_calcul.get('links') 
    linkCollection        = new SCVisu.LinkCollection
    linkCollection.add jsonLinks
    linkCollection.add companyLinks
    linkCollection.add standardLinks

    SCVisu.linkListView       = new SCVisu.LinkListView collection: linkCollection

    # Initialization of the StepListView    
    steps                     = new SCVisu.StepCollection SCVisu.current_calcul.get('time_steps')
    SCVisu.stepListView       = new SCVisu.StepListView collection: steps
  
    # Initialization of the InterfaceListView
    interfaceCollection       = new SCVisu.Interfaces SCVisu.current_calcul.get('interfaces')
    SCVisu.interfaceListView  = new SCVisu.InterfaceListView collection : interfaceCollection

    # Initialization of the EdgeListView
    SCVisu.edgeListView       = new SCVisu.EdgeListView()

    # Initialization of the OptionView
    SCVisu.optionView         = new SCVisu.OptionView()
    
  # Initialization of the Router
  SCVisu.router = new SCVisu. Router pushState: true
  # Force the redirection to first part of the wizard
  # Backbone.history.start() returns true when the url contains an anchor
  SCVisu.router.navigate "Initialization", true if Backbone.history.start()

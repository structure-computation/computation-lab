# SCVisu is initialized in the header in order that it is initialize at first
# window.SCVisu = {} 
$ ->
  interfaceCollection       = new SCModels.Interfaces()
  SCVisu.interfaceListView  = new SCModels.InterfaceListView collection : interfaceCollection

  # Initialize all variables and views with data retrieved from the JSON sent by the "Visualisateur"
  # /!\ Variable's name must not be changed! They are used in multiple place in the code. /!\
  SCVisu.initializeFromJSON = () ->

    # Initialization of the PieceListView
    pieceCollection           = new SCModels.PieceCollection SCVisu.current_calcul.get('pieces')
    SCVisu.pieceListView      = new SCModels.PieceListView collection : pieceCollection

    # Initialization of the MaterialListView
    materialCollection        = new SCModels.MaterialCollection SCVisu.current_calcul.get('materials')     
    SCVisu.materialListView   = new SCModels.MaterialListView collection: materialCollection
    # Initialize views for database materials
    for material in SCVisu.standardLibraryMaterial.models.concat SCVisu.companyLibraryMaterial.models
      el = $('#materials_table tbody tr#material_' + material.get("id"))
      new SCVisu.DatabaseMaterialView el: el, model: material, materialListView: SCVisu.materialListView

    # Initialization of the LinkListView
    linkCollection            = new SCModels.LinkCollection SCVisu.current_calcul.get('links') 
    SCVisu.linkListView       = new SCModels.LinkListView collection: linkCollection
    # Initialize views for database links
    for link in SCVisu.standardLibraryLink.models.concat SCVisu.companyLibraryLink.models
      el = $('#links_table tbody tr#link_' + link.get("id"))
      new SCVisu.DatabaseLinkView el: el, model: link, linkListView: SCVisu.linkListView

    # for link in SCVisu.companyLibraryLink.models
    #   el = $('#links_table tbody tr#link_' + link.get("id"))
    #   new SCVisu.DatabaseLinkView el:  el, model: link, linkListView: SCVisu.linkListView

    # Initialization of the StepListView    
    steps                     = new SCModels.StepCollection SCVisu.current_calcul.get('time_steps').collection
    SCVisu.stepListView       = new SCModels.StepListView collection: steps
  
    # Initialization of the InterfaceListView
    interfaceCollection         = new SCModels.Interfaces SCVisu.current_calcul.get('interfaces')
    SCVisu.interfaceListView    = new SCModels.InterfaceListView collection : interfaceCollection

    # Initialisation of VolumicForcesListView
    volumicForcesCollection      = new SCModels.VolumicForceCollection  SCVisu.current_calcul.get('volumic_forces')
    SCVisu.volumicForcesListView = new SCModels.VolumicForceListView    collection : volumicForcesCollection 

    # Initialisation of boundaryConditionListView
    boundaryConditionCollection  = new SCModels.BoundaryConditionCollection  SCVisu.current_calcul.get('boundary_condition')
    SCVisu.boundaryConditionListView = new SCModels.BoundaryConditionListView collection : boundaryConditionCollection 

    #SCVisu.volumicForcesListView = new SCModels.VolumicForceListView    collection : volumicForcesCollection 

    # Initialization of the EdgeListView
    SCVisu.edgeListView       = new SCModels.EdgeListView()

    option = new SCModels.Option SCVisu.current_calcul.get('options')
    # Initialization of the OptionView
    SCVisu.optionView         = new SCModels.OptionView(model: option)
    
  # Initialization of the Router
  SCVisu.router = new SCVisu. Router pushState: true
  # Force the redirection to first part of the wizard
  # Backbone.history.start() returns true when the url contains an anchor
  SCVisu.router.navigate "Initialization", true if Backbone.history.start()

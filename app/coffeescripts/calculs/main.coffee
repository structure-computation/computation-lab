# SCVisu is initialized in the header in order that it is initialize at first
# window.SCVisu = {} 
$ ->
  interfaceCollection             = new SCModels.Interfaces()
  SCViews.interfaceListView       = new SCViews.InterfaceListView collection : interfaceCollection
  
  # Initialize the step view before the calcul load to prevent the following error:
  #   When two calculs was loaded and users clicked on 'add step', two steps were added...
  #   In fact, two references of StepListViews were created but I couldn't tell why.
  SCVisu.stepListView             = new SCViews.StepListView()

  # Initialize all variables and views with data retrieved from the JSON sent by the "Visualisateur"
  # /!\ Variable's name must not be changed! They are used in multiple place in the code. /!\
  SCVisu.initializeFromJSON = () ->

    # Initialization of the PieceListView
    pieceCollection               = new SCModels.PieceCollection SCVisu.current_calcul.get('pieces')
    SCVisu.pieceListView          = new SCViews.PieceListView collection : pieceCollection

    # Initialization of the MaterialListView
    materialCollection            = new SCModels.MaterialCollection SCVisu.current_calcul.get('materials')     
    SCVisu.materialListView       = new SCViews.MaterialListView collection: materialCollection
    # Initialize views for database materials
    for material in SCVisu.standardLibraryMaterial.models.concat SCVisu.companyLibraryMaterial.models
      el = $('#materials_table tbody tr#material_' + material.get("id"))
      new SCViews.DatabaseMaterialView el: el, model: material, materialListView: SCVisu.materialListView

    # Initialization of the LinkListView
    linkCollection                = new SCModels.LinkCollection SCVisu.current_calcul.get('links') 
    SCVisu.linkListView           = new SCViews.LinkListView collection: linkCollection
    # Initialize views for database links
    for link in SCVisu.standardLibraryLink.models.concat SCVisu.companyLibraryLink.models
      el = $('#links_table tbody tr#link_' + link.get("id"))
      new SCViews.DatabaseLinkView el: el, model: link, linkListView: SCVisu.linkListView

    # for link in SCVisu.companyLibraryLink.models
    #   el = $('#links_table tbody tr#link_' + link.get("id"))
    #   new SCViews.DatabaseLinkView el:  el, model: link, linkListView: SCVisu.linkListView

    # Initialization of the StepListView    
    steps                         = new SCModels.StepCollection SCVisu.current_calcul.get('time_steps').collection
    # Initialize the step list view passing it a step collection
    SCVisu.stepListView.init(steps)
    
    # Initialization of the InterfaceListView
    interfaceCollection           = new SCModels.Interfaces SCVisu.current_calcul.get('interfaces')
    SCVisu.interfaceListView      = new SCViews.InterfaceListView collection : interfaceCollection

    # Initialisation of VolumicForcesListView
    volumicForcesCollection       = new SCModels.VolumicForceCollection  SCVisu.current_calcul.get('volumic_forces')
    SCVisu.volumicForcesListView  = new SCViews.VolumicForceListView    collection : volumicForcesCollection 

    # Initialisation of boundaryConditionListView
    boundaryConditionCollection  = new SCModels.BoundaryConditionCollection  SCVisu.current_calcul.get('boundary_condition')
    SCVisu.boundaryConditionListView = new SCViews.BoundaryConditionListView collection : boundaryConditionCollection 
    #SCVisu.volumicForcesListView = new SCViews.VolumicForceListView    collection : volumicForcesCollection 

    # Initialization of the EdgeListView
    SCVisu.edgeListView           = new SCViews.EdgeListView()

    option = new SCModels.Option SCVisu.current_calcul.get('options')
    # Initialization of the OptionView
    SCVisu.optionView             = new SCViews.OptionView model: option
    
  # Initialization of the Router
  SCVisu.router = new SCVisu. Router pushState: true
  # Force the redirection to first part of the wizard
  # Backbone.history.start() returns true when the url contains an anchor
  SCVisu.router.navigate "Initialization", true if Backbone.history.start()

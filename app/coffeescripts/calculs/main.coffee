# SCVisu is initialized in the header in order that it is initialize at first
# window.SCVisu = {} 
$ ->  
  # Initialize the step view before the calcul load to prevent the following error:
  #   When two calculs was loaded and users clicked on 'add step', two steps were added...
  #   In fact, two references of StepListViews were created but I couldn't tell why.
  SCVisu.stepListView                       = new SCViews.StepListView()
  SCVisu.stepParameterListView              = new SCViews.StepParameterListView()
  SCVisu.multiresolutionParametersListView  = new SCViews.MultiresolutionParameterListView()

  # Initialize views for database materials
  SCVisu.databaseMaterialListView = []
  for material in SCVisu.standardLibraryMaterial.models.concat SCVisu.workspaceLibraryMaterial.models
    el = $('#materials_table tbody tr#material_' + material.get("id"))
    SCVisu.databaseMaterialListView.push new SCViews.DatabaseMaterialView el: el, model: material

  # Initialize views for database links
  SCVisu.databaseLinkListView = []
  for link in SCVisu.standardLibraryLink.models.concat SCVisu.workspaceLibraryLink.models
    el = $('#links_table tbody tr#link_' + link.get("id"))
    SCVisu.databaseLinkListView.push new SCViews.DatabaseLinkView el: el, model: link

  # Initialize all variables and views with data retrieved from the JSON sent by the "Visualisateur"
  # /!\ Variable's name must not be changed! They are used in multiple place in the code. /!\
  SCVisu.initializeFromJSON = () ->
    # Put the correct URL to download JSON.
    # As we already are at an sc_models/:id, we do not have to specify again the model ID
    $("a#downlaod_json").attr('href', "calculs/#{SCVisu.current_calcul.get('id')}") 
    $('#visu_calcul').show()
    # Initialization of the PieceListView
    pieceCollection               = new SCModels.PieceCollection SCVisu.current_calcul.get('pieces')
    SCVisu.pieceListView          = new SCViews.PieceListView collection : pieceCollection

    # Initialization of the MaterialListView
    window.materialCollection       = new SCModels.MaterialCollection SCVisu.current_calcul.get('materials')     
    SCVisu.materialListView         = new SCViews.MaterialListView collection: materialCollection
    # We have to use 'setListView' method in order to not duplicate the view
    for dbMaterial in SCVisu.databaseMaterialListView
      dbMaterial.setListView SCVisu.materialListView
    
    # Initialization of the LinkListView
    linkCollection                = new SCModels.LinkCollection SCVisu.current_calcul.get('links') 
    SCVisu.linkListView           = new SCViews.LinkListView collection: linkCollection
    for dbLink in SCVisu.databaseLinkListView
      dbLink.setListView SCVisu.linkListView

    # for link in SCVisu.workspaceLibraryLink.models
    #   el = $('#links_table tbody tr#link_' + link.get("id"))
    #   new SCViews.DatabaseLinkView el:  el, model: link, linkListView: SCVisu.linkListView

    # Initialization of the StepListView    
    steps                         = new SCModels.StepCollection SCVisu.current_calcul.get('time_steps').collection
    SCVisu.stepListView.init(steps)
    stepParameters                = new SCModels.StepParameterCollection SCVisu.current_calcul.get('time_steps').parameter_collection
    SCVisu.stepParameterListView.init(stepParameters)
    
    multiresolutionParameters     = new SCModels.MultiresolutionParameterCollection SCVisu.current_calcul.get('multiresolution_parameters').collection
    SCVisu.multiresolutionParametersListView.init multiresolutionParameters
    
    # Initialization of the InterfaceListView
    interfaceCollection           = new SCModels.Interfaces SCVisu.current_calcul.get('interfaces')
    SCVisu.interfaceListView      = new SCViews.InterfaceListView collection : interfaceCollection

    # Initialisation of VolumicForcesListView
    volumicForcesCollection       = new SCModels.VolumicForceCollection  SCVisu.current_calcul.get('volumic_forces')
    SCVisu.volumicForcesListView  = new SCViews.VolumicForceListView    collection : volumicForcesCollection 

    # Initialisation of boundaryConditionListView
    boundaryConditionCollection   = new SCModels.BoundaryConditionCollection  SCVisu.current_calcul.get('boundary_conditions')
    SCVisu.boundaryConditionListView = new SCViews.BoundaryConditionListView collection : boundaryConditionCollection 
    #SCVisu.volumicForcesListView = new SCViews.VolumicForceListView    collection : volumicForcesCollection 

    # Initialization of the EdgeListView
    edgeCollection                = new SCModels.EdgeCollection SCVisu.current_calcul.get('edges')
    SCVisu.edgeListView           = new SCViews.EdgeListView collection: edgeCollection

    # Initialization of the OptionView
    option                        = new SCModels.Option SCVisu.current_calcul.get('options')
    SCVisu.optionView             = new SCViews.OptionView model: option
    
    # Initialization of the ForcastView
    forcast                       = new SCModels.Forcast SCVisu.current_calcul.get('forcasts')
    SCVisu.forcastView            = new SCViews.ForcastView  model: forcast
    #alert SCVisu.current_calcul.get('forcasts').nb_proc
    
  # Initialization of the Router
  SCVisu.router = new SCVisu. Router pushState: true
  # Force the redirection to first part of the wizard
  # Backbone.history.start() returns true when the url contains an anchor
  SCVisu.router.navigate "Initialization", true if Backbone.history.start()
  
  class Notifications
    constructor: (delay) ->
      @content = $('#notification')
      @delay = delay ||= 3000
      
    setText: (text) ->
      @content.html("")
      @content.append("<p>" + text + "</p>")
      @content.addClass("show")
      setTimeout(@close, @delay)
      
    setTextWithoutTimer: (text) ->
      @content.html("")
      @content.append("<p>" + text + "</p>")
      @content.addClass("show")
      
    setDelay: (time) ->
      @delay = time
      
    close: => 
      @content.removeClass("show")
      
  SCVisu.NOTIFICATIONS = new Notifications()
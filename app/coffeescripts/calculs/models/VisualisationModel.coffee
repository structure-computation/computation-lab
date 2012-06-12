# Visualisation
# Contains all attributes of a visualisation : 
#   Pieces
#   Interfaces
#   Etc.
# The model is saved in the Database

SCModels.Visualisation = Backbone.Model.extend

  initialize: ->
    #geometry
    @set pieces                : []
    @set interfaces            : []
    @set edges                 : []
    @set select_num_group_info : []
      
    @sc_model_id  = SCVisu.current_model_id
    @url = "/visualisation/"
    
  resetUrl: ->
    @url = "/visualisation/"
     
  setElements: (params) ->
    @set pieces             : params.pieces   
    @set interfaces         : params.interfaces
    @set edges              : params.edges

  handle_resize_for_visualisation_canevas: ()   -> 
    @visualizationDOMCanvas.height      = @visualizationPlaceHolder.innerHeight()
    @visualizationDOMCanvas.width       = @visualizationPlaceHolder.innerWidth()
    # TODO : est-ce que SCDisp sait gérer le resize ?
    @visualizationDock.draw() if @visualizationDock?

  launchVisualisation: () ->
    @visualizationPlaceHolder = $( "#visu_calcul" )
    @visualizationDOMCanvas = document.getElementById( "visualisation_dock" )
    
    @visualizationDock = new window.SCVisu.ScDisp( "visualisation_dock" )
    @visualizationDock_shrink_on = false
    $(window).resize(@handle_resize_for_visualisation_canevas) # choisir si l'on prend l'évenement de la fenetre ou du placeholder
    # Initialisation lors du premier lancement
    @handle_resize_for_visualisation_canevas()
    # Lancement de la visualisation.
    @visualizationDock = new window.SCVisu.ScDisp( "visualisation_dock" )
    # Ajout d'un repaire
    @visualizationDock.add_item( new window.SCVisu.ScItem_GradiendBackground( [
        [ 0.0, "rgb( 0, 0,   0 )" ],
        [ 0.5, "rgb( 0, 0,  40 )" ],
        [ 1.0, "rgb( 0, 0, 100 )" ]
    ] ) );
    # Ajout d'un axe.
    @visualizationDock.add_item( new window.SCVisu.ScItem_Axes( "lb" ) )
    path_geometry = new String();
    path_geometry = "/share/sc2/Developpement/MODEL/model_" + window.SCVisu.current_model_id + "/MESH/visu_geometry";

    @view_model = new window.SCVisu.ScItem_Model()
    item_id = @view_model.item_id
    @view_model.load_initial_geometry_hdf( path_geometry )

    @view_model.get_num_group_info( "num_group_info" )
    #@view_model.get_info("fields_info")
    @view_model.fit()
    @visualizationDock.add_item(@view_model)

  fit_img: () ->
    @visualizationDock.fit()

  sx: ( x, y ) ->
    @visualizationDock.set_XY(x,y)
    
  shrink: ( s ) ->
    if @visualizationDock_shrink_on
      s = 0
      @visualizationDock_shrink_on = false
    else
      s = 0.05
      @visualizationDock_shrink_on = true
    @visualizationDock.shrink(s)
    
  
    
  make_select_num_group_info_interface: () ->
    @select_num_group_info = []
    #alert num_group_info.length
    for x in [0..num_group_info.length-1]
        @select_num_group_info[ x ] = false
        if(num_group_info[x].type==2 )
            inter = window.SCVisu.interfaceListView.getInterface(num_group_info[ x ].id)
            if inter.to_visualize
                @select_num_group_info[ x ] = true
                #alert "x = " + x  
    
  make_select_num_group_info_piece: () ->
    @select_num_group_info = []
    #alert num_group_info.length
    for x in [0..num_group_info.length-1]
        @select_num_group_info[ x ] = false
        if(num_group_info[x].type==-1 )
            piece = window.SCVisu.pieceListView.getPiece(num_group_info[ x ].id)
            if piece.to_visualize
                @select_num_group_info[ x ] = true
                #alert "x = " + x
    
  
  display_all_pieces: () ->
    window.SCVisu.pieceListView.cancelFilter()
                
  display_all_interfaces: () ->
    window.SCVisu.interfaceListView.cancelFilter()
    
  view_filter: (type) -> 
    #alert   @select_num_group_info.length   
    filter = ""
    if type=="pieces"
        @make_select_num_group_info_piece()
        filter=" num_group >= " + @select_num_group_info.length
        for num_group in [0..@select_num_group_info.length-1]
            if !@select_num_group_info[ num_group ]
                filter += " or num_group== " + num_group
    else if type=="interfaces"
        @make_select_num_group_info_interface()
        filter=" num_group >= " + @select_num_group_info.length
        for num_group in [0..@select_num_group_info.length-1]
            if !@select_num_group_info[ num_group ]
                filter += " or num_group== " + num_group
    #alert  filter        
    @visualizationDock.set_elem_filter(filter)

    

   

    
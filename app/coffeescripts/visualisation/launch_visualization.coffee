# Script de lancement de la visualisation. Gère le redimensionnement de la fenetre
# qui necessite une mise à jour du canevas. (TODO: et de SCDisp)

visualizationPlaceHolder        = $( "#visu_calcul" )

# Attention, ici il faut l'élément DOM et non jquery.
visualizationDOMCanvas          = document.getElementById( "visualisation_dock" ); 
visualizationDock               = null

handle_resize_for_visualisation_canevas = ()   ->                              
  visualizationDOMCanvas.height      = visualizationPlaceHolder.innerHeight()
  visualizationDOMCanvas.width       = visualizationPlaceHolder.innerWidth()
  # TODO : est-ce que SCDisp sait gérer le resize ?
  visualizationDock.draw() if visualizationDock?


# A chaque modification de taille on replace correctement les valeurs du canevas.
# visualizationPlaceHolder.resize(handle_resize_for_visualisation_canevas)
$(window).resize(handle_resize_for_visualisation_canevas) # choisir si l'on prend l'évenement de la fenetre ou du placeholder

# Initialisation lors du premier lancement
handle_resize_for_visualisation_canevas()

# Lancement de la visualisation.
visualizationDock = new window.SCVisu.ScDisp( "visualisation_dock" )

# Ajout d'un repaire
visualizationDock.add_item( new window.SCVisu.ScItem_GradiendBackground( [
    [ 0.0, "rgb( 0, 0,   0 )" ],
    [ 0.5, "rgb( 0, 0,  40 )" ],
    [ 1.0, "rgb( 0, 0, 100 )" ]
] ) );

# Ajout d'un axe.
visualizationDock.add_item( new window.SCVisu.ScItem_Axes( "lb" ) )

path_geometry = new String();
path_geometry = "/share/sc2/Developpement/MODEL/model_" + window.SCVisu.current_model_id + "/MESH/visu_geometry";

view_model = new window.SCVisu.ScItem_Model();
item_id = view_model.item_id;
view_model.load_initial_geometry_hdf( path_geometry ); 

view_model.get_num_group_info( "num_group_info" ); 
view_model.get_info("fields_info");
view_model.fit();
visualizationDock.add_item(view_model); 

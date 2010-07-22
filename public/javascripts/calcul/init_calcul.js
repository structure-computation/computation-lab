<!--
// -------------------------------------------------------------------------------------------------------------------------------------------
// initialisation de l'ensemble des variable utile pour la mise en page (affichage) 
// -------------------------------------------------------------------------------------------------------------------------------------------
// pour le début ------------
var model_id = '' ; 					// identite du modele courant
var NC_current_scroll = 'left';				// état de la scrollbar horizontale
var NC_current_page = 'page_initialisation';		// page courante
var NC_current_step = 1;				// étape courante
var selected_for_info = new Array(); 			// élément selectionné pour affichage dans la boite prop
var NC_current_prop_visu = 'visu';			// visu ou prop selon la boite que l'on affiche
var current_box_prop_state = 'off';			// display ou non de la boite propriété
var dim_model = 3 ;				// dimension du problème
//var requete = null;


// pour la page initialisation------------
var Tableau_model  = new Array();			// tableau venant de SCcreate
var Tableau_calcul = new Array();  			// tableau des calcul pour l'initialisation 
var calcul_select = -1;					// numéro du calcul sélectionné
var id_calcul_select = -1;				// id de l'element graphique pour le calcul sélectionné
var Tableau_calcul_filter = new Array();  		// tableau des calcul filtrés (à partir de Tableau_calcul) à afficher
var calcul_filter = new Array('','');  			// filtres pour les calcul
var current_state_active_box_init = 'on';    		// affichage de la boite active initialisation
var Tableau_init_time_step_temp = new Array();		// tableau des step calcul définis à l'initialisation et repris dans le CLs
Tableau_init_time_step_temp['name'] = 'step_0';
Tableau_init_time_step_temp['Ti'] = 0;
Tableau_init_time_step_temp['PdT'] = 1;
Tableau_init_time_step_temp['nb_PdT'] = 1;
Tableau_init_time_step_temp['Tf'] = 1;

var new_Tableau_init_select =  new Array();		// tableu new calcul select
    new_Tableau_init_select['name'] = 'Nouveau calcul';
    new_Tableau_init_select['description'] = 'Description';
    new_Tableau_init_select['ctype'] = 'statique';
    new_Tableau_init_select['D2type'] = 'DP';
    new_Tableau_init_select['id'] = -1;

// pour la page matériaux------------
var Tableau_mat = new Array();  			// tableau des matériaux 
var compteur_mat_select = 0;				// compteur pour l'attribution des id_select
var Tableau_mat_filter = new Array();  			// tableau des matériaux filtrés (à partir de Tableau_mat) à afficher
var mat_filter = new Array('','');  			// filtres pour les matériaux

var prop_mat_for_info = new Array(); 			// pour l'affichage des propriétés du matériaux

var Tableau_pieces_assigned = new Array();  		// tableau des pièces assignées a un matériaux
var Tableau_pieces_not_assigned = new Array(); 		// tableau des pièces restant à assignées a un matériaux
var Tableau_pieces_filter = new Array();  		// tableau des pieces filtrés (à partir de Tableau_piece_not_selected) à afficher
var piece_filter = new Array('',''); 			// filtres pour les pieces

var groupe_pieces_temp = new Array();			// groupe temporaire pour le construction de groupe_pieces
var Tableau_pieces_assigned_i = new Array();  		// tableau des pièces assignées au matériaux i
var actif_mat_select = -1;             			// matériaux sélectionné actif pour l'assignation de pièce ou la suppression
var id_actif_mat_select = -1;				// id de l'element graphique du liaisons sélectionné actif 
var actif_piece_select = -1;             		// piece sélectionné actif pour la suppression
var id_actif_piece_select = -1;				// id de l'element graphique piece sélectionné actif

// pour la page liaison------------
var Tableau_liaison = new Array();  			// tableau des liaisons 
var compteur_liaison_select = 0;			// compteur pour l'attribution des id_select
var Tableau_liaison_filter = new Array();  		// tableau des liaisons filtrés (à partir de Tableau_liaison) à afficher
var liaison_filter = new Array('','');  		// filtres pour les liaisons

var prop_liaison_for_info = new Array(); 		// pour l'affichage des propriétés de la liaison

var Tableau_interfaces_assigned = new Array();  	// tableau des interfaces assignées a un liaisons
var Tableau_interfaces_not_assigned = new Array(); 	// tableau des interfaces restant à assignées a un liaisons
var Tableau_interfaces_filter = new Array();  		// tableau des interfaces filtrées (à partir de Tableau_interface_not_selected) à afficher
var interface_filter = new Array('',''); 		// filtres pour les interfaces

var groupe_interfaces_temp = new Array();		// groupe temporaire pour le construction de groupe_interfaces
var Tableau_interfaces_assigned_i = new Array();  	// tableau des interfaces assignées aux liaisons i
var actif_liaison_select = -1;             		// liaisons sélectionné actif pour l'assignation d interfaces ou la suppression
var id_actif_liaison_select = -1;			// id de l'element graphique du liaisons sélectionné actif 
var actif_interface_select = -1;             		// interface sélectionné actif pour la suppression
var id_actif_interface_select = -1;			// id de l'element graphique interface sélectionné actif

// pour la page CLs------------
var Tableau_CL = new Array();  				// tableau des CLs 
var Tableau_CL_step = new Array();  			// tableau des motif pour chaque step d'une CL
Tableau_CL_step['Fx'] = "0";
Tableau_CL_step['Fy'] = "0";
Tableau_CL_step['Fz'] = "0";
Tableau_CL_step['ft'] = 1;

var current_state_box_schema_temp = 'on';		// états d'affichage des boite active de la page option
var compteur_CL_select = 0;				// compteur pour l'attribution des id_select

var Tableau_bords_assigned = new Array();  		// tableau des bords assignées a une CL
var Tableau_bords_not_assigned = new Array(); 		// tableau des bords restant à assignées a une CL
var Tableau_bords_filter = new Array();  		// tableau des bords filtrées (à partir de Tableau_bord_not_selected) à afficher
var bord_filter = new Array('',''); 			// filtres pour les bords

var groupe_bords_temp = new Array();			// groupe temporaire pour le construction de groupe_bords
var Tableau_bords_assigned_i = new Array();  		// tableau des bords assignées aux CLs i
var actif_CL_select = -1;             			// CLs sélectionné actif pour l'assignation d bords ou la suppression
var id_actif_CL_select = -1;				// id de l'element graphique du CLs sélectionné actif 
var actif_bord_select = -1;             		// bord sélectionné actif pour la suppression
var id_actif_bord_select = -1;				// id de l'element graphique bord sélectionné actif

var Tableau_bords_test = new Array();  			// tableau d'initialisation pour la creation des bors (static, c'est le format du tableau)
var compteur_bords_test = 0;				// compteur pour l'attribution des id_select
var Tableau_bords_for_info = new Array();  			// tableau d'initialisation pour la creation des bors (celui sur lequel on travail)
Tableau_bords_test["id"]=-1;
Tableau_bords_test["origine"]="from_php";
Tableau_bords_test["assigned"]=-1;
Tableau_bords_test["group"]=-1;
Tableau_bords_test["type"]="";				// is_in, is_on, has_normal
Tableau_bords_test["geometry"]="";			// box, crecle, cylindre, sphere...
Tableau_bords_test["name"]="";				// nom pour le calcul
Tableau_bords_test["description"]="";			// nom pour le calcul
Tableau_bords_test["pdirection_x"]=0;
Tableau_bords_test["pdirection_y"]=0;
Tableau_bords_test["pdirection_z"]=0;
Tableau_bords_test["point_1_x"]=0;
Tableau_bords_test["point_1_y"]=0;
Tableau_bords_test["point_1_z"]=0;
Tableau_bords_test["point_2_x"]=0;
Tableau_bords_test["point_2_y"]=0;
Tableau_bords_test["point_2_z"]=0;
Tableau_bords_test["point_3_x"]=0;
Tableau_bords_test["point_3_y"]=0;
Tableau_bords_test["point_3_z"]=0;
Tableau_bords_test["radius"]=0;
Tableau_bords_test["equation"]="0";
Tableau_bords_test["id_CL"]=-1;


// pour la page options------------
var current_state_active_box_opt = new Array();		// états d'affichage des boite active de la page option
for(i=0; i<6; i++){
	current_state_active_box_opt[i] = 'on';
}
var Tableau_option_test = new Array();	    		// options mode test
Tableau_option_test['mode']='test';
Tableau_option_test['nb_option']=0;
Tableau_option_test['LATIN_conv']=0,01;
Tableau_option_test['LATIN_nb_iter']=150;
Tableau_option_test['PREC_nb_niveaux']=1;
Tableau_option_test['PREC_erreur']=30;
Tableau_option_test['PREC_boite'] = new Array();   	// type (prec_max ou prec_min); boite
Tableau_option_test['Crack'] = new Array();   	// taille, direction (normale), point d'encrage
Tableau_option_test['Dissipation'] = 'off';		// taille, direction (normale), point d'encrage

var Tableau_option_normal = new Array();	    	// options mode test
Tableau_option_normal['mode']='normal';
Tableau_option_normal['nb_option']=2;
Tableau_option_normal['LATIN_conv']=0,0001;
Tableau_option_normal['LATIN_nb_iter']=250;
Tableau_option_normal['PREC_nb_niveaux']=4;
Tableau_option_normal['PREC_erreur']=20;
Tableau_option_normal['PREC_boite'] = new Array();   	// type (prec_max ou prec_min); boite
Tableau_option_normal['Crack'] = new Array();   	// taille, direction (normale), point d'encrage
Tableau_option_normal['Dissipation'] = 'off';		// taille, direction (normale), point d'encrage

var Tableau_option_expert = new Array();	    	// options mode test
Tableau_option_expert['mode']='expert';
Tableau_option_expert['nb_option']=5;
Tableau_option_expert['LATIN_conv']=0,0001;
Tableau_option_expert['LATIN_nb_iter']=250;
Tableau_option_expert['PREC_nb_niveaux']=4;
Tableau_option_expert['PREC_erreur']=20;
Tableau_option_expert['PREC_boite'] = new Array();   	// type (prec_max ou prec_min); boite
Tableau_option_expert['Crack'] = new Array();   	// taille, direction (normale), point d'encrage
Tableau_option_expert['Dissipation'] = 'off';		// taille, direction (normale), point d'encrage


//initialisation de la taille des tableau pour les left box et des table de correspondance
var taille_tableau_left = 20;				// taille des tableau dans les left box
var left_tableau_connect = new Array();			// connectivité entre l'id de l'element graphique (div) et l'élément du tableau affiché dedans 	
var left_tableau_current_page = new Array();		// numéro de la page du tableau (sert pour la définition de la connectivité)	
var left_tableau_curseur_page = new Array();		// nombre de page du tableau (sert pour l'affichage des page en bas des tableaux)
var left_tableau_liste_page = new Array();		// liste des page du tableau (sert pour l'affichage des page en bas des tableaux)
var left_tableau_page = new Array('calcul', 'mat', 'liaison', 'CL', 'CLv');		// initialisation de toute les page avec tableau dynamique à gauche
for(i=0; i<left_tableau_page.length ; i++){
	left_tableau_connect[left_tableau_page[i]] = new Array(taille_tableau_left);
	left_tableau_current_page[left_tableau_page[i]] = 0;
	left_tableau_curseur_page[left_tableau_page[i]] = 0;
	left_tableau_liste_page[left_tableau_page[i]] = [1];
	for(j=0; j<taille_tableau_left ; j++){
		left_tableau_connect[left_tableau_page[i]][j]=j;
	}
}

//initialisation de la taille des tableau pour les right box et des table de correspondance
var taille_tableau_right = 20;
var right_tableau_connect = new Array();
var right_tableau_current_page = new Array();
var right_tableau_curseur_page = new Array();
var right_tableau_liste_page = new Array();
var right_tableau_page = new Array('piece', 'interface', 'bord');		// initialisation de toute les page avec tableau dynamique à droite
for(i=0; i<right_tableau_page.length ; i++){
	right_tableau_connect[right_tableau_page[i]] = new Array(taille_tableau_right);
	right_tableau_current_page[right_tableau_page[i]] = 0;
	right_tableau_curseur_page[right_tableau_page[i]] = 0;
	right_tableau_liste_page[right_tableau_page[i]] = [1];
	for(j=0; j<taille_tableau_right ; j++){
		right_tableau_connect[right_tableau_page[i]][j]=j;
	}
}

//initialisation de la taille des tableau pour les twin_left box et des table de correspondance
var taille_tableau_twin_left = 9;
var twin_left_tableau_connect = new Array();
var twin_left_tableau_current_page = new Array();
var twin_left_tableau_curseur_page = new Array();
var twin_left_tableau_liste_page = new Array();
var twin_left_tableau_page = new Array('mat_twin', 'liaison_twin', 'CL_twin');	// page avec tableau dynamique en zone active gauche
for(i=0; i<twin_left_tableau_page.length ; i++){
	twin_left_tableau_connect[twin_left_tableau_page[i]] = new Array(taille_tableau_twin_left);
	twin_left_tableau_current_page[twin_left_tableau_page[i]] = 0;
	twin_left_tableau_curseur_page[twin_left_tableau_page[i]] = 0;
	twin_left_tableau_liste_page[twin_left_tableau_page[i]] = [1];
	for(j=0; j<taille_tableau_twin_left ; j++){
		twin_left_tableau_connect[twin_left_tableau_page[i]][j]=j;
	}
}

//initialisation de la taille des tableau pour les twin_right box et des table de correspondance
var taille_tableau_twin_right = 9;
var twin_right_tableau_connect = new Array();
var twin_right_tableau_current_page = new Array();
var twin_right_tableau_curseur_page = new Array();
var twin_right_tableau_liste_page = new Array();
var twin_right_tableau_page = new Array('piece_twin', 'interface_twin', 'bord_twin');	// page avec tableau dynamique en zone active gauche
for(i=0; i<twin_right_tableau_page.length ; i++){
	twin_right_tableau_connect[twin_right_tableau_page[i]] = new Array(taille_tableau_twin_right);
	twin_right_tableau_current_page[twin_right_tableau_page[i]] = 0;
	twin_right_tableau_curseur_page[twin_right_tableau_page[i]] = 0;
	twin_right_tableau_liste_page[twin_right_tableau_page[i]] = [1];
	for(j=0; j<taille_tableau_twin_left ; j++){
		twin_right_tableau_connect[twin_right_tableau_page[i]][j]=j;
	}
}


// -------------------------------------------------------------------------------------------------------------------------------------------
// initialisation de l'ensemble des variable utile pour le calcul 
// -------------------------------------------------------------------------------------------------------------------------------------------
var Tableau_id_model = new Array();			// tableau des caractéristiques du model
var Tableau_init_select = new Array();			// tableau des caractéristiques du calcul pour l'initialisation
var Tableau_init_time_step = new Array();		// tableau des step calcul définis à l'initialisation et repirs dans le CLs

var Tableau_mat_select = new Array();			// tableau des matériaux selectionnés
var Tableau_pieces = new Array();			// liste des pieces du modèle, a initialiser à partir du xml. on le complete dans l'interface web
var groupe_pieces = new Array();			// groupe de piece, ('id','name','group','type','value'). critère de regroupement

var Tableau_liaison_select = new Array();		// tableau des liaisons selectionnées
var Tableau_interfaces = new Array();			// liste des interfaces du modèle, a initialiser à partir du xml. 
var groupe_interfaces = new Array();			// groupe d interface, ('id','name','group','type','value'). critère de regroupement

var Tableau_CL_select = new Array();			// tableau des CLs selectionnées
var Tableau_CL_select_volume = new Array();  	// tableau des CLs volumique selectionnées
var Tableau_bords = new Array();			// liste des bords du modèle, a initialiser à partir du xml. on le complete dans l'interface web
var groupe_bords = new Array();				// groupe d bord, ('id','name','group','type','value'). critère de regroupement

var Tableau_option_select = Tableau_option_test;	// options selectionnées pour le calcul par défaut sur test

var Tableau_calcul_complet = new Object();  		// tableau decrivant l'integralite du calcul
-->
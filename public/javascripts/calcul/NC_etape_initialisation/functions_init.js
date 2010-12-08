

// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la page entière 
// -------------------------------------------------------------------------------------------------------------------------------------------

// affichage de la page matériaux
function affiche_NC_page_initialisation(){
	NC_current_page = 'page_initialisation';
	affiche_NC_page('off','off');
	if(NC_current_scroll=='right'){
		NC_scroll(NC_current_scroll);
	}
	affich_prop_visu('visu');
	document.getElementById('NC_footer_top_init').className = 'on';
	document.getElementById('NC_footer_top_suiv').className = 'off';
	document.getElementById('NC_footer_top_valid').className = 'off';
}

// rafraichiassement de la page matériaux
function refresh_NC_page_initialisation(){
	affiche_Tableau_calcul();
}

// affichage des boites d'option
function affich_box_init(){
	str_id = "#NC_init_active_box";
	str_id_triangle = "NC_top_box_init";
	if(current_state_active_box_init=='off'){
		$(str_id).slideDown("slow",equal_height_NC_fake);
		id_triangle = document.getElementById(str_id_triangle);	
		id_triangle.className = 'NC_triangle_bas';
		current_state_active_box_init='on';
	}else if(current_state_active_box_init=='on'){
		$(str_id).slideUp("slow",equal_height_NC_fake);
		id_triangle = document.getElementById(str_id_triangle);	
		id_triangle.className = 'NC_triangle_cote';
		current_state_active_box_init='off';
	}
}


// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la colone de gauche, bibliothèque des calcul 
// -------------------------------------------------------------------------------------------------------------------------------------------

// afficher les filtres calcul
function affich_calcul_filter(){
	var id_calcul_filter = document.getElementById('NC_filter_calcul');
	var id_todo_calcul = document.getElementById('NC_todo_calcul');
	id_calcul_filter.className = "on";
	id_todo_calcul.className = "off";
}

// annuler et cacher les filtres calcul
function cache_calcul_filter(){
	calcul_filter = new Array('','');
	var id_calcul_filter = document.getElementById('NC_filter_calcul');
	var id_todo_calcul = document.getElementById('NC_todo_calcul');
	id_calcul_filter.className = "off";
	id_todo_calcul.className = "on";
	affiche_Tableau_calcul();
}
// annuler et cacher les filtres des calcul
function annuler_calcul_filter(){
	calcul_filter = new Array('','');
	affiche_Tableau_calcul();
}

// changer les filtres calcul
function change_calcul_filter(){
	var id_calcul_filter_type = document.getElementById('calcul_filter_type');
	var id_calcul_filter_value = document.getElementById('calcul_filter_value');
	calcul_filter[0] = id_calcul_filter_type.value;
	calcul_filter[1] = id_calcul_filter_value.value;
	affiche_Tableau_calcul();
}


// filtrage du tableau des calcul
function filtre_Tableau_calcul(){
	Tableau_calcul_filter = new Array();
	// aucun filtre
	if(calcul_filter[0]=='' || calcul_filter[1]==''){
		Tableau_calcul_filter = Tableau_calcul;
	}
	// filtre par nom
	else if(calcul_filter[0]=='name'){
		if(calcul_filter[1].match('[\*]')){
			calcul_filter[1]= calcul_filter[1].substring(0, calcul_filter[1].length-1);
			for(i=0; i<Tableau_calcul.length ;i++){
				if(Tableau_calcul[i]['name'].match(calcul_filter[1])){
					Tableau_calcul_filter[Tableau_calcul_filter.length] = Tableau_calcul[i];
				}
			}
		}else{
			for(i=0; i<Tableau_calcul.length ;i++){
				if(Tableau_calcul[i]['name']==calcul_filter[1]){
					Tableau_calcul_filter[Tableau_calcul_filter.length] = Tableau_calcul[i];
				}
			}
		}
		
	}	
	// filtre par référence
	else if(calcul_filter[0]=='id'){
		for(i=0; i<Tableau_calcul.length ;i++){
			if(Tableau_calcul[i]['id']==calcul_filter[1]){
				Tableau_calcul_filter[Tableau_calcul_filter.length] = Tableau_calcul[i];
			}
		}
	}	
}

// affichage du tableau des calcul
function affiche_Tableau_calcul(){
	taille_tableau_left = 20;
	filtre_Tableau_calcul();
	var current_tableau = Tableau_calcul_filter;
	var strname = 'calcul';
	var stridentificateur = 'name';
	affiche_Tableau_left(current_tableau,strname,stridentificateur);
}

// selectionner (activer) un calcul 
function select_calcul(num){
	var num_select = left_tableau_connect['calcul'][num];
	calcul_select = num_select ;
	Tableau_init_select = clone(Tableau_calcul_filter[num_select]);
	//alert(array2json(Tableau_init_select));
	id_calcul_select = num ;
	affich_calcul_select();
	affiche_Tableau_init_select();
}

// afficher le claul select dans la box active
function affich_calcul_select(){
	var taille_Tableau_calcul = Tableau_calcul_filter.length;
	for(i=0;i<taille_Tableau_calcul;i++){
		strContent_1 = new String();
		strContent_1 = 'calcul_1_' + i;
		var id_active = document.getElementById(strContent_1);
		if(id_active.className != "tableNC_box_0 off"){
			if(i==id_calcul_select){
				id_active.className = "tableNC_box_0_active on";
			}else{
				id_active.className = "tableNC_box_0 on";
			}
		}
	}
}

// affiche la page num pour la bibliothèque calcul
function go_page_calcul(num){
	if(num=='first'){
		left_tableau_current_page['calcul'] = 0;
	}else if(num=='end'){
		left_tableau_current_page['calcul'] = left_tableau_liste_page['calcul'].length;
	}else{
		var num_page = num + left_tableau_curseur_page['calcul'];
		left_tableau_current_page['calcul']=left_tableau_liste_page['calcul'][num_page]-1;	
	}
	affiche_Tableau_calcul();
}

// reinitialiser le calcul 
function select_new_calcul(){
	Tableau_init_select = clone(new_Tableau_init_select);
	id_calcul_select = -1 ;
	affich_calcul_select();
	affiche_Tableau_init_select();
}


// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la box active, initialisation selectionnée en rapport avec les conditions limites
// -------------------------------------------------------------------------------------------------------------------------------------------

function pair(nombre)
{
   return ((nombre-1)%2);
}

// affichage de la partie haute de la boite active init
function affiche_Tableau_init_select(){
	//alert(array2json(Tableau_init_select));
	for(key in Tableau_init_select){
		
		var strContent_init_key = 'init_' + key ;
		var id_init_key = document.getElementById(strContent_init_key);
		if(key == 'id'){
			if(id_init_key != null){
				remplacerTexte(id_init_key, Tableau_init_select[key]);
			}
		}else if(key == 'name'){
			id_init_key.value = Tableau_init_select[key] ;
			var id_content_top = document.getElementById("NC_content_top");
			remplacerTexte(id_content_top, Tableau_init_select[key]);
		}else if(key == 'D2type'){
			if(id_init_key != null){
				id_init_key.value = Tableau_init_select[key] ;
			}
		}else if(id_init_key != null && key != 'step'){
			id_init_key.value = Tableau_init_select[key] ;
		}
	}
	//affiche_Tableau_init_time_step();
	//alert('affiche_Tableau_init_time_step 1');
}

// mise a jour des valeur du tableau par l'utilisateur
function Tableau_init_change_value(){
	for(key in Tableau_init_select){
		var strContent_init_key = 'init_' + key ;
		var id_init_key = document.getElementById(strContent_init_key);
		if(id_init_key != null && key != 'id'){
			Tableau_init_select[key]  = id_init_key.value ;
		}
	}
	affiche_Tableau_init_select();	
}

// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la box active, affichage des pas de temps 
// -------------------------------------------------------------------------------------------------------------------------------------------









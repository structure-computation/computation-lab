

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
		}else if(key == 'ctype'){
			id_init_key.value = Tableau_init_select[key] ;
// 			id_schema_temp_key = document.getElementById('schema_temp_ctype');
// 			remplacerTexte(id_schema_temp_key, Tableau_init_select[key]);
		}else if(key == 'D2type'){
			if(id_init_key != null){
				id_init_key.value = Tableau_init_select[key] ;
			}
		}else if(id_init_key != null && key != 'step'){
			id_init_key.value = Tableau_init_select[key] ;
		}
	}
	affiche_Tableau_init_time_step();
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
	
	for(i=0;i<Tableau_init_time_step.length;i++){
		for(key in Tableau_init_time_step[i]){
			var strContent_init_step_key = 'init_step_' + key + '_' + i ;
			var id_init_step_key = document.getElementById(strContent_init_step_key);
			if(id_init_step_key != null){
				Tableau_init_time_step[i][key] = id_init_step_key.value ;
			}
		}
	}
	affiche_Tableau_init_select();	
}

// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la box active, affichage des pas de temps 
// -------------------------------------------------------------------------------------------------------------------------------------------
// affichage des boites d'option
function affich_box_schema_temp(){
	str_id = "#NC_page_CLs_non_statique";
	str_id_triangle = "NC_page_CLs_non_statique_triangle" ;
	if(current_state_box_schema_temp=='off'){
		$(str_id).slideDown("slow",equal_height_NC_fake);
		id_triangle = document.getElementById(str_id_triangle);	
		id_triangle.className = 'NC_triangle_bas';
		current_state_box_schema_temp='on';
	}else if(current_state_box_schema_temp=='on'){
		$(str_id).slideUp("slow",equal_height_NC_fake);
		id_triangle = document.getElementById(str_id_triangle);	
		id_triangle.className = 'NC_triangle_cote';
		current_state_box_schema_temp='off';
	}
}

// mise a jour des valeur du tableau par l'utilisateur
// function Tableau_schema_temp_change_value(){
// 	for(i=0;i<Tableau_init_time_step.length;i++){
// 		for(key in Tableau_init_time_step[i]){
// 			var strContent_init_step_key = 'init_step_' + key + '_' + i ;
// 			var id_init_step_key = document.getElementById(strContent_init_step_key);
// 			if(id_init_step_key != null){
// 				Tableau_init_time_step[i][key] = id_init_step_key.value ;
// 			}
// 		}
// 	}
// 	affiche_Tableau_init_time_step();
// 	//alert('affiche_Tableau_init_time_step 4');
// }

// ajout d'un step par l'utilisateur
function Tableau_init_add_step(){
	taille_Tableau_init_time_step = Tableau_init_time_step.length ;
	Tableau_init_time_step[taille_Tableau_init_time_step] = new Array();
	if(taille_Tableau_init_time_step>0){
		Tableau_init_time_step[taille_Tableau_init_time_step] = clone(Tableau_init_time_step[taille_Tableau_init_time_step-1]);
	}else{
		Tableau_init_time_step[taille_Tableau_init_time_step] = clone(Tableau_init_time_step_temp);
	}
	
	// ajout du step de chargement à touts les CL
	for(i=0;i<Tableau_CL_select_volume.length;i++){
		//test1=array2json(Tableau_CL_select_volume[i]);
		//alert(test1);
		Tableau_CL_select_volume[i]['step'][taille_Tableau_init_time_step] = clone(Tableau_CL_select_volume[i]['step'][taille_Tableau_init_time_step-1]);
	}
	for(i=0;i<Tableau_CL_select.length;i++){
		Tableau_CL_select[i]['step'][taille_Tableau_init_time_step] = clone(Tableau_CL_select[i]['step'][taille_Tableau_init_time_step-1]);//clone(Tableau_CL_step)
	}
	
	affiche_Tableau_init_time_step();
	//alert('affiche_Tableau_init_time_step 3');
}

// suppression d'un step par l'utilisateur
function Tableau_init_suppr_step(step_select){
	if(step_select == 0){
		alert('vous ne pouvez pas supprimer le premier step de chargement');
	}else{
		Tableau_init_time_step.splice(step_select,1);
		
		// suppression du step de chargement à touts les CL
		for(i=0;i<Tableau_CL_select_volume.length;i++){
			Tableau_CL_select_volume[i]['step'].splice(step_select,1);
		}
		for(i=0;i<Tableau_CL_select.length;i++){
			Tableau_CL_select[i]['step'].splice(step_select,1);
		}
	}
	
	affiche_Tableau_init_time_step();
	//alert('affiche_Tableau_init_time_step 2');
}

// affichage du tableau des step de chargement de la boite active init
function affiche_Tableau_init_time_step(){
	str_id_non_statique = "NC_init_non_statique";
	var id_non_statique = document.getElementById(str_id_non_statique);
	//alert(Tableau_init_select['ctype']);
	if(Tableau_init_select['ctype'] == 'statique'){
		id_non_statique.className = 'off' ;
	}else{
		id_non_statique.className = 'on' ;
	}
	for(i=0;i<20;i++){
		// on affiche la ligne line_step de la page init
		var strContent_init_step_line = 'init_line_step_' + i ;
		var id_init_step_line = document.getElementById(strContent_init_step_line);
		// on affiche le lignes prop_CL_step de la page prop_CL
		var strContent_prop_CL_step = 'prop_CL_step_' + i ;
		var id_prop_CL_step = document.getElementsByName(strContent_prop_CL_step);
		
		if(i<Tableau_init_time_step.length){
			for(nstep=0; nstep<id_prop_CL_step.length; nstep++){
				id_prop_CL_step[nstep].className = 'NC_prop_line_top on' ;
			}
			if(pair(i)){
				id_init_step_line.className = "NC_init_table_step_lign pair";
			}else{
				id_init_step_line.className = "NC_init_table_step_lign impair";
			}
			Tableau_init_time_step[i]['name'] = 'step_' + i ;
			if(i == 0){
				Tableau_init_time_step[i]['Ti'] = 0 ;
			}else{
				Tableau_init_time_step[i]['Ti'] = Tableau_init_time_step[i-1]['Tf'] ;
			}
			Tableau_init_time_step[i]['Tf'] = Tableau_init_time_step[i]['Ti'] + Tableau_init_time_step[i]['PdT'] *  Tableau_init_time_step[i]['nb_PdT'];
			
			
			for(key in Tableau_init_time_step[i]){
				var strContent_init_step_key = 'init_step_' + key + '_' + i ;
				var id_init_step_key = document.getElementById(strContent_init_step_key);
				if(id_init_step_key != null){
					id_init_step_key.value = Tableau_init_time_step[i][key] ;
				}
			}
		}else{
			id_init_step_line.className = "NC_init_table_step_lign off";
			for(nstep=0; nstep<id_prop_CL_step.length; nstep++){
				id_prop_CL_step[nstep].className = 'NC_prop_line_top off' ;
			}
		}
	}
	equal_height_NC_fake();	
}






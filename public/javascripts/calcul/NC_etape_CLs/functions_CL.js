// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la page entière 
// -------------------------------------------------------------------------------------------------------------------------------------------

// affichage de la page CLs
function affiche_NC_page_CLs(){
    if(NC_current_step >= 5){
	NC_current_page = 'page_CLs';
	affiche_NC_page('on','on');
	if(NC_current_scroll=='right'){
		NC_scroll(NC_current_scroll);
	}
	affich_prop_visu('visu');
	document.getElementById('NC_footer_top_init').className = 'off';
	document.getElementById('NC_footer_top_suiv').className = 'on';
	document.getElementById('NC_footer_top_valid').className = 'off';
	//NC_scroll(NC_current_scroll);
	//setTimeout("NC_scroll(NC_current_scroll);",1000)
	//NC_scroll(NC_current_scroll);
    }else{
	alert('vous devez valider les étapes précédentes pour accéder à cette page');
    }
}

// rafraichiassement de la page CLs
function refresh_NC_page_CLs(){
	affiche_Tableau_CL();
	affiche_Tableau_bord();
	affiche_Tableau_CL_select();
	affiche_Tableau_bord_select();
}



// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la colone de gauche, bibliothèque des CLs 
// -------------------------------------------------------------------------------------------------------------------------------------------

// affichage du tableau des CLs effort et depl
function affiche_Tableau_CL(){
	taille_tableau_left = 7;
	var current_tableau = Tableau_CL;
	var strname = 'CL';
	var stridentificateur = 'name';
	affiche_Tableau_left(current_tableau,strname,stridentificateur);
	affiche_Tableau_CL_volume();
}

// affichage du tableau des CLs volume
function affiche_Tableau_CL_volume(){
	taille_tableau_left = 3;
	var current_tableau = Tableau_CL_select_volume;
	var strname = 'CLv';
	var stridentificateur = 'name';
	affiche_Tableau_left(current_tableau,strname,stridentificateur);
	for(i=0; i<3 ;i++){		
		strid_v3 = 'CLv_13_' + i;
		id_check = document.getElementById(strid_v3);
		if(!Tableau_CL_select_volume[i]['select']){
			id_check.checked=false;	
		}else{
			id_check.checked=true;
		}
	}
	
//	for(i=0; i<3 ;i++){
//		strid_v1 = 'CLv_11_' + i;
//		id_v1 = document.getElementById(strid_v1);
//		id_v1.className = "tableNC_box_1 CL_" + Tableau_CL_select_volume[i]['type_picto']	;
//		strid_v2 = 'CLv_12_' + i;
//		id_v2 = document.getElementById(strid_v2);
//		strtemp = new String();
//		strtemp = Tableau_CL_select_volume[i]['name'];
//		remplacerTexte(id_v2, strtemp);
//		
//		strid_v3 = 'CLv_13_' + i;
//		id_check = document.getElementById(strid_v3);
//		if(!Tableau_CL_select_volume[i]['select']){
//			id_check.checked=false;	
//		}else{
//			id_check.checked=true;
//		}
//	}
}

// ajout d'un effort volumique
function select_CL_vol(num){
	if(!Tableau_CL_select_volume[num]['select']){
		Tableau_CL_select_volume[num]['select'] = true;
	}else{
		Tableau_CL_select_volume[num]['select'] = false;
	}
	affiche_Tableau_CL_volume();
}

// ajout d'une CL sur les bors
function select_CL(num){
	var taille_Tableau_CL_select = Tableau_CL_select.length;
	var num_select = left_tableau_connect['CL'][num];
	Tableau_CL_select[taille_Tableau_CL_select]=new Array();
	Tableau_CL_select[taille_Tableau_CL_select]=clone(Tableau_CL[num_select]);
	Tableau_CL_select[taille_Tableau_CL_select]['id_select'] = compteur_CL_select;
	compteur_CL_select = compteur_CL_select + 1;
	Tableau_CL_select[taille_Tableau_CL_select]['bords']=new Array();
	Tableau_CL_select[taille_Tableau_CL_select]['step']=new Array();
	for(i=0;i<Tableau_init_time_step.length;i++){
		Tableau_CL_select[taille_Tableau_CL_select]['step'][i]=new Array();	
		Tableau_CL_select[taille_Tableau_CL_select]['step'][i]=clone(Tableau_CL_step);
	}
	twin_left_tableau_current_page['CL_twin'] = twin_left_tableau_liste_page['CL_twin'].length-1;
	affiche_Tableau_CL_select();
}

// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la colone de droite, liste des bords 
// -------------------------------------------------------------------------------------------------------------------------------------------

// afficher les filtres des bords
function affich_bord_filter(){
	var id_filter_bord = document.getElementById('NC_filter_bord');
	var id_todo_bord = document.getElementById('NC_todo_bord');
	id_filter_bord.className = "on";
	id_todo_bord.className = "off";
}

// annuler et cacher les filtres des bords
function cache_bord_filter(){
	bord_filter = new Array('','');
	var id_filter_bord = document.getElementById('NC_filter_bord');
	var id_todo_bord = document.getElementById('NC_todo_bord');
	id_filter_bord.className = "off";
	id_todo_bord.className = "on";
	affiche_Tableau_bord();
}
// annuler et cacher les filtres des bords
function annuler_bord_filter(){
	bord_filter = new Array('','');
	affiche_Tableau_bord();
}

// changer les filtres bords
function change_bord_filter(){
	var id_bord_filter_type = document.getElementById('bord_filter_type');
	var id_bord_filter_value = document.getElementById('bord_filter_value');
	bord_filter[0] = id_bord_filter_type.value;
	bord_filter[1] = id_bord_filter_value.value;
	affiche_Tableau_bord();
}

// filtrage du tableau des bord (par références)
function filtre_Tableau_bords(){
	groupe_bords_temp = new Array();
	Tableau_bords_filter = new Array();
	Tableau_bords_assigned = new Array();
	Tableau_bords_not_assigned = new Array(); 
	for(i=0; i<Tableau_bords.length ;i++){
		if(Tableau_bords[i]['assigned']=='-1'){
			Tableau_bords[i]['group']='-1';
			Tableau_bords_not_assigned[Tableau_bords_not_assigned.length]=Tableau_bords[i];
		}else{
			Tableau_bords_assigned[Tableau_bords_assigned.length]=Tableau_bords[i];
		}
	}
	// aucun filtre
	if(bord_filter[0]=='' || bord_filter[1]==''){
		for(i=0; i<Tableau_bords_not_assigned.length ;i++){
			Tableau_bords_filter[Tableau_bords_filter.length] = Tableau_bords_not_assigned[i];
		}
	}
	// filtre par nom
	else if(bord_filter[0]=='name'){
		if(bord_filter[1].match('[\*]')){
			bord_filter[1]= bord_filter[1].substring(0, bord_filter[1].length-1);
			for(i=0; i<Tableau_bords_not_assigned.length ;i++){
				if(Tableau_bords_not_assigned[i]['name'].match(bord_filter[1])){
					groupe_bords_temp[groupe_bords_temp.length] = Tableau_bords_not_assigned[i];
				}
			}
		}else{
			for(i=0; i<Tableau_bords_not_assigned.length ;i++){
				if(Tableau_bords_not_assigned[i]['name']==bord_filter[1]){
					groupe_bords_temp[groupe_bords_temp.length] = Tableau_bords_not_assigned[i];
				}
			}
		}
		if(groupe_bords_temp.length > 1){
			Tableau_bords_filter[0]=new Array();
			Tableau_bords_filter[0]['id']=groupe_bords.length;
			Tableau_bords_filter[0]['name']='group_' + groupe_bords.length;
			Tableau_bords_filter[0]['group'] = 'true';
			Tableau_bords_filter[0]['assigned'] = '-1';
			Tableau_bords_filter[0]['type']= bord_filter[0];
			Tableau_bords_filter[0]['value']= bord_filter[1];
			Tableau_bords_filter[0]['nb_bords']= groupe_bords_temp.length ;
			for(i=0; i<groupe_bords_temp.length ;i++){
				groupe_bords_temp[i]['group']=Tableau_bords_filter[0]['id'];
				Tableau_bords_filter[i+1]=groupe_bords_temp[i];
			}
		}else{
			Tableau_bords_filter=groupe_bords_temp;
		}
	}	
}

// affichage du tableau des bords
function affiche_Tableau_bord(){
	filtre_Tableau_bords();
	var current_tableau = Tableau_bords_filter;
	var strname = 'bord';
	var stridentificateur = 'name';
	affiche_Tableau_right(current_tableau,strname,stridentificateur);
}

// ajout d'une bord aux CLs selectionné actif
function select_bords_CL(num){
	if(id_actif_CL_select != -1){
		var num_select = right_tableau_connect['bord'][num];
		if(Tableau_bords_filter[num_select]['group']=='true'){ 	// si on assigne un groupe entier (num_select = 0)
			var taille_tableau = Tableau_CL_select[actif_CL_select]['bords'].length;
			for(i=0; i<Tableau_bords_filter.length ;i++){
				Tableau_bords_filter[i]['assigned']=Tableau_CL_select[actif_CL_select]['id_select'];
				var i_temp = i + taille_tableau;
				Tableau_CL_select[actif_CL_select]['bords'][i_temp] = clone(Tableau_bords_filter[i]);
			}
			groupe_bords[groupe_bords.length] = clone(Tableau_bords_filter[num_select]);
		}else{														// si on assigne une seule bord
			Tableau_bords_filter[num_select]['assigned']=Tableau_CL_select[actif_CL_select]['id_select'];
			var i_temp = Tableau_CL_select[actif_CL_select]['bords'].length;
			Tableau_CL_select[actif_CL_select]['bords'][i_temp]= clone(Tableau_bords_filter[num_select]);
		}
		twin_right_tableau_current_page['bord_twin'] = twin_right_tableau_liste_page['bord_twin'].length-1;
		affiche_Tableau_bord_select();
		affiche_Tableau_bord();
	}
}

// ajout d'une bord aux CLs selectionné actif
function suppr_bord(num){
	var num_select = right_tableau_connect['bord'][num];
	// si on supprime une seule bord
	id_suppr = Tableau_bords_filter[num_select]["id"];
	for(i=0; i<Tableau_bords.length ;i++){
		if(Tableau_bords[i]['id']==id_suppr){
			Tableau_bords.splice(i,1);
			break;
		}
	}
	affiche_Tableau_bord();
	create_bord();
}


// affiche la page num pour la liste des bords
function go_page_bord(num){
	if(num=='first'){
		right_tableau_current_page['bord'] = 0;
	}else if(num=='end'){
		right_tableau_current_page['bord'] = right_tableau_liste_page['bord'].length;
	}else{
		var num_page = num + right_tableau_curseur_page['bord'];
		right_tableau_current_page['bord']=right_tableau_liste_page['bord'][num_page]-1;	
	}
	affiche_Tableau_bord();
}

// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la colone twin_left de la page active, liste des CLs selectionnés 
// -------------------------------------------------------------------------------------------------------------------------------------------

// affichage du tableau des CLs selectionnés
function affiche_Tableau_CL_select(){
	var current_tableau = Tableau_CL_select;
	var strname = 'CL_twin';
	var stridentificateur = 'name';
	affiche_Tableau_twin_left(current_tableau,strname,stridentificateur);
	affich_active_CL_select();
}

// selectionner (activer) un CLs de la selection pour lui ajouter des attribut ou le supprimer
function active_CL_select(num){
	var num_select = twin_left_tableau_connect['CL_twin'][num];
	actif_CL_select = num_select ;
	id_actif_CL_select = num ;
	twin_right_tableau_current_page['CL_twin']=0;
	affich_active_CL_select();
	affiche_Tableau_bord_select();
}

// afficher le CLs actif dans la twin box left
function affich_active_CL_select(){
	if(id_actif_CL_select != -1){
		var taille_Tableau_CL_select = Tableau_CL_select.length;
		for(i=0;i<taille_tableau_twin_left;i++){
			strContent_1 = new String();
			strContent_1 = 'CL_twin_1_' + i;
			var id_active = document.getElementById(strContent_1);
			if(id_active.className != "tableNC_twin_box_0 off"){
				if(i==id_actif_CL_select){
					id_active.className = "tableNC_twin_box_0_active on";
				}else{
					id_active.className = "tableNC_twin_box_0 on";
				}
			}
		}
	}
}

// affiche la page num pour les CLs selectionnés et selectione le premier element
function go_page_CL_select(num){
	if(num=='first'){
		twin_left_tableau_current_page['CL_twin'] = 0;
	}else if(num=='end'){
		twin_left_tableau_current_page['CL_twin'] = twin_left_tableau_liste_page['CL_twin'].length-1;
	}else{
		var num_page = num + twin_left_tableau_curseur_page['CL_twin'];
		twin_left_tableau_current_page['CL_twin']=twin_left_tableau_liste_page['CL_twin'][num_page]-1;	
	}
	affiche_Tableau_CL_select();
	active_CL_select(0);
}

// supprimer le CLs actif
function suppr_CL_select(num){
	active_CL_select(num)
	for(i=0; i<Tableau_bords.length ;i++){
		if(Tableau_bords[i]['assigned']==Tableau_CL_select[actif_CL_select]['id_select']){
			Tableau_bords[i]['assigned']='-1';
			Tableau_bords[i]['group']='-1';
		}
	}
	Tableau_CL_select.splice(actif_CL_select,1);
	twin_right_tableau_current_page['bord_twin']=0;
	actif_CL_select = -1;
	id_actif_CL_select = -1;
	annuler_bord_filter();
	affiche_Tableau_CL_select();
	affiche_Tableau_bord_select();
	affiche_Tableau_bord();
}


// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la colone twin_right de la page active, liste des bords associées au CLs actif 
// -------------------------------------------------------------------------------------------------------------------------------------------

// construction du tableau des bords du CLs actif
function build_Tableau_bord_select(){
	Tableau_bords_assigned_i = new Array();	
	Tableau_bords_assigned_i = Tableau_CL_select[actif_CL_select]['bords'];
}

// affichage du tableau des bords du CLs actif
function affiche_Tableau_bord_select(){
	if(actif_CL_select==-1){
		var current_tableau = ["null"];
		var strname = 'bord_twin';
		var stridentificateur = 'name';
		affiche_Tableau_twin_right(current_tableau,strname,stridentificateur);
	}else{
		build_Tableau_bord_select();
		//alert(Tableau_bords_assigned_i.length);
		var current_tableau = Tableau_bords_assigned_i;
		var strname = 'bord_twin';
		var stridentificateur = 'name';
		affiche_Tableau_twin_right(current_tableau,strname,stridentificateur);
	}
	actif_bord_select = -1 ;
	id_actif_bord_select = -1 ;
	affich_active_bord_select();
}

// affiche la page num pour la liste des bords selectionnées
function go_page_bord_select(num){
	if(num=='first'){
		twin_right_tableau_current_page['bord_twin'] = 0;
	}else if(num=='end'){
		twin_right_tableau_current_page['bord_twin'] = twin_right_tableau_liste_page['bord_twin'].length-1;
	}else{
		var num_page = num + twin_right_tableau_curseur_page['bord_twin'];
		twin_right_tableau_current_page['bord_twin']=twin_right_tableau_liste_page['bord_twin'][num_page]-1;	
	}
	affiche_Tableau_bord_select();
}

// selectionner (activer) une bord du CLs actif pour la supprimer
function active_bord_select(num){
	var num_select = twin_right_tableau_connect['bord_twin'][num];
	actif_bord_select = num_select ;
	id_actif_bord_select = num ;
	affich_active_bord_select();
}

// afficher le CLs actif dans la twin box left
function affich_active_bord_select(){
	if(id_actif_bord_select != -1){
		//var taille_Tableau_bord_select = Tableau_bords_assigned_i.length;
		for(i=0;i<taille_tableau_twin_right;i++){
			strContent_1 = new String();
			strContent_1 = 'bord_twin_1_' + i;
			var id_active = document.getElementById(strContent_1);
			if(id_active.className != "tableNC_twin_box_0 off"){
				if(i==id_actif_bord_select){
					id_active.className = "tableNC_twin_box_0_active on";
				}else{
					id_active.className = "tableNC_twin_box_0 on";
				}
			}
		}
	}
}

// enlever la bord active de la selection pour le CLs actif_CL_select
function suppr_bord_select(num){
	active_bord_select(num)
	if(Tableau_bords_assigned_i[actif_bord_select]['group']=='true'){
		var taille_groupe = 1;
		for(i=0; i<Tableau_CL_select[actif_CL_select]['bords'].length ;i++){
			if(Tableau_CL_select[actif_CL_select]['bords'][i]['group']==Tableau_bords_assigned_i[actif_bord_select]['id']){
				taille_groupe = taille_groupe+1;
			}
		}
		Tableau_bords_assigned_i[actif_bord_select]['assigned']='-1';
		for(i=0; i<Tableau_bords.length ;i++){
			if(Tableau_bords[i]['group']==Tableau_bords_assigned_i[actif_bord_select]['id']){
				Tableau_bords[i]['assigned']='-1';
				Tableau_bords[i]['group']='-1';
			}
		}
		Tableau_CL_select[actif_CL_select]['bords'].splice(actif_bord_select,taille_groupe);
	}else{
		for(i=0; i<Tableau_bords.length ;i++){
			if(Tableau_bords[i]['id']==Tableau_bords_assigned_i[actif_bord_select]['id']){
				Tableau_bords[i]['assigned']='-1';
				Tableau_bords[i]['group']='-1';
			}
		}
		Tableau_CL_select[actif_CL_select]['bords'].splice(actif_bord_select,1);
	}
	annuler_bord_filter();
	affiche_Tableau_bord_select();
	affiche_Tableau_bord();
}




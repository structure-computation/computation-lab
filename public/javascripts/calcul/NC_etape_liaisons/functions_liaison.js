// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la page entière 
// -------------------------------------------------------------------------------------------------------------------------------------------

// affichage de la page liaisons
function affiche_NC_page_liaisons(){
     if(NC_current_step >= 4){
	NC_current_page = 'page_liaisons';
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

// rafraichiassement de la page liaisons
function refresh_NC_page_liaisons(){
	affiche_Tableau_liaison();
	affiche_Tableau_interface();
	affiche_Tableau_liaison_select();
	affiche_Tableau_interface_select();
}



// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la colone de gauche, bibliothèque des liaisons 
// -------------------------------------------------------------------------------------------------------------------------------------------

// afficher les filtres liaisons
function affich_liaison_filter(){
	var id_liaison_filter = document.getElementById('NC_filter_liaison');
	var id_todo_liaison = document.getElementById('NC_todo_liaison');
	id_liaison_filter.className = "on";
	id_todo_liaison.className = "off";
}

// annuler et cacher les filtres liaisons
function cache_liaison_filter(){
	liaison_filter = new Array('','');
	var id_liaison_filter = document.getElementById('NC_filter_liaison');
	var id_todo_liaison = document.getElementById('NC_todo_liaison');
	id_liaison_filter.className = "off";
	id_todo_liaison.className = "on";
	affiche_Tableau_liaison();
}
// annuler et cacher les filtres des liaisons
function annuler_liaison_filter(){
	liaison_filter = new Array('','');
	affiche_Tableau_liaison();
}

// changer les filtres liaisons
function change_liaison_filter(){
	var id_liaison_filter_type = document.getElementById('liaison_filter_type');
	var id_liaison_filter_value = document.getElementById('liaison_filter_value');
	liaison_filter[0] = id_liaison_filter_type.value;
	liaison_filter[1] = id_liaison_filter_value.value;
	affiche_Tableau_liaison();
}


// filtrage du tableau des liaisons
function filtre_Tableau_liaison(){
	Tableau_liaison_filter = new Array();
	// aucun filtre
	if(liaison_filter[0]=='' || liaison_filter[1]==''){
		Tableau_liaison_filter = Tableau_liaison;
	}
	// filtre par nom
	else if(liaison_filter[0]=='name'){
		if(liaison_filter[1].match('[\*]')){
			liaison_filter[1]= liaison_filter[1].substring(0, liaison_filter[1].length-1);
			for(i=0; i<Tableau_liaison.length ;i++){
				if(Tableau_liaison[i]['name'].match(liaison_filter[1])){
					Tableau_liaison_filter[Tableau_liaison_filter.length] = Tableau_liaison[i];
				}
			}
		}else{
			for(i=0; i<Tableau_liaison.length ;i++){
				if(Tableau_liaison[i]['name']==liaison_filter[1]){
					Tableau_liaison_filter[Tableau_liaison_filter.length] = Tableau_liaison[i];
				}
			}
		}
		
	}	
	// filtre par référence
	else if(liaison_filter[0]=='id'){
		for(i=0; i<Tableau_liaison.length ;i++){
			if(Tableau_liaison[i]['id']==liaison_filter[1]){
				Tableau_liaison_filter[Tableau_liaison_filter.length] = Tableau_liaison[i];
			}
		}
	}	
}

// affichage du tableau des liaisons
function affiche_Tableau_liaison(){
	taille_tableau_left = 20;
	filtre_Tableau_liaison();
	var current_tableau = Tableau_liaison_filter;
	var strname = 'liaison';
	var stridentificateur = 'name';
	affiche_Tableau_left(current_tableau,strname,stridentificateur);
}

// ajout d'une liaisons à la selection
function select_liaison(num){
	var taille_Tableau_liaison_select = Tableau_liaison_select.length;
	var num_select = left_tableau_connect['liaison'][num];
	Tableau_liaison_select[taille_Tableau_liaison_select]=new Array();
	Tableau_liaison_select[taille_Tableau_liaison_select]=clone(Tableau_liaison_filter[num_select]);
	Tableau_liaison_select[taille_Tableau_liaison_select]['id_select'] = compteur_liaison_select;
	Tableau_liaison_select[taille_Tableau_liaison_select]['name_select'] = "liaison_select_" + compteur_liaison_select;
	compteur_liaison_select = compteur_liaison_select + 1;
	Tableau_liaison_select[taille_Tableau_liaison_select]['interfaces']=new Array();
	twin_left_tableau_current_page['liaison_twin'] = twin_left_tableau_liste_page['liaison_twin'].length-1;
	affiche_Tableau_liaison_select();
}

// affiche la page num pour la bibliothèque liaisons
function go_page_liaison(num){
	if(num=='first'){
		left_tableau_current_page['liaison'] = 0;
	}else if(num=='end'){
		left_tableau_current_page['liaison'] = left_tableau_liste_page['liaison'].length;
	}else{
		var num_page = num + left_tableau_curseur_page['liaison'];
		left_tableau_current_page['liaison']=left_tableau_liste_page['liaison'][num_page]-1;	
	}
	affiche_Tableau_liaison();
}




// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la colone de droite, liste des interfaces 
// -------------------------------------------------------------------------------------------------------------------------------------------

// afficher les filtres des interfaces
function affich_interface_filter(){
	var id_filter_interface = document.getElementById('NC_filter_interface');
	var id_todo_interface = document.getElementById('NC_todo_interface');
	id_filter_interface.className = "on";
	id_todo_interface.className = "off";
}

// annuler et cacher les filtres des interfaces
function cache_interface_filter(){
	interface_filter = new Array('','');
	var id_filter_interface = document.getElementById('NC_filter_interface');
	var id_todo_interface = document.getElementById('NC_todo_interface');
	id_filter_interface.className = "off";
	id_todo_interface.className = "on";
	affiche_Tableau_interface();
}
// annuler et cacher les filtres des interfaces
function annuler_interface_filter(){
	interface_filter = new Array('','');
	affiche_Tableau_interface();
}

// changer les filtres interfaces
function change_interface_filter(){
	var id_interface_filter_type = document.getElementById('interface_filter_type');
	var id_interface_filter_value = document.getElementById('interface_filter_value');
	interface_filter[0] = id_interface_filter_type.value;
	interface_filter[1] = id_interface_filter_value.value;
	affiche_Tableau_interface();
}

// filtrage du tableau des interface (par références)
function filtre_Tableau_interfaces(){
	groupe_interfaces_temp = new Array();
	Tableau_interfaces_filter = new Array();
	Tableau_interfaces_assigned = new Array();
	Tableau_interfaces_not_assigned = new Array(); 
	for(i=0; i<Tableau_interfaces.length ;i++){
		if(Tableau_interfaces[i]['assigned']=='-1'){
			Tableau_interfaces[i]['group']='-1';
			Tableau_interfaces_not_assigned[Tableau_interfaces_not_assigned.length]=Tableau_interfaces[i];
		}else{
			Tableau_interfaces_assigned[Tableau_interfaces_assigned.length]=Tableau_interfaces[i];
		}
	}
	// aucun filtre
	if(interface_filter[0]=='' || interface_filter[1]==''){
		for(i=0; i<Tableau_interfaces_not_assigned.length ;i++){
			Tableau_interfaces_filter[Tableau_interfaces_filter.length] = Tableau_interfaces_not_assigned[i];
		}
	}
	// filtre par nom
	else if(interface_filter[0]=='name'){
		if(interface_filter[1].match('[\*]')){
			interface_filter[1]= interface_filter[1].substring(0, interface_filter[1].length-1);
			for(i=0; i<Tableau_interfaces_not_assigned.length ;i++){
				if(Tableau_interfaces_not_assigned[i]['name'].match(interface_filter[1])){
					groupe_interfaces_temp[groupe_interfaces_temp.length] = Tableau_interfaces_not_assigned[i];
				}
			}
		}else{
			for(i=0; i<Tableau_interfaces_not_assigned.length ;i++){
				if(Tableau_interfaces_not_assigned[i]['name']==interface_filter[1]){
					groupe_interfaces_temp[groupe_interfaces_temp.length] = Tableau_interfaces_not_assigned[i];
				}
			}
		}
		if(groupe_interfaces_temp.length > 1){
			Tableau_interfaces_filter[0]=new Array();
			Tableau_interfaces_filter[0]['id']=groupe_interfaces.length;
			Tableau_interfaces_filter[0]['name']='group_' + groupe_interfaces.length;
			Tableau_interfaces_filter[0]['group'] = 'true';
			Tableau_interfaces_filter[0]['assigned'] = '-1';
			Tableau_interfaces_filter[0]['type']= interface_filter[0];
			Tableau_interfaces_filter[0]['value']= interface_filter[1];
			Tableau_interfaces_filter[0]['nb_interfaces']= groupe_interfaces_temp.length ;
			for(i=0; i<groupe_interfaces_temp.length ;i++){
				groupe_interfaces_temp[i]['group']=Tableau_interfaces_filter[0]['id'];
				Tableau_interfaces_filter[i+1]=groupe_interfaces_temp[i];
			}
		}else{
			Tableau_interfaces_filter=groupe_interfaces_temp;
		}
	}	
}

// affichage du tableau des interfaces
function affiche_Tableau_interface(){
	filtre_Tableau_interfaces();
	var current_tableau = Tableau_interfaces_filter;
	var strname = 'interface';
	var stridentificateur = 'name';
	affiche_Tableau_right(current_tableau,strname,stridentificateur);
}

// activer une interface
function active_interface(id){
        num_select_local = -1; 
        id_select_local = -1; 
        for(i=0;i<Tableau_interfaces_filter.length;i++){
                if(Tableau_interfaces_filter[i]['id'] == id) {
                      num_select_local = i;
                      id_select_local = id;
                      break;
                }
        }
        if(num_select_local != -1){
                //alert(num_select_local);
                num_page = Math.floor(num_select_local/taille_tableau_right);
                num_in_page = num_select_local - num_page * taille_tableau_right;
                //alert(num_page);
                go_page_interface(num_page);
                affich_active_interface(num_in_page)
        }
}

// afficher l'interface actif dans la box left
function affich_active_interface(num_in_page){ 
        //alert(num_in_page);
        for(i=0;i<taille_tableau_right;i++){
                strContent_1 = new String();
                strContent_1 = 'interface_1_' + i;
                var id_active = document.getElementById(strContent_1);
                if(id_active.className != "tableNC_box_0 off"){
                        if(i==num_in_page){
                                id_active.className = "tableNC_box_0_active on";
                        }else{
                                id_active.className = "tableNC_box_0 on";
                        }
                }
        }
}

// ajout d'une interface aux liaisons selectionné actif
function select_interfaces_liaison(num){
	if(id_actif_liaison_select != -1){
		var num_select = right_tableau_connect['interface'][num];
		if(Tableau_interfaces_filter[num_select]['group']=='true'){ 	// si on assigne un groupe entier (num_select = 0)
			var taille_tableau = Tableau_liaison_select[actif_liaison_select]['interfaces'].length;
			for(i=0; i<Tableau_interfaces_filter.length ;i++){
				Tableau_interfaces_filter[i]['assigned']=Tableau_liaison_select[actif_liaison_select]['id_select'];
				var i_temp = i + taille_tableau;
				Tableau_liaison_select[actif_liaison_select]['interfaces'][i_temp] = clone(Tableau_interfaces_filter[i]);
			}
			groupe_interfaces[groupe_interfaces.length] = clone(Tableau_interfaces_filter[num_select]);
		}else{														// si on assigne une seule interface
			Tableau_interfaces_filter[num_select]['assigned']=Tableau_liaison_select[actif_liaison_select]['id_select'];
			var i_temp = Tableau_liaison_select[actif_liaison_select]['interfaces'].length;
			Tableau_liaison_select[actif_liaison_select]['interfaces'][i_temp]= clone(Tableau_interfaces_filter[num_select]);
		}
		twin_right_tableau_current_page['interface_twin'] = twin_right_tableau_liste_page['interface_twin'].length-1;
		affiche_Tableau_interface_select();
		affiche_Tableau_interface();
	}
}

// affiche la page num pour la liste des interfaces
function go_page_interface(num){
	if(num=='first'){
		right_tableau_current_page['interface'] = 0;
	}else if(num=='end'){
		right_tableau_current_page['interface'] = right_tableau_liste_page['interface'].length;
	}else{
		var num_page = num + right_tableau_curseur_page['interface'];
		right_tableau_current_page['interface']=right_tableau_liste_page['interface'][num_page]-1;	
	}
	affiche_Tableau_interface();
}


// afficher l'interface dans le canvas
function view_interfaces(num_in_page){ 
        num_select = right_tableau_connect['interface'][num_in_page];
        id_interface = Tableau_interfaces_filter[num_select].id;
        filter_interface_id(id_interface);    
        change_eyes_view_interface();        
}

// afficher l'interface selectionnée uniquement dans le canvas
function view_only_interface(num_in_page){ 
        num_select = content_tableau_connect['interface'][num_in_page];
        id_interface = Tableau_interfaces_filter[num_select].id;
        filter_interface_only_id(id_interface);
        change_eyes_view_interface();  
}

// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la colone twin_left de la page active, liste des liaisons selectionnés 
// -------------------------------------------------------------------------------------------------------------------------------------------

// affichage du tableau des liaisons selectionnés
function affiche_Tableau_liaison_select(){
	var current_tableau = Tableau_liaison_select;
	var strname = 'liaison_twin';
	var stridentificateur = 'name_select';
	affiche_Tableau_twin_left(current_tableau,strname,stridentificateur);
	affich_active_liaison_select();
}

// selectionner (activer) un liaisons de la selection pour lui ajouter des attribut ou le supprimer
function active_liaison_select(num){
	var num_select = twin_left_tableau_connect['liaison_twin'][num];
	actif_liaison_select = num_select ;
	id_actif_liaison_select = num ;
	twin_right_tableau_current_page['liaison_twin']=0;
	affich_active_liaison_select();
	affiche_Tableau_interface_select();
}

// afficher le liaisons actif dans la twin box left
function affich_active_liaison_select(){
	if(id_actif_liaison_select != -1){
		var taille_Tableau_liaison_select = Tableau_liaison_select.length;
		for(i=0;i<taille_tableau_twin_left;i++){
			strContent_1 = new String();
			strContent_1 = 'liaison_twin_1_' + i;
			var id_active = document.getElementById(strContent_1);
			if(id_active.className != "tableNC_twin_box_0 off"){
				if(i==id_actif_liaison_select){
					id_active.className = "tableNC_twin_box_0_active on";
				}else{
					id_active.className = "tableNC_twin_box_0 on";
				}
			}
		}
	}
}

// affiche la page num pour les liaisons selectionnés et selectione le premier element
function go_page_liaison_select(num){
	if(num=='first'){
		twin_left_tableau_current_page['liaison_twin'] = 0;
	}else if(num=='end'){
		twin_left_tableau_current_page['liaison_twin'] = twin_left_tableau_liste_page['liaison_twin'].length-1;
	}else{
		var num_page = num + twin_left_tableau_curseur_page['liaison_twin'];
		twin_left_tableau_current_page['liaison_twin']=twin_left_tableau_liste_page['liaison_twin'][num_page]-1;	
	}
	affiche_Tableau_liaison_select();
	active_liaison_select(0);
}

// supprimer le liaisons actif
function suppr_liaison_select(num){
	active_liaison_select(num)
	for(i=0; i<Tableau_interfaces.length ;i++){
		if(Tableau_interfaces[i]['assigned']==Tableau_liaison_select[actif_liaison_select]['id_select']){
			Tableau_interfaces[i]['assigned']='-1';
			Tableau_interfaces[i]['group']='-1';
		}
	}
	Tableau_liaison_select.splice(actif_liaison_select,1);
	twin_right_tableau_current_page['interface_twin']=0;
	actif_liaison_select = -1;
	id_actif_liaison_select = -1;
	annuler_interface_filter();
	affiche_Tableau_liaison_select();
	affiche_Tableau_interface_select();
	affiche_Tableau_interface();
}


// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la colone twin_right de la page active, liste des interfaces associées au liaisons actif 
// -------------------------------------------------------------------------------------------------------------------------------------------

// construction du tableau des interfaces du liaisons actif
function build_Tableau_interface_select(){
	Tableau_interfaces_assigned_i = new Array();	
	Tableau_interfaces_assigned_i = Tableau_liaison_select[actif_liaison_select]['interfaces'];
}

// affichage du tableau des interfaces du liaisons actif
function affiche_Tableau_interface_select(){
	if(actif_liaison_select==-1){
		var current_tableau = ["null"];
		var strname = 'interface_twin';
		var stridentificateur = 'name';
		affiche_Tableau_twin_right(current_tableau,strname,stridentificateur);
	}else{
		build_Tableau_interface_select();
		//alert(Tableau_interfaces_assigned_i.length);
		var current_tableau = Tableau_interfaces_assigned_i;
		var strname = 'interface_twin';
		var stridentificateur = 'name';
		affiche_Tableau_twin_right(current_tableau,strname,stridentificateur);
	}
	actif_interface_select = -1 ;
	id_actif_interface_select = -1 ;
	affich_active_interface_select();
}

// affiche la page num pour la liste des interfaces selectionnées
function go_page_interface_select(num){
	if(num=='first'){
		twin_right_tableau_current_page['interface_twin'] = 0;
	}else if(num=='end'){
		twin_right_tableau_current_page['interface_twin'] = twin_right_tableau_liste_page['interface_twin'].length-1;
	}else{
		var num_page = num + twin_right_tableau_curseur_page['interface_twin'];
		twin_right_tableau_current_page['interface_twin']=twin_right_tableau_liste_page['interface_twin'][num_page]-1;	
	}
	affiche_Tableau_interface_select();
}

// selectionner (activer) une interface du liaisons actif pour la supprimer
function active_interface_select(num){
	var num_select = twin_right_tableau_connect['interface_twin'][num];
	actif_interface_select = num_select ;
	id_actif_interface_select = num ;
	affich_active_interface_select();
}

// afficher le liaisons actif dans la twin box left
function affich_active_interface_select(){
	if(id_actif_interface_select != -1){
		//var taille_Tableau_interface_select = Tableau_interfaces_assigned_i.length;
		for(i=0;i<taille_tableau_twin_right;i++){
			strContent_1 = new String();
			strContent_1 = 'interface_twin_1_' + i;
			var id_active = document.getElementById(strContent_1);
			if(id_active.className != "tableNC_twin_box_0 off"){
				if(i==id_actif_interface_select){
					id_active.className = "tableNC_twin_box_0_active on";
				}else{
					id_active.className = "tableNC_twin_box_0 on";
				}
			}
		}
	}
}

// enlever la interface active de la selection pour le liaisons actif_liaison_select
function suppr_interface_select(num){
	active_interface_select(num);
	if(Tableau_interfaces_assigned_i[actif_interface_select]['group']=='true'){
		var taille_groupe = 1;
		for(i=0; i<Tableau_liaison_select[actif_liaison_select]['interfaces'].length ;i++){
			if(Tableau_liaison_select[actif_liaison_select]['interfaces'][i]['group']==Tableau_interfaces_assigned_i[actif_interface_select]['id']){
				taille_groupe = taille_groupe+1;
			}
		}
		Tableau_interfaces_assigned_i[actif_interface_select]['assigned']='-1';
		for(i=0; i<Tableau_interfaces.length ;i++){
			if(Tableau_interfaces[i]['group']==Tableau_interfaces_assigned_i[actif_interface_select]['id']){
				Tableau_interfaces[i]['assigned']='-1';
				Tableau_interfaces[i]['group']='-1';
			}
		}
		Tableau_liaison_select[actif_liaison_select]['interfaces'].splice(actif_interface_select,taille_groupe);
	}else{
		for(i=0; i<Tableau_interfaces.length ;i++){
			if(Tableau_interfaces[i]['id']==Tableau_interfaces_assigned_i[actif_interface_select]['id']){
				Tableau_interfaces[i]['assigned']='-1';
				Tableau_interfaces[i]['group']='-1';
			}
		}
		Tableau_liaison_select[actif_liaison_select]['interfaces'].splice(actif_interface_select,1);
	}
	annuler_interface_filter();
	affiche_Tableau_interface_select();
	affiche_Tableau_interface();
}


// afficher l'interface dans le canvas
function view_interfaces_select(num_in_page){ 
        active_interface_select(num_in_page);
        id_interface = Tableau_interfaces_assigned_i[actif_interface_select].id;
        filter_interface_id(id_interface);
	change_eyes_view_interface();
}

// afficher l'interface selectionnée uniquement dans le canvas
function view_only_interface_select(num_in_page){ 
        active_interface_select(num_in_page);
        id_interface = Tableau_interfaces_assigned_i[actif_interface_select].id;
        filter_interface_only_id(id_interface);
        change_eyes_view_interface();  
}


function change_eyes_view_interface(){  
        for(i=0;i<taille_tableau_twin_right;i++){                
                strContent_visu = 'interface_twin_visu_' + i;
                id_visu_active = document.getElementById(strContent_visu);
                num_i = twin_right_tableau_connect['interface_twin'][i];
                if(Tableau_interfaces_assigned_i[num_i]){
                    id_interface_i = Tableau_interfaces_assigned_i[num_i].id;
                    if(find_id_in_id_interface_select_for_visu(id_interface_i)){
                        id_visu_active.className = "tableNC_box_visu_active on";
                    }else{
                        id_visu_active.className = "tableNC_box_visu on";
                    }
                }
        }
        for(i=0;i<taille_tableau_right;i++){             
                strContent_visu = 'interface_visu_' + i;
                id_visu_active = document.getElementById(strContent_visu);
                num_i = right_tableau_connect['interface'][i];
                if(Tableau_interfaces_filter[num_i]){
                    id_interface_i = Tableau_interfaces_filter[num_i].id;
                    if(find_id_in_id_interface_select_for_visu(id_interface_i)){
                        id_visu_active.className = "tableNC_box_visu_active on";
                    }else{
                        id_visu_active.className = "tableNC_box_visu on";
                    }
                }
        } 
        
}


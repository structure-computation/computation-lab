// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la page entière 
// -------------------------------------------------------------------------------------------------------------------------------------------

// affichage de la page matériaux
function affiche_NC_page_materiaux(){
    if(NC_current_step >= 3){
	NC_current_page = 'page_materiaux';
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

// rafraichiassement de la page matériaux
function refresh_NC_page_materiaux(){
	affiche_Tableau_mat();
	affiche_Tableau_piece();
	affiche_Tableau_mat_select();
	affiche_Tableau_piece_select();
}



// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la colone de gauche, bibliothèque des matériaux 
// -------------------------------------------------------------------------------------------------------------------------------------------

// afficher les filtres materiaux
function affich_mat_filter(){
	var id_mat_filter = document.getElementById('NC_filter_mat');
	var id_todo_mat = document.getElementById('NC_todo_mat');
	id_mat_filter.className = "on";
	id_todo_mat.className = "off";
}

// annuler et cacher les filtres materiaux
function cache_mat_filter(){
	mat_filter = new Array('','');
	var id_mat_filter = document.getElementById('NC_filter_mat');
	var id_todo_mat = document.getElementById('NC_todo_mat');
	id_mat_filter.className = "off";
	id_todo_mat.className = "on";
	affiche_Tableau_mat();
}
// annuler et cacher les filtres des materiaux
function annuler_mat_filter(){
	mat_filter = new Array('','');
	affiche_Tableau_mat();
}

// changer les filtres materiaux
function change_mat_filter(){
	var id_mat_filter_type = document.getElementById('mat_filter_type');
	var id_mat_filter_value = document.getElementById('mat_filter_value');
	mat_filter[0] = id_mat_filter_type.value;
	mat_filter[1] = id_mat_filter_value.value;
	affiche_Tableau_mat();
}


// filtrage du tableau des matériaux
function filtre_Tableau_mat(){
	Tableau_mat_filter = new Array();
	// aucun filtre
	if(mat_filter[0]=='' || mat_filter[1]==''){
		Tableau_mat_filter = Tableau_mat;
	}
	// filtre par nom
	else if(mat_filter[0]=='name'){
		if(mat_filter[1].match('[\*]')){
			mat_filter[1]= mat_filter[1].substring(0, mat_filter[1].length-1);
			for(i=0; i<Tableau_mat.length ;i++){
				if(Tableau_mat[i]['name'].match(mat_filter[1])){
					Tableau_mat_filter[Tableau_mat_filter.length] = Tableau_mat[i];
				}
			}
		}else{
			for(i=0; i<Tableau_mat.length ;i++){
				if(Tableau_mat[i]['name']==mat_filter[1]){
					Tableau_mat_filter[Tableau_mat_filter.length] = Tableau_mat[i];
				}
			}
		}
		
	}	
	// filtre par référence
	else if(mat_filter[0]=='id'){
		for(i=0; i<Tableau_mat.length ;i++){
			if(Tableau_mat[i]['id']==mat_filter[1]){
				Tableau_mat_filter[Tableau_mat_filter.length] = Tableau_mat[i];
			}
		}
	}	
}

// affichage du tableau des matériaux
function affiche_Tableau_mat(){
	taille_tableau_left = 20;
	filtre_Tableau_mat();
	var current_tableau = Tableau_mat_filter;
	var strname = 'mat';
	var stridentificateur = 'name';
	affiche_Tableau_left(current_tableau,strname,stridentificateur);
}

// ajout d'un matériaux à la selection
function select_mat(num){
	var taille_Tableau_mat_select = Tableau_mat_select.length;
	var num_select = left_tableau_connect['mat'][num];
	Tableau_mat_select[taille_Tableau_mat_select]=new Array();
	Tableau_mat_select[taille_Tableau_mat_select]=clone(Tableau_mat_filter[num_select]);
	Tableau_mat_select[taille_Tableau_mat_select]['id_select'] = compteur_mat_select;
	Tableau_mat_select[taille_Tableau_mat_select]['name_select'] = "mat_select_" + compteur_mat_select;
	compteur_mat_select = compteur_mat_select + 1;
	//alert(compteur_mat_select);
	Tableau_mat_select[taille_Tableau_mat_select]['pieces']=new Array();
	twin_left_tableau_current_page['mat_twin'] = twin_left_tableau_liste_page['mat_twin'].length-1;
	affiche_Tableau_mat_select();
}

// affiche la page num pour la bibliothèque matériaux
function go_page_mat(num){
	if(num=='first'){
		left_tableau_current_page['mat'] = 0;
	}else if(num=='end'){
		left_tableau_current_page['mat'] = left_tableau_liste_page['mat'].length;
	}else{
		var num_page = num + left_tableau_curseur_page['mat'];
		left_tableau_current_page['mat']=left_tableau_liste_page['mat'][num_page]-1;	
	}
	affiche_Tableau_mat();
}


// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la colone de droite, liste des pièces 
// -------------------------------------------------------------------------------------------------------------------------------------------

// afficher les filtres des pieces
function affich_piece_filter(){
	var id_filter_piece = document.getElementById('NC_filter_piece');
	var id_todo_piece = document.getElementById('NC_todo_piece');
	id_filter_piece.className = "on";
	id_todo_piece.className = "off";
}

// annuler et cacher les filtres des pieces
function cache_piece_filter(){
	piece_filter = new Array('','');
	var id_filter_piece = document.getElementById('NC_filter_piece');
	var id_todo_piece = document.getElementById('NC_todo_piece');
	id_filter_piece.className = "off";
	id_todo_piece.className = "on";
	affiche_Tableau_piece();
}
// annuler et cacher les filtres des pieces
function annuler_piece_filter(){
	piece_filter = new Array('','');
	affiche_Tableau_piece();
}

// changer les filtres pieces
function change_piece_filter(){
	var id_piece_filter_type = document.getElementById('piece_filter_type');
	var id_piece_filter_value = document.getElementById('piece_filter_value');
	piece_filter[0] = id_piece_filter_type.value;
	piece_filter[1] = id_piece_filter_value.value;
	//affiche_Tableau_piece();
}

// filtrage du tableau des piece (par références)
function filtre_Tableau_pieces(){
	groupe_pieces_temp = new Array();
	Tableau_pieces_filter = new Array();
	Tableau_pieces_assigned = new Array();
	Tableau_pieces_not_assigned = new Array(); 
	for(i=0; i<Tableau_pieces.length ;i++){
		if(Tableau_pieces[i]['assigned']==-1){
			Tableau_pieces[i]['group']=-1;
			Tableau_pieces_not_assigned[Tableau_pieces_not_assigned.length]=Tableau_pieces[i];
		}else{
			Tableau_pieces_assigned[Tableau_pieces_assigned.length]=Tableau_pieces[i];
		}
	}
	// aucun filtre
	if(piece_filter[0]=='' || piece_filter[1]==''){
		for(i=0; i<Tableau_pieces_not_assigned.length ;i++){
			Tableau_pieces_filter[Tableau_pieces_filter.length] = Tableau_pieces_not_assigned[i];
		}
	}
	// filtre par nom
	else if(piece_filter[0]=='name'){
		if(piece_filter[1].match('[\*]')){
			piece_filter[1]= piece_filter[1].substring(0, piece_filter[1].length-1);
			for(i=0; i<Tableau_pieces_not_assigned.length ;i++){
				if(Tableau_pieces_not_assigned[i]['name'].match(piece_filter[1])){
					groupe_pieces_temp[groupe_pieces_temp.length] = Tableau_pieces_not_assigned[i];
				}
			}
		}else{
			for(i=0; i<Tableau_pieces_not_assigned.length ;i++){
				if(Tableau_pieces_not_assigned[i]['name']==piece_filter[1]){
					groupe_pieces_temp[groupe_pieces_temp.length] = Tableau_pieces_not_assigned[i];
				}
			}
		}
		if(groupe_pieces_temp.length > 1){
			Tableau_pieces_filter[0]=new Array();
			Tableau_pieces_filter[0]['id']=groupe_pieces.length;
			Tableau_pieces_filter[0]['name']='group_' + groupe_pieces.length;
			Tableau_pieces_filter[0]['group'] = 'true';
			Tableau_pieces_filter[0]['assigned'] = '-1';
			Tableau_pieces_filter[0]['type']= piece_filter[0];
			Tableau_pieces_filter[0]['value']= piece_filter[1];
			Tableau_pieces_filter[0]['nb_pieces']= groupe_pieces_temp.length ;
			for(i=0; i<groupe_pieces_temp.length ;i++){
				groupe_pieces_temp[i]['group']=Tableau_pieces_filter[0]['id'];
				Tableau_pieces_filter[i+1]=groupe_pieces_temp[i];
			}
		}else{
			Tableau_pieces_filter=groupe_pieces_temp;
		}
	}
	// filtre par nom
	else if(piece_filter[0]=='between_2_ids'){  
	    group_piece_id_st = piece_filter[1].split(";");
	    //alert(group_piece_id_st.length);
	    for(ng=0; ng<group_piece_id_st.length; ng++){
		piece_id_st = group_piece_id_st[ng].split(",");

		piece_id = new Array();
		piece_id[0] = parseFloat(piece_id_st[0]);
		piece_id[1] = parseFloat(piece_id_st[1]);

		for(i=0; i<Tableau_pieces_not_assigned.length ;i++){
			if(Tableau_pieces_not_assigned[i].id >= piece_id[0] && Tableau_pieces_not_assigned[i].id <= piece_id[1]){
				groupe_pieces_temp[groupe_pieces_temp.length] = Tableau_pieces_not_assigned[i];
			}
		}
	    }
	    if(groupe_pieces_temp.length > 1){
		    Tableau_pieces_filter[0]=new Array();
		    Tableau_pieces_filter[0]['id']=groupe_pieces.length;
		    Tableau_pieces_filter[0]['name']='group_' + groupe_pieces.length;
		    Tableau_pieces_filter[0]['group'] = 'true';
		    Tableau_pieces_filter[0]['assigned'] = '-1';
		    Tableau_pieces_filter[0]['type']= piece_filter[0];
		    Tableau_pieces_filter[0]['value']= piece_filter[1];
		    Tableau_pieces_filter[0]['nb_pieces']= groupe_pieces_temp.length ;
		    for(i=0; i<groupe_pieces_temp.length ;i++){
			    groupe_pieces_temp[i]['group']=Tableau_pieces_filter[0]['id'];
			    Tableau_pieces_filter[i+1]=groupe_pieces_temp[i];
		    }
	    }else{
		    Tableau_pieces_filter=groupe_pieces_temp;
	    }    
	}
	
	
}

// affichage du tableau des pièces
function affiche_Tableau_piece(){
	filtre_Tableau_pieces();
	var current_tableau = Tableau_pieces_filter;
	var strname = 'piece';
	var stridentificateur = 'name';
	affiche_Tableau_right(current_tableau,strname,stridentificateur);
}

// selectionner (activer) un une piece
function active_piece(id){
        var num_select_local = -1; 
        var id_select_local = -1; 
        for(i=0;i<Tableau_pieces_filter.length;i++){
                if(Tableau_pieces_filter[i]['id'] == id) {
                      num_select_local = i;
                      id_select_local = id;
                      break;
                }
        }
        if(num_select_local != -1){
                num_page = Math.floor(num_select_local/taille_tableau_right);
                num_in_page = num_select_local - num_page * taille_tableau_right;
                go_page_piece(num_page);
                affich_active_pieces(num_in_page)
        }
}

// afficher la piece actif dans la twin box left
function affich_active_pieces(num_in_page){ 
        //alert(num_in_page);
        for(i=0;i<taille_tableau_right;i++){
                strContent_1 = new String();
                strContent_1 = 'piece_1_' + i;
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


// ajout d'une piece au matériaux selectionné actif
function select_pieces_mat(num){
	if(id_actif_mat_select != -1){
		var num_select = right_tableau_connect['piece'][num];
		if(Tableau_pieces_filter[num_select]['group']=='true'){ 	// si on assigne un groupe entier (num_select = 0)
			var taille_tableau = Tableau_mat_select[actif_mat_select]['pieces'].length;
			for(i=0; i<Tableau_pieces_filter.length ;i++){
				Tableau_pieces_filter[i]['assigned']=Tableau_mat_select[actif_mat_select]['id_select'];
				var i_temp = i + taille_tableau;
				Tableau_mat_select[actif_mat_select]['pieces'][i_temp] = clone(Tableau_pieces_filter[i]);
			}
			groupe_pieces[groupe_pieces.length] = clone(Tableau_pieces_filter[num_select]);
		}else{														// si on assigne une seule piece
			Tableau_pieces_filter[num_select]['assigned']=Tableau_mat_select[actif_mat_select]['id_select'];
			var i_temp = Tableau_mat_select[actif_mat_select]['pieces'].length;
			Tableau_mat_select[actif_mat_select]['pieces'][i_temp]=clone(Tableau_pieces_filter[num_select]);
		}
		twin_right_tableau_current_page['piece_twin'] = twin_right_tableau_liste_page['piece_twin'].length-1;
		affiche_Tableau_piece_select();
		affiche_Tableau_piece();
	}
}

// affiche la page num pour la liste des pièces
function go_page_piece(num){
	if(num=='first'){
		right_tableau_current_page['piece'] = 0;
	}else if(num=='end'){
		right_tableau_current_page['piece'] = right_tableau_liste_page['piece'].length;
	}else{
		var num_page = num + right_tableau_curseur_page['piece'];
		right_tableau_current_page['piece']=right_tableau_liste_page['piece'][num_page]-1;	
	}
	affiche_Tableau_piece();
}


// afficher la piece sur le canvas
function view_pieces(num_in_page){ 
        num_select = right_tableau_connect['piece'][num_in_page];
        id_piece = Tableau_pieces_filter[num_select].id;
        filter_piece_id(id_piece);    
        change_eyes_view_piece();       
}

// afficher la piece sur le canvas
function view_only_piece(num_in_page){  
        num_select = right_tableau_connect['piece'][num_in_page];
        id_piece = Tableau_pieces_filter[num_select].id;
        filter_piece_only_id(id_piece); 
        change_eyes_view_piece();
}

// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la colone twin_left de la page active, liste des matériaux selectionnés 
// -------------------------------------------------------------------------------------------------------------------------------------------

// affichage du tableau des matériaux selectionnés
function affiche_Tableau_mat_select(){
	var current_tableau = Tableau_mat_select;
	var strname = 'mat_twin';
	var stridentificateur = 'name_select';
	affiche_Tableau_twin_left(current_tableau,strname,stridentificateur);
	affich_active_mat_select();
}

// selectionner (activer) un matériaux de la selection pour lui ajouter des attribut ou le supprimer
function active_mat_select(num){
	var num_select = twin_left_tableau_connect['mat_twin'][num];
	actif_mat_select = num_select ;
	id_actif_mat_select = num ;
	twin_right_tableau_current_page['mat_twin']=0;
	affich_active_mat_select();
	affiche_Tableau_piece_select();
}

// afficher le matériaux actif dans la twin box left
function affich_active_mat_select(){
	if(id_actif_mat_select != -1){
		var taille_Tableau_mat_select = Tableau_mat_select.length;
		for(i=0;i<taille_tableau_twin_left;i++){
			strContent_1 = new String();
			strContent_1 = 'mat_twin_1_' + i;
			var id_active = document.getElementById(strContent_1);
			if(id_active.className != "tableNC_twin_box_0 off"){
				if(i==id_actif_mat_select){
					id_active.className = "tableNC_twin_box_0_active on";
				}else{
					id_active.className = "tableNC_twin_box_0 on";
				}
			}
		}
	}
}

// affiche la page num pour les matériaux selectionnés et selectione le premier element
function go_page_mat_select(num){
	if(num=='first'){
		twin_left_tableau_current_page['mat_twin'] = 0;
	}else if(num=='end'){
		twin_left_tableau_current_page['mat_twin'] = twin_left_tableau_liste_page['mat_twin'].length-1;
	}else{
		var num_page = num + twin_left_tableau_curseur_page['mat_twin'];
		twin_left_tableau_current_page['mat_twin']=twin_left_tableau_liste_page['mat_twin'][num_page]-1;	
	}
	affiche_Tableau_mat_select();
	active_mat_select(0);
}

// supprimer le matériaux actif
function suppr_mat_select(num){
	active_mat_select(num);
	for(i=0; i<Tableau_pieces.length ;i++){
		if(Tableau_pieces[i]['assigned']==Tableau_mat_select[actif_mat_select]['id_select']){
			Tableau_pieces[i]['assigned']='-1';
			Tableau_pieces[i]['group']='-1';
		}
	}
	Tableau_mat_select.splice(actif_mat_select,1);
	twin_right_tableau_current_page['piece_twin']=0;
	actif_mat_select = -1;
	id_actif_mat_select = -1;
	annuler_piece_filter();
	affiche_Tableau_mat_select();
	affiche_Tableau_piece_select();
	affiche_Tableau_piece();
}


// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la colone twin_right de la page active, liste des pieces associées au matériaux actif 
// -------------------------------------------------------------------------------------------------------------------------------------------

// construction du tableau des pieces du matériaux actif
function build_Tableau_piece_select(){
	Tableau_pieces_assigned_i = new Array();	
	Tableau_pieces_assigned_i = Tableau_mat_select[actif_mat_select]['pieces'];
}

// affichage du tableau des pieces du matériaux actif
function affiche_Tableau_piece_select(){
	if(actif_mat_select==-1){
		var current_tableau = ["null"];
		var strname = 'piece_twin';
		var stridentificateur = 'name';
		affiche_Tableau_twin_right(current_tableau,strname,stridentificateur);
	}else{
		build_Tableau_piece_select();
		var current_tableau = Tableau_pieces_assigned_i;
		var strname = 'piece_twin';
		var stridentificateur = 'name';
		affiche_Tableau_twin_right(current_tableau,strname,stridentificateur);
	}
	actif_piece_select = -1 ;
	id_actif_piece_select = -1 ;
	affich_active_piece_select();
}

// affiche la page num pour la liste des pièces selectionnées
function go_page_piece_select(num){
	if(num=='first'){
		twin_right_tableau_current_page['piece_twin'] = 0;
	}else if(num=='end'){
		twin_right_tableau_current_page['piece_twin'] = twin_right_tableau_liste_page['piece_twin'].length-1;
	}else{
		var num_page = num + twin_right_tableau_curseur_page['piece_twin'];
		twin_right_tableau_current_page['piece_twin']=twin_right_tableau_liste_page['piece_twin'][num_page]-1;	
	}
	affiche_Tableau_piece_select();
}

// selectionner (activer) une piece du matériaux actif pour la supprimer
function active_piece_select(num){
	var num_select = twin_right_tableau_connect['piece_twin'][num];
	actif_piece_select = num_select ;
	id_actif_piece_select = num ;
	affich_active_piece_select();
}

// afficher le matériaux actif dans la twin box left
function affich_active_piece_select(){
	if(id_actif_piece_select != -1){
		//var taille_Tableau_piece_select = Tableau_pieces_assigned_i.length;
		for(i=0;i<taille_tableau_twin_right;i++){
			strContent_1 = new String();
			strContent_1 = 'piece_twin_1_' + i;
			var id_active = document.getElementById(strContent_1);
			if(id_active.className != "tableNC_twin_box_0 off"){
				if(i==id_actif_piece_select){
					id_active.className = "tableNC_twin_box_0_active on";
				}else{
					id_active.className = "tableNC_twin_box_0 on";
				}
			}
		}
	}
}

// enlever la piece active de la selection pour le matériaux actif_mat_select
function suppr_piece_select(num){
	active_piece_select(num);
	if(Tableau_pieces_assigned_i[actif_piece_select]['group']=='true'){
		var taille_groupe = 1;
		for(i=0; i<Tableau_mat_select[actif_mat_select]['pieces'].length ;i++){
			if(Tableau_mat_select[actif_mat_select]['pieces'][i]['group']==Tableau_pieces_assigned_i[actif_piece_select]['id']){
				taille_groupe = taille_groupe+1;
			}
		}
		Tableau_pieces_assigned_i[actif_piece_select]['assigned']='-1';
		for(i=0; i<Tableau_pieces.length ;i++){
			if(Tableau_pieces[i]['group']==Tableau_pieces_assigned_i[actif_piece_select]['id']){
				Tableau_pieces[i]['assigned']='-1';
				Tableau_pieces[i]['group']='-1';
			}
		}
		Tableau_mat_select[actif_mat_select]['pieces'].splice(actif_piece_select,taille_groupe);
	}else{
		for(i=0; i<Tableau_pieces.length ;i++){
			if(Tableau_pieces[i]['id']==Tableau_pieces_assigned_i[actif_piece_select]['id']){
				Tableau_pieces[i]['assigned']='-1';
				Tableau_pieces[i]['group']='-1';
			}
		}
		Tableau_mat_select[actif_mat_select]['pieces'].splice(actif_piece_select,1);
	}
	annuler_piece_filter();
	affiche_Tableau_piece_select();
	affiche_Tableau_piece();	
}

// afficher la piece sur le canvas
function view_piece_select(num_in_page){ 
	active_piece_select(num_in_page);
        id_piece = Tableau_pieces_assigned_i[actif_piece_select].id;
        filter_piece_id(id_piece);      
        change_eyes_view_piece();
}

// afficher la piece sur le canvas
function view_only_piece_select(num_in_page){  
        active_piece_select(num_in_page);
        id_piece = Tableau_pieces_assigned_i[actif_piece_select].id;
        filter_piece_only_id(id_piece); 
        change_eyes_view_piece();
}


function change_eyes_view_piece(){ 
        
        for(i=0;i<taille_tableau_twin_right;i++){           
            strContent_visu = 'piece_twin_visu_' + i;
            id_visu_active = document.getElementById(strContent_visu);
            num_i = twin_right_tableau_connect['piece_twin'][i];
            if(Tableau_pieces_assigned_i[num_i]){
                id_piece_i = Tableau_pieces_assigned_i[num_i].id;
                if(find_id_in_id_piece_select_for_visu(id_piece_i)){
                    id_visu_active.className = "tableNC_box_visu_active on";
                }else{
                    id_visu_active.className = "tableNC_box_visu on";
                }
            }
        }
        for(i=0;i<taille_tableau_right;i++){              
            strContent_visu = 'piece_visu_' + i;
            var id_visu_active = document.getElementById(strContent_visu);

            num_i = right_tableau_connect['piece'][i];
            if(Tableau_pieces_filter[num_i]){
                id_piece_i = Tableau_pieces_filter[num_i].id;
                if(find_id_in_id_piece_select_for_visu(id_piece_i)){
                    id_visu_active.className = "tableNC_box_visu_active on";
                }else{
                    id_visu_active.className = "tableNC_box_visu on";
                }
            }
        } 
        
}

// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la page entière 
// -------------------------------------------------------------------------------------------------------------------------------------------

// affichage de la page matériaux
function affiche_NC_page_options(){
    if(NC_current_step >= 6){
        affich_prop_visu('visu');
        NC_current_page = 'page_options';
        affiche_NC_page('off','off');
        if(NC_current_scroll=='right'){
            NC_scroll(NC_current_scroll);
        }
        select_option(Tableau_option_select['mode']);
        document.getElementById('NC_footer_top_init').className = 'off';
        document.getElementById('NC_footer_top_suiv').className = 'on';
        document.getElementById('NC_footer_top_valid').className = 'off';
    }else{
        alert('vous devez valider les étapes précédentes pour accéder à cette page');
    }
}

// affichage des boites d'option
function affich_box_opt(num){
	str_id = "#NC_options_active_box_" + num;
	str_id_triangle = "NC_top_box_opt_" + num;
	if(current_state_active_box_opt[num]=='off'){
		$(str_id).slideDown("slow",equal_height_NC_fake);
		id_triangle = document.getElementById(str_id_triangle);	
		id_triangle.className = 'NC_triangle_bas';
		current_state_active_box_opt[num]='on';
	}else if(current_state_active_box_opt[num]=='on'){
		$(str_id).slideUp("slow",equal_height_NC_fake);
		id_triangle = document.getElementById(str_id_triangle);	
		id_triangle.className = 'NC_triangle_cote';
		current_state_active_box_opt[num]='off';
	}
}



// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la colone de gauche, bibliothèque des calcul 
// -------------------------------------------------------------------------------------------------------------------------------------------


// tout deselectionner
function deselect_option(){
	var Tableau_deselect_option = new Array();
	Tableau_deselect_option['test'] = 1;
	Tableau_deselect_option['normal'] = 3;
	Tableau_deselect_option['expert'] = 6;
	
	
	for(key in Tableau_deselect_option){
		var str_0 = "page_options_" + key + "_bouton";
		var id_0 = document.getElementById(str_0);
		id_0.className = "NC_box_radio_select";
		for(i=1;i<Tableau_deselect_option[key];i++){
			str_i = "page_options_" + key + "_bouton_" + i;
			//if(key=='normal') alert(str_i);
			var id_i = document.getElementById(str_i);
			id_i.className = "NC_box_check_select";
		}
	}
}

// afficher option selectionné
function affich_option(key){		
	var str_0 = "page_options_" + key + "_bouton";
	var id_0 = document.getElementById(str_0);
	id_0.className = "NC_box_radio_select actif";
	for(i=1 ;i<Tableau_option_select['nb_option']+1 ;i++){
		str_i = "page_options_" + key + "_bouton_" + i;
		var id_i = document.getElementById(str_i);
		if(id_i != null) id_i.className = "NC_box_check_select actif";	
	}
}


// selectionner les options utilisées
function select_option(str){
	deselect_option();
	if(str=='test'){
		Tableau_option_select = Tableau_option_test;
		for(key in Tableau_option_select){
			if(key == 'mode' || key == 'nb_option'){
			}else if(key == 'LATIN_multiechelle'){
				change_opt_LATIN_multiechelle_value(Tableau_option_select[key]);
			}else{
				str_temp = new String();
				str_temp = 'opt_' + key;
				id_active = document.getElementById(str_temp);
				if(id_active != null){
					id_active.value = Tableau_option_select[key];
					id_active.disabled = true;
				}
				
			}
		}
		affich_option(str);
//		str_0 = "page_options_test_bouton";
//		var id_0 = document.getElementById(str_0);
//		id_0.className = "NC_box_radio_select actif";
		
	}else if(str=='normal'){
		Tableau_option_select = Tableau_option_normal;
		for(key in Tableau_option_select){
			if(key == 'mode' || key == 'nb_option'){
			}else if(key == 'LATIN_multiechelle'){
				change_opt_LATIN_multiechelle_value(Tableau_option_select[key]);
			}else{
				str_temp = new String();
				str_temp = 'opt_' + key;
				id_active = document.getElementById(str_temp);
				if(id_active != null){
					id_active.value = Tableau_option_select[key];
					id_active.disabled = false;
				}
			}
		}
		affich_option(str);
//		str_0 = "page_options_normal_bouton";
//		var id_0 = document.getElementById(str_0);
//		id_0.className = "NC_box_radio_select actif";
//		
//		for(i=1;i<3;i++){
//			str_i = "page_options_normal_bouton_" + i;
//			var id_i = document.getElementById(str_i);
//			id_i.className = "NC_box_check_select actif";
//		}
	}
}

// on change une valeur des options
function change_opt_value(key){
	str_temp = 'opt_' + key;
	id_active = document.getElementById(str_temp);
	Tableau_option_select[key] = parseFloat(id_active.value) ;
	affich_option(Tableau_option_select['mode']);
}

function change_opt_LATIN_multiechelle_value(interupteur){
	if(Tableau_option_select["mode"] == 'test'){
		interupteur = 1;
	}
	id_active = document.getElementById("opt_LATIN_multiechelle_actif");
	id_inactive = document.getElementById("opt_LATIN_multiechelle_inactif");
	if(interupteur==1){
		Tableau_option_select["LATIN_multiechelle"] = 1 ;
		id_active.className = "NC_box_radio_select actif";
		id_inactive.className = "NC_box_radio_select";
	}else if(interupteur==0){
		Tableau_option_select["LATIN_multiechelle"] = 0 ;
		id_active.className = "NC_box_radio_select";
		id_inactive.className = "NC_box_radio_select actif";
	}

}

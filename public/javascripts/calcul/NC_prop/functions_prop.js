<!--

// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des des blocs de propriete :
// ('mat', 'liaison', 'CL')
// -------------------------------------------------------------------------------------------------------------------------------------------

// on cache les propriété de dim 3 quand on est en dim = 2
function hide_dim_3(){
	if(dim_model==2){
		str_dim3 = 'prop_dim_3';
		str_dim3_in = 'prop_dim_3_in';
		id_dim3 = document.getElementsByName(str_dim3);
		id_dim3_in = document.getElementsByName(str_dim3_in);
		var strClass = 'off';
		for(n3=0;n3<id_dim3.length;n3++){
			id_dim3[n3].className = strClass ;
		}
		for(n3=0;n3<id_dim3_in.length;n3++){
			id_dim3_in[n3].className = strClass ;
		}
	}	
}

function prop_bloc_affich(name_prop){
	hide_dim_3();
	if(name_prop=='mat'){
		document.getElementById('prop_materiaux').className = "on";
		document.getElementById('prop_liaisons').className = "off";
		document.getElementById('prop_CLs').className = "off";
		document.getElementById('prop_CLvolume').className = "off";
		document.getElementById('prop_bords').className = "off";
	}else if(name_prop=='liaison'){
		document.getElementById('prop_materiaux').className = "off";
		document.getElementById('prop_liaisons').className = "on";
		document.getElementById('prop_CLs').className = "off";
		document.getElementById('prop_CLvolume').className = "off";
		document.getElementById('prop_bords').className = "off";
	}else if(name_prop=='CL'){
		document.getElementById('prop_materiaux').className = "off";
		document.getElementById('prop_liaisons').className = "off";
		document.getElementById('prop_CLs').className = "on";
		document.getElementById('prop_CLvolume').className = "off";
		document.getElementById('prop_bords').className = "off";
	}else if(name_prop=='CLv'){
		document.getElementById('prop_materiaux').className = "off";
		document.getElementById('prop_liaisons').className = "off";
		document.getElementById('prop_CLs').className = "off";
		document.getElementById('prop_CLvolume').className = "on";
		document.getElementById('prop_bords').className = "off";
	}else if(name_prop=='bord'){
		document.getElementById('prop_materiaux').className = "off";
		document.getElementById('prop_liaisons').className = "off";
		document.getElementById('prop_CLs').className = "off";
		document.getElementById('prop_CLvolume').className = "off";
		document.getElementById('prop_bords').className = "on";
	}
}


// visualisation des infos sur un element selectionné
function info_select(strinfo,num){
	if(strinfo=='mat' || strinfo=='mat_twin' || strinfo=='piece_twin'){
		refresh_NC_page_materiaux();
	}
	if(strinfo=='liaison' || strinfo=='liaison_twin' || strinfo=='interface_twin'){
		refresh_NC_page_liaisons();
	}
	if(strinfo=='CL' || strinfo.match('CLv') || strinfo=='CL_twin' || strinfo=='bord' || strinfo=='bord_twin'){
		refresh_NC_page_CLs();
	}
	selected_for_info = [strinfo,num];
	strContent_14 = new String();
	strContent_14 = strinfo + '_14_' + num ;
	var id_14 = document.getElementById(strContent_14);
	id_14.className = "tableNC_box_4 select";
	affich_prop_visu('prop');	
	
	if(strinfo=='mat'){
		document.getElementById('NC_top_box_prop').className = 'NC_top_box_center';
		var num_select = left_tableau_connect[strinfo][num];
		prop_mat_for_info = Tableau_mat_filter[num_select];
		prop_mat_affich_info();
	}
	if(strinfo=='mat_twin'){
		active_mat_select(num);
		document.getElementById('NC_top_box_prop').className = 'NC_top_active_box';
		var num_select = twin_left_tableau_connect[strinfo][num];
		prop_mat_for_info = Tableau_mat_select[num_select];
		prop_mat_affich_info();
	}
	if(strinfo=='liaison'){
		document.getElementById('NC_top_box_prop').className = 'NC_top_box_center';
		var num_select = left_tableau_connect[strinfo][num];
		prop_liaison_for_info = Tableau_liaison_filter[num_select];
		prop_liaison_affich_info();
	}
	if(strinfo=='liaison_twin'){
		active_liaison_select(num);
		document.getElementById('NC_top_box_prop').className = 'NC_top_active_box';
		var num_select = twin_left_tableau_connect[strinfo][num];
		prop_liaison_for_info = Tableau_liaison_select[num_select];
		prop_liaison_affich_info();
	}
	if(strinfo=='CL'){
		document.getElementById('NC_top_box_prop').className = 'NC_top_box_center';
		var num_select = left_tableau_connect[strinfo][num];
		prop_CL_for_info = Tableau_CL[num_select];
		prop_CL_affich_info();
	}
	if(strinfo=='CLv'){
		document.getElementById('NC_top_box_prop').className = 'NC_top_active_box';
		var num_select = num;
		prop_CL_for_info = Tableau_CL_select_volume[num_select];
		
		if(num_select == 0){  //le poids
			prop_CLv_affich_info('poids');
		}else if(num_select == 1){ //l'accéleration
			prop_CLv_affich_info('acceleration');
		}else if(num_select == 2){ //les efforts centrifuges
			prop_CLv_affich_info('centrifuge');
		}
	}
	if(strinfo=='CL_twin'){
		active_CL_select(num);
		document.getElementById('NC_top_box_prop').className = 'NC_top_active_box';
		var num_select = twin_left_tableau_connect[strinfo][num];
		prop_CL_for_info = Tableau_CL_select[num_select];
		prop_CL_select_affich_info();
	}
	if(strinfo=='bord'){
		document.getElementById('NC_top_box_prop').className = 'NC_top_active_box';
		var num_select = right_tableau_connect[strinfo][num];
		Tableau_bords_for_info = Tableau_bords_filter[num_select];
		Tableau_bords_affich_info();
	}
	if(strinfo=='bord_twin'){
		document.getElementById('NC_top_box_prop').className = 'NC_top_active_box';
		var num_select = twin_right_tableau_connect[strinfo][num];
		Tableau_bords_for_info = Tableau_bords_assigned_i[num_select];
		Tableau_bords_affich_info();
	}
}

function create_bord(){
	affich_prop_visu('prop');
	document.getElementById('NC_top_box_prop').className = 'NC_top_active_box';
	Tableau_bords_for_info = clone(Tableau_bords_test);
	Tableau_bords_affich_info();
}

// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des différentes propriété matériaux :
// ('prop_mat_generique', 'prop_mat_elastique', 'prop_mat_plastique', 'prop_mat_endomagement', 'prop_mat_visqueux')
// -------------------------------------------------------------------------------------------------------------------------------------------

// afficher une page et cacher les autres
function prop_mat_affich(name_prop){
	var affiche_on = name_prop;
	var affiche_off = new Array('info','generique', 'elastique', 'plastique', 'endomageable','visqueux');
	var taille_off = new Number(affiche_off.length);
	
	// on cache tout
	for(i_off=0; i_off<taille_off; i_off++){
		var className_page = "NC_prop_box off";
		var strContent_prop_page = 'prop_mat_' + affiche_off[i_off] ;
		//alert(strContent_prop_page);
		var id_prop_page = document.getElementById(strContent_prop_page);
		id_prop_page.className = className_page ;
		
		var className_menu = "";
		var strContent_prop_menu = 'prop_mat_menu_' + affiche_off[i_off] ;
		var id_prop_menu = document.getElementById(strContent_prop_menu);
		if(id_prop_menu.className.match('off')){
		}else{
			id_prop_menu.className = className_menu ;
		}
		
	}
	
	// on affiche les éléments de la bonne page
	var className_page = "NC_prop_box on";
	var strContent_prop_page = 'prop_mat_' + affiche_on ;
	var id_prop_page = document.getElementById(strContent_prop_page);
	id_prop_page.className = className_page ;
	
	var className_menu = "selected";
	var strContent_prop_menu = 'prop_mat_menu_' + affiche_on ;
	var id_prop_menu = document.getElementById(strContent_prop_menu);
	id_prop_menu.className = className_menu ;
	
	equal_height_NC_fake();	
}


// afficher les propriété du matériaux à visualiser 
function prop_mat_affich_info(){
	// prop_mat_for_info est le matériaux sélectionné
	// on rempli le cartouche top du matériaux pour info
	for(key in prop_mat_for_info){
		if(key=='name'){
			var strContent_prop_key = 'prop_mat_top_' + key ;
			var id_prop_key = document.getElementById(strContent_prop_key);
			if(id_prop_key != null){
				remplacerTexte(id_prop_key, prop_mat_for_info[key]);
			}
		}
		if(key=='ref'){
			var strContent_prop_key = 'prop_mat_top_' + key ;
			var id_prop_key = document.getElementById(strContent_prop_key);
			if(id_prop_key != null){
				remplacerTexte(id_prop_key, prop_mat_for_info[key]);
			}
		}
		if(key=='mtype'){
			var strContent_prop_isotrope = 'prop_mat_top_isotrope' ;
			var strContent_prop_orthotrope = 'prop_mat_top_orthotrope'  ;
			var id_prop_isotrope = document.getElementById(strContent_prop_isotrope);
			var id_prop_orthotrope = document.getElementById(strContent_prop_orthotrope);
			if(prop_mat_for_info[key] == 'isotrope') {
				id_prop_isotrope.className = "NC_box_radio_prop actif";
				id_prop_orthotrope.className = "NC_box_radio_prop";
				for(dim=2; dim<=3; dim++){
					str_dim = 'prop_dim_' + dim;
					str_dim_in = 'prop_dim_' + dim + '_in';
					id_dim = document.getElementsByName(str_dim);
					id_dim_in = document.getElementsByName(str_dim_in);
					var strClass = 'off';
					for(n2=0;n2<id_dim.length;n2++){
						id_dim[n2].className = strClass ;
					}
					for(n2=0;n2<id_dim_in.length;n2++){
						id_dim_in[n2].className = strClass ;
					}
				}	
			}else if(prop_mat_for_info[key] == 'orthotrope') {
				id_prop_isotrope.className = "NC_box_radio_prop";
				id_prop_orthotrope.className = "NC_box_radio_prop actif";
				for(dim=2; dim<=3; dim++){
					str_dim = 'prop_dim_' + dim;
					id_dim = document.getElementsByName(str_dim);
					str_dim_in = 'prop_dim_' + dim + '_in';
					id_dim_in = document.getElementsByName(str_dim_in);
					var strClass = 'on';
					if(dim > dim_model) strClass = "off";
					for(n2=0;n2<id_dim.length;n2++){
						id_dim[n2].className = strClass ;
					}
					for(n2=0;n2<id_dim_in.length;n2++){
						id_dim_in[n2].className = strClass ;
					}
				}		
			}
		}
		if(key=='comp'){
			var strContent_prop_elastique = 'prop_mat_top_elastique' ;
			var strContent_prop_plastique = 'prop_mat_top_plastique'  ;
			var strContent_prop_endomageable = 'prop_mat_top_endomageable'  ;
			var strContent_prop_visqueux = 'prop_mat_top_visqueux'  ;
			
			var id_prop_elastique = document.getElementById(strContent_prop_elastique);
			var id_prop_plastique = document.getElementById(strContent_prop_plastique);
			var id_prop_endomageable = document.getElementById(strContent_prop_endomageable);
			var id_prop_visqueux = document.getElementById(strContent_prop_visqueux);
			//elastique
			if(prop_mat_for_info[key].match('el')){
				id_prop_elastique.className = "NC_box_check_prop actif";
				var id_prop_menu = document.getElementById('prop_mat_menu_elastique');
				id_prop_menu.className = "on";
			}else{ 
				id_prop_elastique.className = "NC_box_check_prop";
				var id_prop_menu = document.getElementById('prop_mat_menu_elastique');
				id_prop_menu.className = "off";
			}
			//plastique
			if(prop_mat_for_info[key].match('pl')){
				id_prop_plastique.className = "NC_box_check_prop actif";
				var id_prop_menu = document.getElementById('prop_mat_menu_plastique');
				id_prop_menu.className = "on";
			}else{ 
				id_prop_plastique.className = "NC_box_check_prop";
				var id_prop_menu = document.getElementById('prop_mat_menu_plastique');
				id_prop_menu.className = "off";
			}
			//endomageable
			if(prop_mat_for_info[key].match('en')){
				id_prop_endomageable.className = "NC_box_check_prop actif";
				var id_prop_menu = document.getElementById('prop_mat_menu_endomageable');
				id_prop_menu.className = "on";
			}else{ 
				id_prop_endomageable.className = "NC_box_check_prop";
				var id_prop_menu = document.getElementById('prop_mat_menu_endomageable');
				id_prop_menu.className = "off";
			}
			//visqueux	
			if(prop_mat_for_info[key].match('vi')){
				id_prop_visqueux.className = "NC_box_check_prop actif";
				var id_prop_menu = document.getElementById('prop_mat_menu_visqueux');
				id_prop_menu.className = "on";
			}else{ 
				id_prop_visqueux.className = "NC_box_check_prop";
				var id_prop_menu = document.getElementById('prop_mat_menu_visqueux');
				id_prop_menu.className = "off";
			}		
		}
	}
	prop_bloc_affich('mat');	
	prop_mat_affich('info');
	
	// on rempli les propriété du matériaux
	//alert(prop_mat_for_info['id_select']);
	for(key in prop_mat_for_info){
		var strContent_prop_key = 'prop_mat_' + key ;
		var id_prop_key = document.getElementById(strContent_prop_key);
		if(id_prop_key != null){
			id_prop_key.value = prop_mat_for_info[key] ;
			if(prop_mat_for_info['id_select']== null){
				id_prop_key.disabled = true;
			}else{ 
				id_prop_key.disabled = false;
			}
		}
	}	
}



//changer les propriétés d'un matériaux
function prop_mat_change_value(){
	for(key in prop_mat_for_info){
		var strContent_prop_key = 'prop_mat_' + key ;
		var id_prop_key = document.getElementById(strContent_prop_key);
		if(id_prop_key != null){
			prop_mat_for_info[key] = id_prop_key.value ;
		}
	}
	
}

// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des différentes propriété liaisons :
// ('prop_liaison_generique', 'prop_liaison_complexe')
// -------------------------------------------------------------------------------------------------------------------------------------------

// afficher une page et cacher les autres
function prop_liaison_affich(name_prop){
	var affiche_on = name_prop;
	var affiche_off = new Array('generique', 'complexe');
	var taille_off = new Number(affiche_off.length);
	
	// on cache tout
	for(i_off=0; i_off<taille_off; i_off++){
		var className_page = "NC_prop_box off";
		var strContent_prop_page = 'prop_liaison_' + affiche_off[i_off] ;
		//alert(strContent_prop_page);
		var id_prop_page = document.getElementById(strContent_prop_page);
		id_prop_page.className = className_page ;
		
		var className_menu = "";
		var strContent_prop_menu = 'prop_liaison_menu_' + affiche_off[i_off] ;
		var id_prop_menu = document.getElementById(strContent_prop_menu);
		if(id_prop_menu.className.match('off')){
		}else{
			id_prop_menu.className = className_menu ;
		}
		
	}
	
	// on affiche les éléments de la bonne page
	var className_page = "NC_prop_box on";
	var strContent_prop_page = 'prop_liaison_' + affiche_on ;
	var id_prop_page = document.getElementById(strContent_prop_page);
	id_prop_page.className = className_page ;
	
	var className_menu = "selected";
	var strContent_prop_menu = 'prop_liaison_menu_' + affiche_on ;
	var id_prop_menu = document.getElementById(strContent_prop_menu);
	id_prop_menu.className = className_menu ;
	
	equal_height_NC_fake();	
}


// afficher les propriété de la liaison à visualiser 
function prop_liaison_affich_info(){
	// prop_liaison_for_info est la liaison sélectionné
	// on rempli le cartouche top de la liaison pour info
	for(key in prop_liaison_for_info){
		if(key=='name'){
			var strContent_prop_key = 'prop_liaison_top_' + key ;
			var id_prop_key = document.getElementById(strContent_prop_key);
			if(id_prop_key != null){
				remplacerTexte(id_prop_key, prop_liaison_for_info[key]);
			}
		}
		if(key=='ref'){
			var strContent_prop_key = 'prop_liaison_top_' + key ;
			var id_prop_key = document.getElementById(strContent_prop_key);
			if(id_prop_key != null){
				remplacerTexte(id_prop_key, prop_liaison_for_info[key]);
			}
		}
		if(key=='comp_generique'){
			var strContent_prop_parfaite = 'prop_liaison_top_parfaite' ;
			var strContent_prop_elastique = 'prop_liaison_top_elastique'  ;
			var strContent_prop_contact = 'prop_liaison_top_contact'  ;
			var id_prop_parfaite = document.getElementById(strContent_prop_parfaite);
			var id_prop_elastique = document.getElementById(strContent_prop_elastique);
			var id_prop_contact = document.getElementById(strContent_prop_contact);
			
			if(prop_liaison_for_info[key].match('Pa')) {
				id_prop_parfaite.className = "NC_box_radio_prop actif";
				id_prop_elastique.className = "NC_box_radio_prop";
				id_prop_contact.className = "NC_box_radio_prop";
				
				document.getElementById('prop_liaison_comp_elastique').className = "off";
				document.getElementById('prop_liaison_comp_contact').className = "off";
			
			}else if(prop_liaison_for_info[key].match('El')) {
				id_prop_parfaite.className = "NC_box_radio_prop";
				id_prop_elastique.className = "NC_box_radio_prop actif";
				id_prop_contact.className = "NC_box_radio_prop";
				
				document.getElementById('prop_liaison_comp_elastique').className = "on";
				document.getElementById('prop_liaison_comp_contact').className = "off";
						
			}else if(prop_liaison_for_info[key].match('Co')) {
				id_prop_parfaite.className = "NC_box_radio_prop";
				id_prop_elastique.className = "NC_box_radio_prop";
				id_prop_contact.className = "NC_box_radio_prop actif";
				
				document.getElementById('prop_liaison_comp_elastique').className = "off";
				document.getElementById('prop_liaison_comp_contact').className = "on";		
			}
		}
		if(key=='comp_complexe'){
			var strContent_prop_top_plastique = 'prop_liaison_top_plastique'  ;
			var strContent_prop_top_cassable = 'prop_liaison_top_cassable'  ;
			var strContent_prop_plastique = 'prop_liaison_comp_plastique'  ;
			var strContent_prop_cassable = 'prop_liaison_comp_cassable'  ;
			
			var id_prop_top_plastique = document.getElementById(strContent_prop_top_plastique);
			var id_prop_top_cassable = document.getElementById(strContent_prop_top_cassable);
			var id_prop_plastique = document.getElementById(strContent_prop_plastique);
			var id_prop_cassable = document.getElementById(strContent_prop_cassable);

			//plastique
			if(prop_liaison_for_info[key].match('Pl')){
				id_prop_top_plastique.className = "NC_box_check_prop actif";
				id_prop_plastique.className = "on";
			}else{ 
				id_prop_top_plastique.className = "NC_box_check_prop";
				id_prop_plastique.className = "off";
			}
			//cassable
			if(prop_liaison_for_info[key].match('Ca')){
				id_prop_top_cassable.className = "NC_box_check_prop actif";
				id_prop_cassable.className = "on";
			}else{ 
				id_prop_top_cassable.className = "NC_box_check_prop";
				id_prop_cassable.className = "off";
			}	
		}
	}	
	prop_bloc_affich('liaison');
	prop_liaison_affich('generique');
	
	// on rempli les propriété de la liaison
	for(key in prop_liaison_for_info){
		var strContent_prop_key = 'prop_liaison_' + key ;
		var id_prop_key = document.getElementById(strContent_prop_key);
		if(id_prop_key != null){
			id_prop_key.value = prop_liaison_for_info[key] ;
			if(prop_liaison_for_info['id_select'] == null){
				id_prop_key.disabled = true;
			}else{ 
				id_prop_key.disabled = false;
			}
		}
		if(key == 'f'){
			var strContent_prop_key_bis = 'prop_liaison_bis_' + key ;
			var id_prop_key_bis = document.getElementById(strContent_prop_key_bis);
			id_prop_key_bis.value = prop_liaison_for_info[key] ;
			if(prop_liaison_for_info['id_select'] == null){
				id_prop_key_bis.disabled = true;
			}else{ 
				id_prop_key_bis.disabled = false;
			}
		}
	}	
}



//changer les propriétés d'un liaison
function prop_liaison_change_value(){
	for(key in prop_liaison_for_info){
		var strContent_prop_key = 'prop_liaison_' + key ;
		var id_prop_key = document.getElementById(strContent_prop_key);
		if(id_prop_key != null){
			prop_liaison_for_info[key] = id_prop_key.value ;
		}
	}
}
//changer le coeff de frottement dans le cas d'une liaison cassable
function prop_liaison_change_f_bis(){
	key = 'f';
	var strContent_prop_key = 'prop_liaison_bis_' + key ;
	var id_prop_key = document.getElementById(strContent_prop_key);
	if(id_prop_key != null){
		prop_liaison_for_info[key] = id_prop_key.value ;
	}
}

// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des propriété CLs :
// ('volume', 'depl','effort')
// -------------------------------------------------------------------------------------------------------------------------------------------
// afficher les propriété de la CLv_poids à visualiser 
function prop_CLv_affich_info(strinfo){
	// prop_liaison_for_info est la liaison sélectionné
	// on affiche les elements en fonction de la dimention du probleme
	//alert(array2json(prop_CL_for_info));
	for(dim=2; dim<=3; dim++){
		str_dim = 'prop_dim_' + dim;
		id_dim = document.getElementsByName(str_dim);
		str_dim_in = 'prop_dim_' + dim + '_in';
		id_dim_in = document.getElementsByName(str_dim_in);
		var strClass = 'on';
		if(dim > dim_model) strClass = "off";
		for(n2=0;n2<id_dim.length;n2++){
			id_dim[n2].className = strClass ;
		}
		for(n2=0;n2<id_dim_in.length;n2++){
			id_dim_in[n2].className = strClass ;
		}
	}
	// on affiche les infos sur la CLv poids
	var id_prop_CLv_poids = document.getElementById('prop_CLv_poids');
	var id_prop_CLv_acceleration = document.getElementById('prop_CLv_acceleration');
	var id_prop_CLv_centrifuge = document.getElementById('prop_CLv_centrifuge');
	if (strinfo == 'poids'){
		id_prop_CLv_poids.className = 'NC_prop_box on';
		id_prop_CLv_acceleration.className = 'NC_prop_box off';
		id_prop_CLv_centrifuge.className = 'NC_prop_box off';
	}if (strinfo == 'acceleration'){
		id_prop_CLv_poids.className = 'NC_prop_box off';
		id_prop_CLv_acceleration.className = 'NC_prop_box on';
		id_prop_CLv_centrifuge.className = 'NC_prop_box off';
	}if (strinfo == 'centrifuge'){
		id_prop_CLv_poids.className = 'NC_prop_box off';
		id_prop_CLv_acceleration.className = 'NC_prop_box off';
		id_prop_CLv_centrifuge.className = 'NC_prop_box on';
	}

	// on rempli le cartouche top de la liaison pour info
	for(key in prop_CL_for_info){
		if(key=='ref'){
			//prop_CL_affich(prop_CL_for_info[key]);
		}else if(key=='name'){
			var strContent_prop_key = 'prop_CLv_top_' + key ;
			var id_prop_key = document.getElementById(strContent_prop_key);
			if(id_prop_key != null){
				remplacerTexte(id_prop_key, prop_CL_for_info[key]);
			}
		}else if(key=='bctype'){
			var strContent_prop_key = 'prop_CLv_top_apply_on' ;
			var id_prop_key = document.getElementById(strContent_prop_key);
			var str_apply_on = new String();
			str_apply_on = "toutes les pièces du modèle";
			if(id_prop_key != null){
				remplacerTexte(id_prop_key, str_apply_on);
			}
		}else if(key=='step'){
			//alert(key);
			var nb_step = prop_CL_for_info[key].length ;
			//alert(nb_step);
			for(var i_step=0; i_step<nb_step; i_step++){
				for(key_step in prop_CL_for_info[key][i_step]){
					var strContent_prop_key = 'prop_CLv_' + strinfo + '_' + key_step + '_' + i_step;
					//alert(strContent_prop_key);
					var id_prop_key = document.getElementById(strContent_prop_key);
					id_prop_key.value =  prop_CL_for_info[key][i_step][key_step] ;
					id_prop_key.disabled = false;
				}
			}
		}
	}
	prop_bloc_affich('CLv');
}
//changer les propriétés d'une CLv
function prop_CLv_change_value(strinfo){ //strinfo = poids, acceleration ou centrifuge
	for(key in prop_CL_for_info){
		if(key=='step'){
			var nb_step = prop_CL_for_info[key].length ;
			for(var i_step=0; i_step<nb_step; i_step++){
				for(key_step in prop_CL_for_info[key][i_step]){
					var strContent_prop_key = 'prop_CLv_' + strinfo + '_' + key_step + '_' + i_step;
					var id_prop_key = document.getElementById(strContent_prop_key);	
                    if(id_prop_key != null){
                        prop_CL_for_info[key][i_step][key_step] = id_prop_key.value ;       
                    }
				}
			}
		}
	}
}


// afficher un type de CL et cacher les autres
function prop_CL_affich(name_prop){
	var affiche_on = name_prop;
	var affiche_off = new Array('v0', 'v1', 'v2','e0', 'e1', 'e2','d0', 'd1', 'd2','d3');
	//var affiche_off = new Array('poids', 'acceleration', 'centrifuge','force', 'force normale', 'pression','dep nul', 'dep imp', 'dep norm','sym');
	var taille_off = new Number(affiche_off.length);
	
	// on cache tout
	for(i_off=0; i_off<taille_off; i_off++){
		var className_page = "off";
		var strContent_prop_page = 'prop_CL_' + affiche_off[i_off] ;
		//alert(strContent_prop_page);
		var id_prop_page = document.getElementById(strContent_prop_page);
		if(id_prop_page != null){
			id_prop_page.className = className_page ;
		}
	}
	
	// on affiche les éléments de la bonne page
	var className_page = "on";
	var strContent_prop_page = 'prop_CL_' + affiche_on ;
	var id_prop_page = document.getElementById(strContent_prop_page);
	if(id_prop_page != null){
		id_prop_page.className = className_page ;
	}
	equal_height_NC_fake();	
}


// afficher les propriété de la CL_select à visualiser 
function prop_CL_affich_info(){
	// prop_liaison_for_info est la liaison sélectionné
	// on affiche les elements en fonction de la dimention du probleme
	//alert(array2json(prop_CL_for_info));
	for(dim=2; dim<=3; dim++){
		str_dim = 'prop_dim_' + dim;
		id_dim = document.getElementsByName(str_dim);
		str_dim_in = 'prop_dim_' + dim + '_in';
		id_dim_in = document.getElementsByName(str_dim_in);
		var strClass = 'on';
		if(dim > dim_model) strClass = "off";
		for(n2=0;n2<id_dim.length;n2++){
			id_dim[n2].className = strClass ;
		}
		for(n2=0;n2<id_dim_in.length;n2++){
			id_dim_in[n2].className = strClass ;
		}
	}
	// on cache les autres infos sur cette CL car elle n'est pas selectionnée
	var strContent_prop_CL = 'prop_CL_generique';
	var id_prop_CL = document.getElementById(strContent_prop_CL);
	id_prop_CL.className = 'NC_prop_box off';

	for(key in prop_CL_for_info){
		if(key=='name'){
			var strContent_prop_key = 'prop_CL_top_' + key ;
			var id_prop_key = document.getElementById(strContent_prop_key);
			if(id_prop_key != null){
				remplacerTexte(id_prop_key, prop_CL_for_info[key]);
			}
		}else if(key=='bctype'){
			var strContent_prop_key = 'prop_CL_top_apply_on' ;
			var id_prop_key = document.getElementById(strContent_prop_key);
			var str_apply_on = new String();
			str_apply_on = "des bords (choisir les bords dans la liste de droite)";
			if(id_prop_key != null){
				remplacerTexte(id_prop_key, str_apply_on);
			}
		}
	}
	prop_bloc_affich('CL');
}


// afficher les propriété de la CL_select à visualiser 
function prop_CL_select_affich_info(){
	// prop_liaison_for_info est la liaison sélectionné
	// on affiche les elements en fonction de la dimention du probleme
	//alert(array2json(prop_CL_for_info));
	for(dim=2; dim<=3; dim++){
		str_dim = 'prop_dim_' + dim;
		id_dim = document.getElementsByName(str_dim);
		str_dim_in = 'prop_dim_' + dim + '_in';
		id_dim_in = document.getElementsByName(str_dim_in);
		var strClass = 'on';
		if(dim > dim_model) strClass = "off";
		for(n2=0;n2<id_dim.length;n2++){
			id_dim[n2].className = strClass ;
		}
		for(n2=0;n2<id_dim_in.length;n2++){
			id_dim_in[n2].className = strClass ;
		}
	}
	
	// on affiche les autres infos sur cette CL car elle est selectionnée
	var strContent_prop_CL = 'prop_CL_generique';
	var id_prop_CL = document.getElementById(strContent_prop_CL);
	id_prop_CL.className = 'NC_prop_box on';
	
	
	// on rempli le cartouche top de la CL pour info
	for(key in prop_CL_for_info){
		if(key=='ref'){
			//prop_CL_affich(prop_CL_for_info[key]);
		}else if(key=='name'){
			var strContent_prop_key = 'prop_CL_top_' + key ;
			var id_prop_key = document.getElementById(strContent_prop_key);
			if(id_prop_key != null){
				remplacerTexte(id_prop_key, prop_CL_for_info[key]);
			}
		}else if(key=='bctype'){
			var strContent_prop_key = 'prop_CL_top_apply_on' ;
			var id_prop_key = document.getElementById(strContent_prop_key);
			var str_apply_on = new String();
			if(prop_CL_for_info[key]=='volume') str_apply_on = "toutes les pièces du modèle";
			else str_apply_on = "des bords (choisir les bords dans la liste de droite)";
			if(id_prop_key != null){
				remplacerTexte(id_prop_key, str_apply_on);
			}
		}else if(key=='step'){
			//alert(key);
			var nb_step = prop_CL_for_info[key].length ;
			//alert(nb_step);
			for(var i_step=0; i_step<nb_step; i_step++){
				for(key_step in prop_CL_for_info[key][i_step]){
					var strContent_prop_key = 'prop_CL_' + key_step + '_' + i_step;
					//alert(strContent_prop_key);
					var id_prop_key = document.getElementById(strContent_prop_key);
					if(id_prop_key != null){
						id_prop_key.value =  prop_CL_for_info[key][i_step][key_step] ;
						id_prop_key.disabled = false;
					}
				}
			}
		}else{
			var strContent_prop_key = 'prop_CL_' + key ;
			var id_prop_key = document.getElementById(strContent_prop_key);
			if(id_prop_key != null){
				id_prop_key.value = prop_CL_for_info[key] ;
				id_prop_key.disabled = false;
			}
		}
	}		
	prop_bloc_affich('CL');
}

//changer les propriétés d'une CL
function prop_CL_change_value(){
	for(key in prop_CL_for_info){
		if(key=='step'){
			var nb_step = prop_CL_for_info[key].length ;
			for(var i_step = 0; i_step<nb_step; i_step++){
                //alert(i_step);
				for(key_step in prop_CL_for_info[key][i_step]){
					var strContent_prop_key = 'prop_CL_' + key_step + '_' + i_step;
					var id_prop_key = document.getElementById(strContent_prop_key);	
                    if(id_prop_key != null){
                        prop_CL_for_info[key][i_step][key_step] = id_prop_key.value ;       
                    }
				}
			}
		}else{
			var strContent_prop_key = 'prop_CL_' + key ;
			var id_prop_key = document.getElementById(strContent_prop_key);
			if(id_prop_key != null){
				prop_CL_for_info[key] = id_prop_key.value ;
			}
		}
	}
}

// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des propriété bords :
// création de nouveau bords par critere
// -------------------------------------------------------------------------------------------------------------------------------------------
function Tableau_bords_affich_info(){
	str_bord = "prop_bords_";
	str_bord_list_type = ["is_in","is_on","has_normal"];  // type possible pour les bords
	
	// on cahce tout 
	for(key in str_bord_list_type){
		str_temp = str_bord + str_bord_list_type[key] ;
		var id_temp = document.getElementById(str_temp);
		if(id_temp != null){
			id_temp.className = "NC_prop_box off";
		}
	}
	// affichage des infos relatives à is_in
	document.getElementById("prop_bords_type").value = Tableau_bords_for_info["type"];
	str_bord_type = str_bord + Tableau_bords_for_info["type"] ;
	var id_bord_type = document.getElementById(str_bord_type);
	if(id_bord_type != null){
		id_bord_type.className = "NC_prop_box on";
	}
	str_bord_list_geometry = new Array();
	if(Tableau_bords_for_info["type"]=="is_in"){
		str_bord_list_geometry = ["box","cylinder","sphere"];  // geometry possible pour is_in
	}else if(Tableau_bords_for_info["type"]=="is_on"){
		str_bord_list_geometry = ["plan","disc","cylinder","sphere","equation"];  // geometry possible pour is_on
	}
	
	// on cache toutes les info geometry
	for(key in str_bord_list_geometry){
		str_temp = str_bord_type + "_" + str_bord_list_geometry[key] ;
		//alert(str_temp);
		var id_temp = document.getElementById(str_temp);
		if(id_temp != null){
			id_temp.className = "NC_prop_box off";
		}
	}
	// affichage des infos relatives à la géométrie selectionnée
	str_temp_geometry = "prop_bords_" + Tableau_bords_for_info["type"] + "_geometry";
	id_temp_geometry = document.getElementById(str_temp_geometry);
	//alert(str_temp_geometry);
	if(id_temp_geometry != null){
		id_temp_geometry.value = Tableau_bords_for_info["geometry"];
	}
	str_bord_geometry = str_bord_type + "_" + Tableau_bords_for_info["geometry"];
	//alert(str_bord_geometry);
	var id_bord_geometry = document.getElementById(str_bord_geometry);
	if(id_bord_geometry != null){
		id_bord_geometry.className = "prop_bords_box on";
	}
	
	// affichage des propriété de la géométrie selectionnée
	for(key in Tableau_bords_for_info){
		str_temp = str_bord_geometry + "_" + key ;
		//alert(str_temp);
		var id_temp = document.getElementById(str_temp);
		if(id_temp != null){
			id_temp.value = Tableau_bords_for_info[key]  ;
		}
	}
	prop_bloc_affich('bord');
	equal_height_NC_fake();
}

//changer les propriétés d'un bord en creation
function Tableau_bords_for_info_change_type(){
	Tableau_bords_for_info = clone(Tableau_bords_test);
	str_temp = "prop_bords_type" ;
	var id_temp = document.getElementById(str_temp);
	if(id_temp != null){
		Tableau_bords_for_info["type"] = id_temp.value ;
	}
	Tableau_bords_affich_info();
}
//changer les propriétés d'un bord en creation
function Tableau_bords_for_info_change_geometry(){
	str_temp = "prop_bords_"+ Tableau_bords_for_info["type"] + "_geometry" ;
	//alert(str_temp);
	var id_temp = document.getElementById(str_temp);
	if(id_temp != null){
		Tableau_bords_for_info["geometry"] = id_temp.value ;
	}
	Tableau_bords_for_info["name"] = Tableau_bords_for_info["type"] + "_" + Tableau_bords_for_info["geometry"] + "_" + compteur_bords_test ;
	Tableau_bords_affich_info();
}

//changer les propriétés d'un bord en creation
function Tableau_bords_for_info_change_value(){
	str_bord = "prop_bords_";
	str_bord_type = str_bord + Tableau_bords_for_info["type"] ;
	str_bord_geometry = str_bord_type + "_" + Tableau_bords_for_info["geometry"] ;
	for(key in Tableau_bords_for_info){
		str_temp = str_bord_geometry + "_" + key ;
		//if(key == 'pdirection_z') alert(str_temp);
		var id_temp = document.getElementById(str_temp);
		if(id_temp != null){
			Tableau_bords_for_info[key] = id_temp.value ;
		}
	}
		
}

function valid_bord(){
	if(Tableau_bords_for_info["id"]==-1){
		Tableau_bords_for_info["id"]=compteur_bords_test;
		compteur_bords_test += 1;
		taille_Tableau_bords = Tableau_bords.length;
		Tableau_bords[taille_Tableau_bords] = new Array();
		Tableau_bords[taille_Tableau_bords] = clone(Tableau_bords_for_info);
		affiche_Tableau_bord();
		//alert(taille_Tableau_bords);
		//alert(array2json(Tableau_bords));
	}else{
		Tableau_bords[Tableau_bords_for_info["id"]] = clone(Tableau_bords_for_info);
		affiche_Tableau_bord();
		//alert('else');
	}
}
function duplic_bord(){
	// Tableau_bords_temp est un tableau reinitialisé
	Tableau_bords_temp = new Array(); 
	Tableau_bords_temp = clone(Tableau_bords_for_info);
	Tableau_bords_temp["id"]=compteur_bords_test;
	compteur_bords_test += 1;
	Tableau_bords_temp["name"] = Tableau_bords_temp["type"] + "_" + Tableau_bords_temp["geometry"] + "_" + compteur_bords_test ;
	Tableau_bords_temp["assigned"]=-1;
	Tableau_bords_temp["group"]=-1;
	Tableau_bords_temp["id_CL"]=-1;
	
	taille_Tableau_bords = Tableau_bords.length;
	Tableau_bords[taille_Tableau_bords] = new Array();
	Tableau_bords[taille_Tableau_bords] = clone(Tableau_bords_temp);
	affiche_Tableau_bord();
	info_select('bord',Tableau_bords_filter.length-1);
	//alert(taille_Tableau_bords);
	//alert(array2json(Tableau_bords[taille_Tableau_bords]));
}

-->
<!--

// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des des blocs de propriete :
// ('mat', 'liaison', 'CL')
// -------------------------------------------------------------------------------------------------------------------------------------------

function prop_bloc_affich(name_prop){
	if(name_prop=='mat'){
		document.getElementById('prop_materiaux').className = "on";
		document.getElementById('prop_liaisons').className = "off";
		document.getElementById('prop_CLs').className = "off";
	}else if(name_prop=='liaison'){
		document.getElementById('prop_materiaux').className = "off";
		document.getElementById('prop_liaisons').className = "on";
		document.getElementById('prop_CLs').className = "off";
	}else if(name_prop=='CL'){
		document.getElementById('prop_materiaux').className = "off";
		document.getElementById('prop_liaisons').className = "off";
		document.getElementById('prop_CLs').className = "on";
	}
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
					if(dim > problem_dimension) strClass = "off";
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
	for(key in prop_mat_for_info){
		var strContent_prop_key = 'prop_mat_' + key ;
		var id_prop_key = document.getElementById(strContent_prop_key);
		if(id_prop_key != null){
			id_prop_key.value = prop_mat_for_info[key] ;
			if(isNaN(prop_mat_for_info['id_select'])){
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
			if(isNaN(prop_liaison_for_info['id_select'])){
				id_prop_key.disabled = true;
			}else{ 
				id_prop_key.disabled = false;
			}
		}
		if(key == 'f'){
			var strContent_prop_key_bis = 'prop_liaison_bis_' + key ;
			var id_prop_key_bis = document.getElementById(strContent_prop_key_bis);
			id_prop_key_bis.value = prop_liaison_for_info[key] ;
			if(isNaN(prop_liaison_for_info['id_select'])){
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


// afficher les propriété de la CL à visualiser 
function prop_CL_affich_info(){
	// prop_liaison_for_info est la liaison sélectionné
	// on affiche les elements en fonction de la dimention du probleme
	for(dim=2; dim<=3; dim++){
		str_dim = 'prop_dim_' + dim;
		id_dim = document.getElementsByName(str_dim);
		str_dim_in = 'prop_dim_' + dim + '_in';
		id_dim_in = document.getElementsByName(str_dim_in);
		var strClass = 'on';
		if(dim > problem_dimension) strClass = "off";
		for(n2=0;n2<id_dim.length;n2++){
			id_dim[n2].className = strClass ;
		}
		for(n2=0;n2<id_dim_in.length;n2++){
			id_dim_in[n2].className = strClass ;
		}
	}
	// on rempli le cartouche top de la liaison pour info
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
			for(i_step=0; i_step<nb_step; i_step++){
				for(key_step in prop_CL_for_info[key][i_step]){
					var strContent_prop_key = 'prop_CL_' + key_step + '_' + i_step;
					//alert(strContent_prop_key);
					var id_prop_key = document.getElementById(strContent_prop_key);	
					id_prop_key.value =  prop_CL_for_info[key][i_step][key_step] ;		
				}
			}
		}else{
			var strContent_prop_key = 'prop_CL_' + key ;
			var id_prop_key = document.getElementById(strContent_prop_key);
			if(id_prop_key != null){
				id_prop_key.value = prop_CL_for_info[key] ;
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
			for(i_step=0; i_step<nb_step; i_step++){
				for(key_step in prop_CL_for_info[key][i_step]){
					var strContent_prop_key = 'prop_CL_' + key_step + '_' + i_step;
					var id_prop_key = document.getElementById(strContent_prop_key);	
					prop_CL_for_info[key][i_step][key_step] = id_prop_key.value ;		
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



-->
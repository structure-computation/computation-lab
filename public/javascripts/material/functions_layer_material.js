<!--
//---------------------------------------------------------------------------------------------------------
// initialisation
//---------------------------------------------------------------------------------------------------------

var NMcurrent_stape                 =  0;                        // étape pour le wizzard nouveau material

var Tableau_material                   =  new Array();              // tableau des materials
var Tableau_material_filter            =  new Array();              // tableau des materials filtres pour l'affichage

//initialisation de la taille du tableau pour la box content et de la table de correspondance
var taille_tableau_content          =  20;                       // taille du tableau dans la content box
var content_tableau_connect         =  new Array();              // connectivité entre l'id de l'element graphique (div) et l'élément du tableau affiché dedans  
var content_tableau_current_page    =  new Array();              // numéro de la page du tableau (sert pour la définition de la connectivité)    
var content_tableau_curseur_page    =  new Array();              // nombre de page du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_liste_page      =  new Array();              // liste des pages du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_page            =  new Array('material','new_material');    // initialisation des pages avec tableau dynamique
var taille_tableau_content_page     =  new Array()               // taille du tableau dans la content box
taille_tableau_content_page['material'] = 20;
taille_tableau_content_page['new_material'] = 8;

for(i=0; i<content_tableau_page.length ; i++){
    content_tableau_connect[content_tableau_page[i]] = new Array(taille_tableau_content_page[content_tableau_page[i]]);
    content_tableau_current_page[content_tableau_page[i]] = 0;
    content_tableau_curseur_page[content_tableau_page[i]] = 0;
    content_tableau_liste_page[content_tableau_page[i]] = [1];
    taille_tableau_content = taille_tableau_content_page[content_tableau_page[i]];
    for(j=0; j<taille_tableau_content ; j++){
        content_tableau_connect[content_tableau_page[i]][j]=j;
    }
}

// initialisation des type de materiaux possibles pour la creation de nouveau materiaux
var Tableau_material_new               =  new Array();              // tableau des nouveaux materials




//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'obtention de la liste des materials (tableau)
//-------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage du tableau des materials
function init_Tableau_material(Tableau_material_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_material_temp)
    {   
        Tableau_material = Tableau_material_temp;
    }
    else
    {
        Tableau_material[0]         =  new Array();
        Tableau_material[0]['name'] = 'aucun material';
    }
    affiche_Tableau_material();
}
// requette pour l'obtention du tableau des materials
function get_Tableau_material_standard()
{ 
    var url_php = "/material/get_standard_material";
    $.getJSON(url_php,[],init_Tableau_material);
}

function get_Tableau_material_company()
{ 
    var url_php = "/material/get_company_material";
    $.getJSON(url_php,[],init_Tableau_material);
}

function filtre_material_change_owner(){
	var list_owner; 
	var strContent_info_key = 'filtre_material_owner' ;
	var id_info_key = document.getElementById(strContent_info_key);
	if(id_info_key != null){
		list_owner = id_info_key.value ;
	}
	if(list_owner == 'standard'){
		get_Tableau_material_standard();
		id_info_key.value = "standard";
	}else if(list_owner == 'company'){
		get_Tableau_material_company();
		id_info_key.value = "company";
	}
}


//------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage de la liste des materials (tableau)
//------------------------------------------------------------------------------------------------------

function filtre_Tableau_material(){
    Tableau_material_filter = Tableau_material;
}

// affichage du tableau membre
function affiche_Tableau_material(){
    taille_tableau_content  =  taille_tableau_content_page['material'];
    filtre_Tableau_material();
    var current_tableau     =  Tableau_material_filter;
    var strname             =  'material';
    var strnamebdd          =  'material';
    var stridentificateur   =  new Array('name','familly','mtype','comp');
    affiche_Tableau_content(current_tableau, strname, strnamebdd, stridentificateur);
}

// affiche la page num pour la liste des materials
function go_page_material(num){
    if(num=='first'){
        content_tableau_current_page['material'] = 0;
    }else if(num=='end'){
        content_tableau_current_page['material'] = content_tableau_liste_page['material'].length-1;
    }else{
        var num_page = num + content_tableau_curseur_page['material'];
        content_tableau_current_page['material'] = content_tableau_liste_page['material'][num_page]-1;    
    }
    affiche_Tableau_material();
}




//------------------------------------------------------------------------------------------------------
// fonctions generique pour l'affichage d'un tableau
//------------------------------------------------------------------------------------------------------


// affichage des tableau content ('LM_material')
function affiche_Tableau_content(current_tableau, strname, strnamebdd, stridentificateur){
    var taille_Tableau=current_tableau.length;
    for(i=0; i<taille_tableau_content; i++) {
        i_page = i + content_tableau_current_page[strname] * taille_tableau_content;
        content_tableau_connect[strname][i]=i_page;
        
        strContent_lign = strname + '_lign_' + i;
	strContent_pair = strname + '_pair_' + i;
	//alert(strContent_lign);
	var id_lign  = document.getElementById(strContent_lign);
	var id_pair  = document.getElementById(strContent_pair);
	strContent =  new Array();
	idContent =  new Array();
	for(j=0; j<stridentificateur.length; j++) {
	      strContent[j] = strname + '_' + j + '_' + i;
	      idContent[j] = document.getElementById(strContent[j]);
	}
        
        if(i_page<taille_Tableau){
            id_lign.className = "largeBoxTable_lign on";
	    if(pair(i)){
		id_pair.className = "largeBoxTable_lign_pair";
	    }else{
		id_pair.className = "largeBoxTable_lign_impair";
	    }
	    strtemp =  new Array();
	    for(j=0; j<stridentificateur.length; j++) {
		  strtemp[j] = current_tableau[i_page][strnamebdd][stridentificateur[j]];
		  remplacerTexte(idContent[j], strtemp[j]);
	    }
        }else{
            id_lign.className = "largeBoxTable_lign off";
        }
    }
    // pour l'affichage des page en bas de la boite
    var nb_page = Math.floor(taille_Tableau/taille_tableau_content)+1;
    if(nb_page < 5){
        content_tableau_curseur_page[strname] = 0;
    }else{
        if(content_tableau_current_page[strname] >= nb_page-3){
            content_tableau_curseur_page[strname] = nb_page-5;
        }else if(content_tableau_current_page[strname] < 3){
            content_tableau_curseur_page[strname] = 0;
        }else{
            content_tableau_curseur_page[strname] = content_tableau_current_page[strname]-2;
        }
    }
    content_tableau_liste_page[strname] = new Array();
    for(i=0; i<nb_page; i++) {
        content_tableau_liste_page[strname][i] = i+1;
    }
    for(i=content_tableau_curseur_page[strname]; i<content_tableau_curseur_page[strname]+5; i++) { // on affiche un lien vers 5 pages
        if(i<nb_page){
            strpage = new String();
            strpage = content_tableau_liste_page[strname][i];
        }else{
            strpage = "";
        }
        strContent_page = new String();
        strContent_page = strname + '_page_' + (i-content_tableau_curseur_page[strname]);
        var id_page = document.getElementById(strContent_page);
        remplacerTexte(id_page, strpage);
        if(i==content_tableau_current_page[strname]){
            id_page.className = 'page_select';
        }else{
            id_page.className = '';
        }
    }  
}


//---------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage du detail d'un materiaux
//---------------------------------------------------------------------------------------------------------------------


// afficher le détail d'un materiaux
function affich_detail_material(num){
    var num_select = content_tableau_connect['material'][num];
    var table_detail = Tableau_material_filter[num_select]['material'];
    prop_mat_affich_info(table_detail);
 
    strModelListe = 'MaterialListe';    
    IdModelListe     = document.getElementById(strModelListe);
    IdModelListe.className = "off";
    strModelDetail = 'MaterialDetail';    
    IdModelDetail  = document.getElementById(strModelDetail);
    IdModelDetail.className = "on";
    //setTimeout($('#ModelListe').slideUp("slow"),1250);
}
// fermer le détail d'un modele
function ferme_detail_material(){
    strModelDetail = 'MaterialDetail';    
    IdModelDetail  = document.getElementById(strModelDetail);
    IdModelDetail.className = "off";
    trModelListe = 'MaterialListe';    
    IdModelListe     = document.getElementById(strModelListe);
    IdModelListe.className = "on";
    //setTimeout($('#ModelDetail').slideUp("slow"),1250);
    
}

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
}


// afficher les propriété du matériaux à visualiser 
function prop_mat_affich_info(prop_mat_for_info){
	// prop_mat_for_info est le matériaux sélectionné
	// on rempli le cartouche top du matériaux pour info
	dim_model = 3;
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
	prop_mat_affich('info');
	
	// on rempli les propriété du matériaux
	for(key in prop_mat_for_info){
		var strContent_prop_key = 'prop_mat_' + key ;
		var id_prop_key = document.getElementById(strContent_prop_key);
		if(id_prop_key != null){
			id_prop_key.value = prop_mat_for_info[key] ;
			id_prop_key.disabled = true;
		}
	}	
}

//---------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage d'un nouveau d'un materiaux
//---------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------
// wizard de creation material
//---------------------------------------------------------------------------------------------------------

function displayNewMaterial(interupteur) {
    displayBlack(interupteur);
    document.getElementById('New_wiz_layer').className = interupteur;
    NMcurrent_stape = 'page_information';
    //affich_new_material();
    affiche_Tableau_new_material();
    document.getElementById('wiz_annul').className    =  'on' ;
    document.getElementById('wiz_suiv').className    =  'on' ;
    document.getElementById('wiz_valid').className    =  'off' ;
    document.getElementById('wiz_fin').className    =  'off' ;
    affiche_NM_page();
}

// afficher la page suivante ou la page precedente
function NM_next_stape(){
    if(NMcurrent_stape == 'page_information'){
        NMcurrent_stape      = 'page_fichier';
	affich_new_material();
	document.getElementById('wiz_annul').className    =  'on' ;
	document.getElementById('wiz_suiv').className    =  'off' ;
	document.getElementById('wiz_valid').className    =  'on' ;
	document.getElementById('wiz_fin').className    =  'off' ;
        affiche_NM_page();
    }
    else if(NMcurrent_stape == 'page_fichier'){
	send_new_material();
	affich_new_material_resume();
        NMcurrent_stape = 'page_resume';
	document.getElementById('wiz_annul').className    =  'off' ;
	document.getElementById('wiz_suiv').className    =  'off' ;
	document.getElementById('wiz_valid').className    =  'off' ;
	document.getElementById('wiz_fin').className    =  'on' ;
        affiche_NM_page();
    }  
}
function NM_previous_stape(){
    if(NMcurrent_stape == 'page_fichier'){
        NMcurrent_stape = 'page_information';
	document.getElementById('wiz_annul').className    =  'on' ;
	document.getElementById('wiz_suiv').className    =  'on' ;
	document.getElementById('wiz_valid').className    =  'off' ;
	document.getElementById('wiz_fin').className    =  'off' ;
        affiche_NM_page();
    }
    else if(NMcurrent_stape == 'page_resume'){
        NMcurrent_stape      = 'page_fichier';
	document.getElementById('wiz_annul').className    =  'on' ;
	document.getElementById('wiz_suiv').className    =  'off' ;
	document.getElementById('wiz_valid').className    =  'on' ;
	document.getElementById('wiz_fin').className    =  'off' ;
        affiche_NM_page();
    }
}

// afficher une page et cacher les autres
function affiche_NM_page(){
    var affiche_on  = NMcurrent_stape;
    var affiche_off = new Array('page_information', 'page_fichier', 'page_resume');
    var taille_off  = new Number(affiche_off.length);
    
    // on cache tout
    var className   = "actif";
    if(NMcurrent_stape == 'page_information'){
        NMcurrent_stage = 0;
    }
    else if(NMcurrent_stape == 'page_fichier'){
        NMcurrent_stage = 1;
    }
    else if(NMcurrent_stape == 'page_resume'){
        NMcurrent_stage = 2;
    }

    for(i_off=0; i_off<taille_off; i_off++){
        if(i_off >= NMcurrent_stage){
            var className = "";
        }
        strContent_PB_page      =  'NM_PB_' + affiche_off[i_off] ;
        var id_PB_page          =  document.getElementById(strContent_PB_page);
        id_PB_page.className    =  className ;
    }
    
    for(i_off=0; i_off<taille_off; i_off++){
        strContent_page =  new String();
        strContent_page =  'NM_' + affiche_off[i_off] ;
        var id_page     =  document.getElementById(strContent_page);
        if(id_page!=null){
            id_page.className = "off";
        }
    }
    // on affiche les éléments de la bonne page
    strContent_PB_page      = 'NM_PB_' + affiche_on ;
    var id_PB_page          = document.getElementById(strContent_PB_page);
    id_PB_page.className    = "select";
    
    strContent_page         = new String();
    strContent_page         = 'NM_' + affiche_on ;
    if(id_page = document.getElementById(strContent_page)){
        id_page.className   = "on";
    }
}


// afficher le détail d'un materiaux
function affich_new_material(){
    var table_detail = Tableau_material_new;
    //alert(array2json(Tableau_material_new));
    new_mat_affich_info(table_detail);               
}

// afficher une page et cacher les autres pour les propriété materiaux
function new_mat_affich(name_prop){
	var affiche_on = name_prop;
	var affiche_off = new Array('info','generique', 'elastique', 'plastique', 'endomageable','visqueux');
	var taille_off = new Number(affiche_off.length);
	
	// on cache tout
	for(i_off=0; i_off<taille_off; i_off++){
		var className_page = "NC_prop_box off";
		var strContent_prop_page = 'new_mat_' + affiche_off[i_off] ;
		//alert(strContent_prop_page);
		var id_prop_page = document.getElementById(strContent_prop_page);
		id_prop_page.className = className_page ;
		
		var className_menu = "";
		var strContent_prop_menu = 'new_mat_menu_' + affiche_off[i_off] ;
		var id_prop_menu = document.getElementById(strContent_prop_menu);
		if(id_prop_menu.className.match('off')){
		}else{
			id_prop_menu.className = className_menu ;
		}
		
	}
	// on affiche les éléments de la bonne page
	var className_page = "NC_prop_box on";
	var strContent_prop_page = 'new_mat_' + affiche_on ;
	var id_prop_page = document.getElementById(strContent_prop_page);
	id_prop_page.className = className_page ;
	
	var className_menu = "selected";
	var strContent_prop_menu = 'new_mat_menu_' + affiche_on ;
	var id_prop_menu = document.getElementById(strContent_prop_menu);
	id_prop_menu.className = className_menu ;
}


// afficher les propriété du matériaux à visualiser 
function new_mat_affich_info(new_mat_for_info){
	// new_mat_for_info est le matériaux sélectionné
	// on rempli le cartouche top du matériaux pour info
	dim_model = 3;
	for(key in new_mat_for_info){
		if(key=='mtype'){
			var strContent_prop_isotrope = 'new_mat_top_isotrope' ;
			var strContent_prop_orthotrope = 'new_mat_top_orthotrope'  ;
			var id_prop_isotrope = document.getElementById(strContent_prop_isotrope);
			var id_prop_orthotrope = document.getElementById(strContent_prop_orthotrope);
			if(new_mat_for_info[key] == 'isotrope') {
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
			}else if(new_mat_for_info[key] == 'orthotrope') {
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
			var strContent_prop_elastique = 'new_mat_top_elastique' ;
			var strContent_prop_plastique = 'new_mat_top_plastique'  ;
			var strContent_prop_endomageable = 'new_mat_top_endomageable'  ;
			var strContent_prop_visqueux = 'new_mat_top_visqueux'  ;
			
			var id_prop_elastique = document.getElementById(strContent_prop_elastique);
			var id_prop_plastique = document.getElementById(strContent_prop_plastique);
			var id_prop_endomageable = document.getElementById(strContent_prop_endomageable);
			var id_prop_visqueux = document.getElementById(strContent_prop_visqueux);
			//elastique
			if(new_mat_for_info[key].match('el')){
				id_prop_elastique.className = "NC_box_check_prop actif";
				var id_prop_menu = document.getElementById('new_mat_menu_elastique');
				id_prop_menu.className = "on";
			}else{ 
				id_prop_elastique.className = "NC_box_check_prop";
				var id_prop_menu = document.getElementById('new_mat_menu_elastique');
				id_prop_menu.className = "off";
			}
			//plastique
			if(new_mat_for_info[key].match('pl')){
				id_prop_plastique.className = "NC_box_check_prop actif";
				var id_prop_menu = document.getElementById('new_mat_menu_plastique');
				id_prop_menu.className = "on";
			}else{ 
				id_prop_plastique.className = "NC_box_check_prop";
				var id_prop_menu = document.getElementById('new_mat_menu_plastique');
				id_prop_menu.className = "off";
			}
			//endomageable
			if(new_mat_for_info[key].match('en')){
				id_prop_endomageable.className = "NC_box_check_prop actif";
				var id_prop_menu = document.getElementById('new_mat_menu_endomageable');
				id_prop_menu.className = "on";
			}else{ 
				id_prop_endomageable.className = "NC_box_check_prop";
				var id_prop_menu = document.getElementById('new_mat_menu_endomageable');
				id_prop_menu.className = "off";
			}
			//visqueux	
			if(new_mat_for_info[key].match('vi')){
				id_prop_visqueux.className = "NC_box_check_prop actif";
				var id_prop_menu = document.getElementById('new_mat_menu_visqueux');
				id_prop_menu.className = "on";
			}else{ 
				id_prop_visqueux.className = "NC_box_check_prop";
				var id_prop_menu = document.getElementById('new_mat_menu_visqueux');
				id_prop_menu.className = "off";
			}		
		}
	}
	new_mat_affich('info');
	
	// on rempli les propriété du matériaux
	for(key in new_mat_for_info){
		var strContent_prop_key = 'new_mat_' + key ;
		var id_prop_key = document.getElementById(strContent_prop_key);
		if(id_prop_key != null){
			id_prop_key.value = new_mat_for_info[key] ;
			id_prop_key.disabled = false;
		}
	}	
}
//changer les propriétés d'un matériaux
function new_mat_change_value(){
	for(key in Tableau_material_new){
		var strContent_prop_key = 'new_mat_' + key ;
		var id_prop_key = document.getElementById(strContent_prop_key);
		if(id_prop_key != null){
			Tableau_material_new[key] = id_prop_key.value ;
		}
	}
}

// afficher le resumé d'un materiaux
function affich_new_material_resume(){
   for(key in Tableau_material_new){
		var str_info_key = 'new_material_resume_' + key ;
		var id_info_key = document.getElementById(str_info_key);
		if(id_info_key != null){
			strContent_info_key = Tableau_material_new[key] ; 
			remplacerTexte(id_info_key, strContent_info_key);
		}
	}
}

// telecharger le nouveau materiau
function send_new_material()
{
    var param1 = array2object(Tableau_material_new);
    var Tableau_new_material_post         =  new Object(); 
    Tableau_new_material_post['material'] =  new Object(); 
    Tableau_new_material_post['material'] = param1;
    $.ajax({
	url: "/material/create",
	type: 'POST',
	dataType: 'json',
	data: $.toJSON(Tableau_new_material_post),
	contentType: 'application/json; charset=utf-8',
	success: function(json) {
	    alert(json);
	}
    });

}



-->
<!--
//---------------------------------------------------------------------------------------------------------
// initialisation
//---------------------------------------------------------------------------------------------------------

var NMcurrent_stape                 =  0;                        // étape pour le wizzard nouveau link

var Tableau_link                   =  new Array();              // tableau des links
var Tableau_link_filter            =  new Array();              // tableau des links filtres pour l'affichage

//initialisation de la taille du tableau pour la box content et de la table de correspondance
var taille_tableau_content          =  20;                       // taille du tableau dans la content box
var content_tableau_connect         =  new Array();              // connectivité entre l'id de l'element graphique (div) et l'élément du tableau affiché dedans  
var content_tableau_current_page    =  new Array();              // numéro de la page du tableau (sert pour la définition de la connectivité)    
var content_tableau_curseur_page    =  new Array();              // nombre de page du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_liste_page      =  new Array();              // liste des pages du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_page            =  new Array('link');    // initialisation des pages avec tableau dynamique

for(i=0; i<content_tableau_page.length ; i++){
    content_tableau_connect[content_tableau_page[i]] = new Array(taille_tableau_content);
    content_tableau_current_page[content_tableau_page[i]] = 0;
    content_tableau_curseur_page[content_tableau_page[i]] = 0;
    content_tableau_liste_page[content_tableau_page[i]] = [1];
    for(j=0; j<taille_tableau_content ; j++){
        content_tableau_connect[content_tableau_page[i]][j]=j;
    }
}


//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'obtention de la liste des links (tableau)
//-------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage du tableau des links
function init_Tableau_link(Tableau_link_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_link_temp)
    {   
        Tableau_link = Tableau_link_temp;
    }
    else
    {
        Tableau_link[0]         =  new Array();
        Tableau_link[0]['name'] = 'aucune liaison';
    }
    affiche_Tableau_link();
}
// requette pour l'obtention du tableau des links
function get_Tableau_link()
{ 
    var url_php = "/link/index";
    $.getJSON(url_php,[],init_Tableau_link);
}


//------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage de la liste des links (tableau)
//------------------------------------------------------------------------------------------------------

function filtre_Tableau_link(){
    Tableau_link_filter = Tableau_link;
}

// affichage du tableau des links
function affiche_Tableau_link(){
    taille_tableau_content  =  20;
    filtre_Tableau_link();
    var current_tableau     =  Tableau_link_filter;
    var strname             =  'link';
    // var stridentificateur   =  new Array('name','project','new_results','résults');
    var stridentificateur   =  new Array('name','name','comp_generique','comp_complexe');
    affiche_Tableau_content(current_tableau, strname, stridentificateur);
}

// affichage des tableau content ('LM_link')
function affiche_Tableau_content(current_tableau, strname, stridentificateur){
    var taille_Tableau=current_tableau.length;
    for(i=0; i<taille_tableau_content; i++) {
        i_page = i + content_tableau_current_page[strname] * taille_tableau_content;
        content_tableau_connect[strname][i]=i_page;
        
        strContent_lign = strname + '_lign_' + i;
	strContent_pair = strname + '_pair_' + i;
        strContent_2 = strname + '_2_' + i;
        strContent_3 = strname + '_3_' + i;
        strContent_4 = strname + '_4_' + i;
	strContent_5 = strname + '_5_' + i;
        var id_lign  = document.getElementById(strContent_lign);
	var id_pair  = document.getElementById(strContent_pair);
        var id_2     = document.getElementById(strContent_2);
        var id_3     = document.getElementById(strContent_3);
        var id_4     = document.getElementById(strContent_4);
	var id_5     = document.getElementById(strContent_5);
        
        if(i_page<taille_Tableau){
            id_lign.className = "largeBoxTable_Link_lign on";
	    if(pair(i)){
		id_pair.className = "largeBoxTable_Link_lign_pair";
	    }else{
		id_pair.className = "largeBoxTable_Link_lign_impair";
	    }
            strtemp_2 = current_tableau[i_page]['link'][stridentificateur[0]];
            strtemp_3 = current_tableau[i_page]['link'][stridentificateur[1]];
            strtemp_4 = current_tableau[i_page]['link'][stridentificateur[2]];
	    strtemp_5 = current_tableau[i_page]['link'][stridentificateur[3]];
            remplacerTexte(id_2, strtemp_2);
            remplacerTexte(id_3, strtemp_3);
            remplacerTexte(id_4, strtemp_4);
	    remplacerTexte(id_5, strtemp_5);
        }else{
            id_lign.className = "largeBoxTable_Link_lign off";
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

// affiche la page num pour la liste des links
function go_page_link(num){
    if(num=='first'){
        content_tableau_current_page['link'] = 0;
    }else if(num=='end'){
        content_tableau_current_page['link'] = content_tableau_liste_page['link'].length-1;
    }else{
        var num_page = num + content_tableau_curseur_page['link'];
        content_tableau_current_page['link'] = content_tableau_liste_page['link'][num_page]-1;    
    }
    affiche_Tableau_link();
}

// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des différentes propriété liaisons :
// ('prop_liaison_generique', 'prop_liaison_complexe')
// -------------------------------------------------------------------------------------------------------------------------------------------


// afficher le détail d'un materiaux
function affich_detail_link(num){
    var num_select = content_tableau_connect['link'][num];
    var table_detail = Tableau_link_filter[num_select]['link'];
    prop_liaison_affich_info(table_detail);
 
    strModelListe = 'LinkListe';    
    IdModelListe     = document.getElementById(strModelListe);
    IdModelListe.className = "off";
    strModelDetail = 'LinkDetail';    
    IdModelDetail  = document.getElementById(strModelDetail);
    IdModelDetail.className = "on";
    //setTimeout($('#ModelListe').slideUp("slow"),1250);
}
// fermer le détail d'un modele
function ferme_detail_link(){
    strModelDetail = 'LinkDetail';    
    IdModelDetail  = document.getElementById(strModelDetail);
    IdModelDetail.className = "off";
    trModelListe = 'LinkListe';    
    IdModelListe     = document.getElementById(strModelListe);
    IdModelListe.className = "on";
    //setTimeout($('#ModelDetail').slideUp("slow"),1250);
    
}



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
}


// afficher les propriété de la liaison à visualiser 
function prop_liaison_affich_info(prop_liaison_for_info){
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
	prop_liaison_affich('generique');
	
	// on rempli les propriété de la liaison
	for(key in prop_liaison_for_info){
		var strContent_prop_key = 'prop_liaison_' + key ;
		var id_prop_key = document.getElementById(strContent_prop_key);
		if(id_prop_key != null){
			id_prop_key.value = prop_liaison_for_info[key] ;
			id_prop_key.disabled = true;
		}
		if(key == 'f'){
			var strContent_prop_key_bis = 'prop_liaison_bis_' + key ;
			var id_prop_key_bis = document.getElementById(strContent_prop_key_bis);
			id_prop_key_bis.value = prop_liaison_for_info[key] ;
			id_prop_key_bis.disabled = true;
		}
	}	
}



-->
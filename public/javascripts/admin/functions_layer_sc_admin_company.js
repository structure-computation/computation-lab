<!--
//---------------------------------------------------------------------------------------------------------
// initialisation
//---------------------------------------------------------------------------------------------------------

var NMcurrent_stape                 =  0;                        // étape pour le wizzard nouveau company

var Tableau_company                   =  new Array();              // tableau des companys
var Tableau_company_filter            =  new Array();              // tableau des companys filtres pour l'affichage

//initialisation de la taille du tableau pour la box content et de la table de correspondance
var taille_tableau_content          =  20;                       // taille du tableau dans la content box
var content_tableau_connect         =  new Array();              // connectivité entre l'id de l'element graphique (div) et l'élément du tableau affiché dedans  
var content_tableau_current_page    =  new Array();              // numéro de la page du tableau (sert pour la définition de la connectivité)    
var content_tableau_curseur_page    =  new Array();              // nombre de page du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_liste_page      =  new Array();              // liste des pages du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_page            =  new Array('company');    // initialisation des pages avec tableau dynamique

for(i=0; i<content_tableau_page.length ; i++){
    content_tableau_connect[content_tableau_page[i]] = new Array(taille_tableau_content);
    content_tableau_current_page[content_tableau_page[i]] = 0;
    content_tableau_curseur_page[content_tableau_page[i]] = 0;
    content_tableau_liste_page[content_tableau_page[i]] = [1];
    for(j=0; j<taille_tableau_content ; j++){
        content_tableau_connect[content_tableau_page[i]][j]=j;
    }
}

// initialisation du tableau des info sur la nouvelle company
var Tableau_new_company  =  new Array();
Tableau_new_company["name"] = 'test';
Tableau_new_company["address"] = 'test';
Tableau_new_company["city"] = 'test';
Tableau_new_company["zipcode"] = 91160;
Tableau_new_company["country"] = 'test';
Tableau_new_company["division"] = 'test';
Tableau_new_company["TVA"] = 101010010;
Tableau_new_company["siren"] = 345345345;

// initialisation du tableau des info sur le nouveau gestionaire
var Tableau_new_membre  =  new Array();
Tableau_new_membre['email'] = 'test';
Tableau_new_membre['firstname'] = 'test';
Tableau_new_membre['lastname'] = 'test';
Tableau_new_membre['role'] = 'gestionaire';


//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'obtention de la liste des companys (tableau)
//-------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage du tableau des companys
function init_Tableau_company(Tableau_company_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_company_temp)
    {   
        Tableau_company = Tableau_company_temp;
    }
    else
    {
        Tableau_company[0]         =  new Array();
        Tableau_company[0]['name'] = 'aucun company';
    }
    affiche_Tableau_company();
}
// requette pour l'obtention du tableau des companys
function get_Tableau_company()
{ 
    var url_php = "/sc_admin_company/index";
    $.getJSON(url_php,[],init_Tableau_company);
}


//------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage de la liste des companys (tableau)
//------------------------------------------------------------------------------------------------------

function filtre_Tableau_company(){
    Tableau_company_filter = Tableau_company;
}

// affichage du tableau des companys
function affiche_Tableau_company(){
    taille_tableau_content  =  20;
    filtre_Tableau_company();
    var current_tableau     =  Tableau_company_filter;
    var strname             =  'company';
    // var stridentificateur   =  new Array('name','project','new_results','résults');
    var stridentificateur   =  new Array('name','name','city','country');
    affiche_Tableau_content(current_tableau, strname, stridentificateur);
}

// affichage des tableau content ('LM_company')
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
            id_lign.className = "largeBoxTable_Company_lign on";
	    if(pair(i)){
		id_pair.className = "largeBoxTable_Company_lign_pair";
	    }else{
		id_pair.className = "largeBoxTable_Company_lign_impair";
	    }
            strtemp_2 = current_tableau[i_page]['company'][stridentificateur[0]];
            strtemp_3 = current_tableau[i_page]['company'][stridentificateur[1]];
            strtemp_4 = current_tableau[i_page]['company'][stridentificateur[2]];
	    strtemp_5 = current_tableau[i_page]['company'][stridentificateur[3]];
            remplacerTexte(id_2, strtemp_2);
            remplacerTexte(id_3, strtemp_3);
            remplacerTexte(id_4, strtemp_4);
	    remplacerTexte(id_5, strtemp_5);
        }else{
            id_lign.className = "largeBoxTable_Company_lign off";
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

// affiche la page num pour la liste des companys
function go_page_company(num){
    if(num=='first'){
        content_tableau_current_page['company'] = 0;
    }else if(num=='end'){
        content_tableau_current_page['company'] = content_tableau_liste_page['company'].length-1;
    }else{
        var num_page = num + content_tableau_curseur_page['company'];
        content_tableau_current_page['company'] = content_tableau_liste_page['company'][num_page]-1;    
    }
    affiche_Tableau_company();
}

//---------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage du detail d'une company
//---------------------------------------------------------------------------------------------------------------------


// afficher le détail d'une company
function affich_detail_company(num){
    var num_select = content_tableau_connect['company'][num];
    var table_detail = Tableau_company_filter[num_select]['company'];
    //test1=array2json(table_detail);
    //alert(test1);
    //afficher le detail d'un company
    for(key in table_detail){
	    var strContent_detail_key = 'company_detail_' + key ;
	    var id_detail_key = document.getElementById(strContent_detail_key);
	    if(id_detail_key != null){
		strContent = new String();
		strContent = table_detail[key];
		//id_detail_key.value = Tableau_company_filter[num_select][key] ;
		remplacerTexte(id_detail_key, strContent);
	    }
    }
 
    strModelListe = 'SCAdminCompanyListe';    
    IdModelListe     = document.getElementById(strModelListe);
    IdModelListe.className = "off";
    strModelDetail = 'SCAdminCompanyDetail';    
    IdModelDetail  = document.getElementById(strModelDetail);
    IdModelDetail.className = "on";
    //setTimeout($('#ModelListe').slideUp("slow"),1250);
}
// fermer le détail d'un companye
function ferme_detail_company(){
    strModelDetail = 'SCAdminCompanyDetail';    
    IdModelDetail  = document.getElementById(strModelDetail);
    IdModelDetail.className = "off";
    trModelListe = 'SCAdminCompanyListe';    
    IdModelListe     = document.getElementById(strModelListe);
    IdModelListe.className = "on";
    //setTimeout($('#ModelDetail').slideUp("slow"),1250);
    
}

//---------------------------------------------------------------------------------------------------------
// wizard de creation membre
//---------------------------------------------------------------------------------------------------------

function displayNewCompany(interupteur) {
    displayBlack(interupteur);
    document.getElementById('New_wiz_layer').className = interupteur;
    NMcurrent_stape = 'page_information';
    if(interupteur=='on'){
	new_company_affiche_value();
	new_membre_affiche_value();
    }
    affiche_NM_page();
}

// afficher la page suivante ou la page precedente
function NM_next_stape(){
    if(NMcurrent_stape == 'page_information'){
        NMcurrent_stape      = 'page_fichier';
        affiche_NM_page();
    }
    else if(NMcurrent_stape == 'page_fichier'){
        send_new_company();
    }
}
function NM_previous_stape(){
    if(NMcurrent_stape == 'page_fichier'){
        NMcurrent_stape = 'page_information';
        affiche_NM_page();
    }
    else if(NMcurrent_stape == 'page_resume'){
        NMcurrent_stape      = 'page_fichier';
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

//afficher les info de la nouvelle company
function new_company_affiche_value(){
	for(key in Tableau_new_company){
		var strContent_info_key = 'new_company_' + key ;
		var id_info_key = document.getElementById(strContent_info_key);
		if(id_info_key != null){
			id_info_key.value = Tableau_new_company[key] ;
		}
	}
}

//changer les info d'une nouvelle company
function new_company_change_value(){
	for(key in Tableau_new_company){
		var strContent_info_key = 'new_company_' + key ;
		var id_info_key = document.getElementById(strContent_info_key);
		if(id_info_key != null){
			Tableau_new_company[key] = id_info_key.value ;
		}
	}
}

//afficher les info d'un nouveau membre
function new_membre_affiche_value(){
	for(key in Tableau_new_membre){
		var strContent_info_key = 'new_membre_' + key ;
		var id_info_key = document.getElementById(strContent_info_key);
		if(id_info_key != null){
			id_info_key.value = Tableau_new_membre[key] ;
		}
	}
}

//changer les info d'un nouveau membre
function new_membre_change_value(){
	for(key in Tableau_new_membre){
		var strContent_info_key = 'new_membre_' + key ;
		var id_info_key = document.getElementById(strContent_info_key);
		if(id_info_key != null){
			Tableau_new_membre[key] = id_info_key.value ;
		}
	}
}

// afficher le resumé d'une company
function affich_new_company_resume(){
   for(key in Tableau_new_company){
		var str_info_key = 'new_company_resume_' + key ;
		var id_info_key = document.getElementById(str_info_key);
		if(id_info_key != null){
			strContent_info_key = Tableau_new_company[key] ; 
			remplacerTexte(id_info_key, strContent_info_key);
		}
	}
}

//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'envoie des infos sur le nouveau membre
//-------------------------------------------------------------------------------------------------


// telecharger le nom et la description du membre
function send_new_company()
{
    var param1 = array2object(Tableau_new_company);
    var param2 = array2object(Tableau_new_membre);
    var Tableau_new_company_post         =  new Object();
    Tableau_new_company_post['company'] =  new Object(); 
    Tableau_new_company_post['company'] = param1;
    Tableau_new_company_post['user'] =  new Object(); 
    Tableau_new_company_post['user'] = param2;
    $.ajax({
	url: "/sc_admin_company/create",
	type: 'POST',
	dataType: 'json',
	data: $.toJSON(Tableau_new_company_post),
	contentType: 'application/json; charset=utf-8',
	success: function(json) {
	    alert('depot ok');
	    NMcurrent_stape = 'page_resume';
	    affich_new_company_resume();
	    affiche_NM_page();
	}
    });

}


-->
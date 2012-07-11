<!--


// initialisation des type de abonnements possible pour l'achat d'un nouveau abonnement
var Tableau_abonnement_list            =  new Array();              // tableau des abonnement
var Tableau_abonnement             =  new Array();              // abonnement selectionner
var NAcurrent_stape			= 'page_information';
Tableau_abonnement_filter         =  new Array();              // abonnement selectionner
//---------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage d'un nouveau abonnement
//---------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------
// wizard de nouveau abonnement
//---------------------------------------------------------------------------------------------------------

function displayNewAbonnement(interupteur) {
    displayBlack(interupteur);
    document.getElementById('NA_wiz_layer').className = interupteur;
    NAcurrent_stape = 'page_information';
    affiche_Tableau_abonnement_list();
    document.getElementById('NA_wiz_annul').className    =  'on' ;
    document.getElementById('NA_wiz_suiv').className    =  'on' ;
    document.getElementById('NA_wiz_valid').className    =  'off' ;
    document.getElementById('NA_wiz_fin').className    =  'off' ;
    affiche_NA_page();
}

// afficher la page suivante ou la page precedente
function NA_next_stape(){
    if(NAcurrent_stape == 'page_information'){
        NAcurrent_stape      = 'page_fichier';
	affich_detail_abonnement();
	document.getElementById('NA_wiz_annul').className    =  'on' ;
	document.getElementById('NA_wiz_suiv').className    =  'off' ;
	document.getElementById('NA_wiz_valid').className    =  'on' ;
	document.getElementById('NA_wiz_fin').className    =  'off' ;
        affiche_NA_page();
    }
    else if(NAcurrent_stape == 'page_fichier'){
	send_new_abonnement_info();
        NAcurrent_stape = 'page_resume';
	document.getElementById('NA_wiz_annul').className    =  'off' ;
	document.getElementById('NA_wiz_suiv').className    =  'off' ;
	document.getElementById('NA_wiz_valid').className    =  'off' ;
	document.getElementById('NA_wiz_fin').className    =  'on' ;
        affiche_NA_page();
    }  
}
function NA_previous_stape(){
    if(NAcurrent_stape == 'page_fichier'){
        NAcurrent_stape = 'page_information';
	document.getElementById('NA_wiz_annul').className    =  'on' ;
	document.getElementById('NA_wiz_suiv').className    =  'on' ;
	document.getElementById('NA_wiz_valid').className    =  'off' ;
	document.getElementById('NA_wiz_fin').className    =  'off' ;
        affiche_NA_page();
    }
    else if(NAcurrent_stape == 'page_resume'){
        NAcurrent_stape      = 'page_fichier';
	document.getElementById('NA_wiz_annul').className    =  'on' ;
	document.getElementById('NA_wiz_suiv').className    =  'off' ;
	document.getElementById('NA_wiz_valid').className    =  'on' ;
	document.getElementById('NA_wiz_fin').className    =  'off' ;
        affiche_NA_page();
    }
}

// afficher une page et cacher les autres
function affiche_NA_page(){
    var affiche_on  = NAcurrent_stape;
    var affiche_off = new Array('page_information', 'page_fichier', 'page_resume');
    var taille_off  = new Number(affiche_off.length);
    
    // on cache tout
    var className   = "actif";
    if(NAcurrent_stape == 'page_information'){
        NAcurrent_stage = 0;
    }
    else if(NAcurrent_stape == 'page_fichier'){
        NAcurrent_stage = 1;
    }
    else if(NAcurrent_stape == 'page_resume'){
        NAcurrent_stage = 2;
    }

    for(i_off=0; i_off<taille_off; i_off++){
        if(i_off >= NAcurrent_stage){
            var className = "";
        }
        strContent_PB_page      =  'NA_PB_' + affiche_off[i_off] ;
        var id_PB_page          =  document.getElementById(strContent_PB_page);
        id_PB_page.className    =  className ;
    }
    
    for(i_off=0; i_off<taille_off; i_off++){
        strContent_page =  new String();
        strContent_page =  'NA_' + affiche_off[i_off] ;
        var id_page     =  document.getElementById(strContent_page);
        if(id_page!=null){
            id_page.className = "off";
        }
    }
    // on affiche les éléments de la bonne page
    strContent_PB_page      = 'NA_PB_' + affiche_on ;
    var id_PB_page          = document.getElementById(strContent_PB_page);
    id_PB_page.className    = "select";
    
    strContent_page         = new String();
    strContent_page         = 'NA_' + affiche_on ;
    if(id_page = document.getElementById(strContent_page)){
        id_page.className   = "on";
    }
}

//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'obtention de la liste des abonnements
//-------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage du tableau des resultats
function init_Tableau_abonnement_list(Tableau_abonnement_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_abonnement_temp)
    {   
        Tableau_abonnement_list = Tableau_abonnement_temp;
    }
    else
    {
        Tableau_abonnement_list[0]         =  new Array();
        Tableau_abonnement_list[0]['name'] = 'aucun résultat disponnible';
    }
    //alert(array2json(Tableau_abonnement_list));
    affiche_Tableau_abonnement_list();
}
// requette pour l'obtention du tableau des resultats
function get_Tableau_abonnement_list()
{ 
    var url_php = "/sc_admin_detail_workspace/get_list_abonnement";
    $.getJSON(url_php,{},init_Tableau_abonnement_list);
}

// filtre du tableau
function filtre_Tableau_abonnement_list(){
    Tableau_abonnement_filter = Tableau_abonnement_list;
}

// affichage du tableau decompte memory
function affiche_Tableau_abonnement_list(){
    filtre_Tableau_abonnement_list();
    taille_tableau_content  =  taille_tableau_content_page['new_abonnement'];
    var current_tableau     =  Tableau_abonnement_filter;
    var strname             =  'new_abonnement';
    var strnamebdd          =  'abonnement';
    var stridentificateur   =  new Array('name','price','Assigned_memory','security_level');
    affiche_Tableau_new(current_tableau, strname, strnamebdd, stridentificateur);
    select_new_abonnement(0);
}


// affiche la page num pour la liste des abonnement
function go_page_new_abonnement(num){
    if(num=='first'){
        content_tableau_current_page['new_abonnement'] = 0;
    }else if(num=='end'){
        content_tableau_current_page['new_abonnement'] = content_tableau_liste_page['new_abonnement'].length-1;
    }else{
        var num_page = num + content_tableau_curseur_page['new_abonnement'];
        content_tableau_current_page['new_abonnement'] = content_tableau_liste_page['new_abonnement'][num_page]-1;    
    }
    affiche_Tableau_abonnement_list();
}


// selectionner (activer) un matériaux de la liste pour creer un nouveau materiaux
function select_new_abonnement(num){
	var new_abonnement_select = content_tableau_connect['new_abonnement'][num];
	Tableau_abonnement = clone(Tableau_abonnement_list[new_abonnement_select]);
	for(i=0; i<taille_tableau_content_page['new_abonnement'] ;i++){
		strContent_check = 'new_abonnement_check_' + i;
		id_check = document.getElementById(strContent_check);
		if(i==new_abonnement_select){
			id_check.checked=true;
		}else{
			id_check.checked=false;
		}
	}
	//alert(array2json(Tableau_abonnement));
}

// afficher le détail d'un abonnement
function affich_detail_abonnement(){
    var table_detail = Tableau_abonnement['abonnement'];
    //afficher le detail d'un model
    //alert(array2json(Tableau_abonnement));
    for(key in table_detail){
	    var strContent_detail_key = 'abonnement_' + key ;
	    var strContent_resume_key = 'resume_abonnement_' + key ;
	    //alert(strContent_detail_key);
	    var id_detail_key = document.getElementById(strContent_detail_key);
	    var id_resume_key = document.getElementById(strContent_resume_key);
	    if(id_detail_key != null){
		strContent = new String();
		strContent = table_detail[key];
		remplacerTexte(id_detail_key, strContent);
	    }
	    if(id_resume_key != null){
		strContent = new String();
		strContent = table_detail[key];
		remplacerTexte(id_resume_key, strContent);
	    }
    }
}


//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'obtention de la liste des abonnements
//-------------------------------------------------------------------------------------------------

// requette pour l'obtention du tableau des resultats
function ok_new_abonnement_info(result)
{
	//alert(result);
	document.getElementById('new_abonnement_pic_wait').classname = 'off';
	document.getElementById('new_abonnement_pic_ok').classname = 'on';
	get_current_memory_account(Current_workspace['id']);
}


function send_new_abonnement_info()
{ 
    document.getElementById('new_abonnement_pic_wait').classname = 'on';
    document.getElementById('new_abonnement_pic_ok').classname = 'off';
    var url_php = "/sc_admin_detail_workspace/valid_new_abonnement";
    $.getJSON(url_php,{"id_workspace": Current_workspace['id'], "id_abonnement":Tableau_abonnement['abonnement']['id']},ok_new_abonnement_info);
}

-->
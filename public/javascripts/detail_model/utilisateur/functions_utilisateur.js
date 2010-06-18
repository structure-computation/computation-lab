<!--


// initialisation des type de utilisateurs possible pour l'achat d'un nouveau utilisateur
var Tableau_utilisateur_list            =  new Array();              // tableau des utilisateur
var Tableau_utilisateur             =  new Array();              // utilisateur selectionner
var NUcurrent_stape			= 'page_information';
Tableau_utilisateur_filter         =  new Array();              // utilisateur selectionner
//---------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage d'un nouveau utilisateur
//---------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------
// wizard de nouveau utilisateur
//---------------------------------------------------------------------------------------------------------

function displayNewUtilisateur(interupteur) {
    displayBlack(interupteur);
    document.getElementById('NU_wiz_layer').className = interupteur;
    NUcurrent_stape = 'page_information';
    //affiche_Tableau_utilisateur_list();
    document.getElementById('NU_wiz_annul').className    =  'on' ;
    document.getElementById('NU_wiz_suiv').className    =  'on' ;
    document.getElementById('NU_wiz_valid').className    =  'off' ;
    document.getElementById('NU_wiz_fin').className    =  'off' ;
    affiche_NU_page();
}

// afficher la page suivante ou la page precedente
function NU_next_stape(){
    if(NUcurrent_stape == 'page_information'){
        NUcurrent_stape      = 'page_fichier';
	affich_detail_utilisateur();
	document.getElementById('NU_wiz_annul').className    =  'on' ;
	document.getElementById('NU_wiz_suiv').className    =  'off' ;
	document.getElementById('NU_wiz_valid').className    =  'on' ;
	document.getElementById('NU_wiz_fin').className    =  'off' ;
        affiche_NU_page();
    }
    else if(NUcurrent_stape == 'page_fichier'){
	send_new_utilisateur_info();
        NUcurrent_stape = 'page_resume';
	document.getElementById('NU_wiz_annul').className    =  'off' ;
	document.getElementById('NU_wiz_suiv').className    =  'off' ;
	document.getElementById('NU_wiz_valid').className    =  'off' ;
	document.getElementById('NU_wiz_fin').className    =  'on' ;
        affiche_NU_page();
    }  
}
function NU_previous_stape(){
    if(NUcurrent_stape == 'page_fichier'){
        NUcurrent_stape = 'page_information';
	document.getElementById('NU_wiz_annul').className    =  'on' ;
	document.getElementById('NU_wiz_suiv').className    =  'on' ;
	document.getElementById('NU_wiz_valid').className    =  'off' ;
	document.getElementById('NU_wiz_fin').className    =  'off' ;
        affiche_NU_page();
    }
    else if(NUcurrent_stape == 'page_resume'){
        NUcurrent_stape      = 'page_fichier';
	document.getElementById('NU_wiz_annul').className    =  'on' ;
	document.getElementById('NU_wiz_suiv').className    =  'off' ;
	document.getElementById('NU_wiz_valid').className    =  'on' ;
	document.getElementById('NU_wiz_fin').className    =  'off' ;
        affiche_NU_page();
    }
}

// afficher une page et cacher les autres
function affiche_NU_page(){
    var affiche_on  = NUcurrent_stape;
    var affiche_off = new Array('page_information', 'page_fichier', 'page_resume');
    var taille_off  = new Number(affiche_off.length);
    
    // on cache tout
    var className   = "actif";
    if(NUcurrent_stape == 'page_information'){
        NUcurrent_stage = 0;
    }
    else if(NUcurrent_stape == 'page_fichier'){
        NUcurrent_stage = 1;
    }
    else if(NUcurrent_stape == 'page_resume'){
        NUcurrent_stage = 2;
    }

    for(i_off=0; i_off<taille_off; i_off++){
        if(i_off >= NUcurrent_stage){
            var className = "";
        }
        strContent_PB_page      =  'NU_PB_' + affiche_off[i_off] ;
        var id_PB_page          =  document.getElementById(strContent_PB_page);
        id_PB_page.className    =  className ;
    }
    
    for(i_off=0; i_off<taille_off; i_off++){
        strContent_page =  new String();
        strContent_page =  'NU_' + affiche_off[i_off] ;
        var id_page     =  document.getElementById(strContent_page);
        if(id_page!=null){
            id_page.className = "off";
        }
    }
    // on affiche les éléments de la bonne page
    strContent_PB_page      = 'NU_PB_' + affiche_on ;
    var id_PB_page          = document.getElementById(strContent_PB_page);
    id_PB_page.className    = "select";
    
    strContent_page         = new String();
    strContent_page         = 'NU_' + affiche_on ;
    if(id_page = document.getElementById(strContent_page)){
        id_page.className   = "on";
    }
}

//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'obtention de la liste des utilisateurs
//-------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage du tableau des resultats
function init_Tableau_utilisateur_list(Tableau_utilisateur_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_utilisateur_temp)
    {   
        Tableau_utilisateur_list = Tableau_utilisateur_temp;
    }
    else
    {
        Tableau_utilisateur_list[0]         =  new Array();
        Tableau_utilisateur_list[0]['name'] = 'aucun résultat disponnible';
    }
    //alert(array2json(Tableau_utilisateur_list));
    affiche_Tableau_utilisateur_list();
}
// requette pour l'obtention du tableau des resultats
function get_Tableau_utilisateur_list()
{ 
    var url_php = "/sc_admin_detail_company/get_list_utilisateur";
    $.getJSON(url_php,{},init_Tableau_utilisateur_list);
}

// filtre du tableau
function filtre_Tableau_utilisateur_list(){
    Tableau_utilisateur_filter = Tableau_utilisateur_list;
}

// affichage du tableau decompte memory
function affiche_Tableau_utilisateur_list(){
    filtre_Tableau_utilisateur_list();
    taille_tableau_content  =  taille_tableau_content_page['new_utilisateur'];
    var current_tableau     =  Tableau_utilisateur_filter;
    var strname             =  'new_utilisateur';
    var strnamebdd          =  'utilisateur';
    var stridentificateur   =  new Array('name','price','Assigned_memory','security_level');
    affiche_Tableau_new(current_tableau, strname, strnamebdd, stridentificateur);
    select_new_utilisateur(0);
}


// affiche la page num pour la liste des utilisateur
function go_page_new_utilisateur(num){
    if(num=='first'){
        content_tableau_current_page['new_utilisateur'] = 0;
    }else if(num=='end'){
        content_tableau_current_page['new_utilisateur'] = content_tableau_liste_page['new_utilisateur'].length-1;
    }else{
        var num_page = num + content_tableau_curseur_page['new_utilisateur'];
        content_tableau_current_page['new_utilisateur'] = content_tableau_liste_page['new_utilisateur'][num_page]-1;    
    }
    affiche_Tableau_utilisateur_list();
}


// selectionner (activer) un matériaux de la liste pour creer un nouveau materiaux
function select_new_utilisateur(num){
	var new_utilisateur_select = content_tableau_connect['new_utilisateur'][num];
	Tableau_utilisateur = clone(Tableau_utilisateur_list[new_utilisateur_select]);
	for(i=0; i<taille_tableau_content_page['new_utilisateur'] ;i++){
		strContent_check = 'new_utilisateur_check_' + i;
		id_check = document.getElementById(strContent_check);
		if(i==new_utilisateur_select){
			id_check.checked=true;
		}else{
			id_check.checked=false;
		}
	}
	//alert(array2json(Tableau_utilisateur));
}

// afficher le détail d'un utilisateur
function affich_detail_utilisateur(){
    var table_detail = Tableau_utilisateur['utilisateur'];
    //afficher le detail d'un model
    //alert(array2json(Tableau_utilisateur));
    for(key in table_detail){
	    var strContent_detail_key = 'utilisateur_' + key ;
	    var strContent_resume_key = 'resume_utilisateur_' + key ;
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
// fonctions utiles pour l'obtention de la liste des utilisateurs
//-------------------------------------------------------------------------------------------------

// requette pour l'obtention du tableau des resultats
function ok_new_utilisateur_info(result)
{
	alert(result);
	document.getElementById('new_utilisateur_pic_wait').classname = 'off';
	document.getElementById('new_utilisateur_pic_ok').classname = 'on';
	get_current_memory_account(Current_company['id']);
}


function send_new_utilisateur_info()
{ 
    document.getElementById('new_utilisateur_pic_wait').classname = 'on';
    document.getElementById('new_utilisateur_pic_ok').classname = 'off';
    var url_php = "/sc_admin_detail_company/valid_new_utilisateur";
    $.getJSON(url_php,{"id_company": Current_company['id'], "id_utilisateur":Tableau_utilisateur['utilisateur']['id']},ok_new_utilisateur_info);
}



//------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des tableaux
//------------------------------------------------------------------------------------------------------


// affichage des tableau content ('Resultat')
function affiche_Tableau_new(current_tableau, strname, strnamebdd, stridentificateur){
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
            id_lign.className = "newBoxTable_lign on";
	    if(pair(i)){
		id_pair.className = "newBoxTable_lign_pair";
	    }else{
		id_pair.className = "newBoxTable_lign_impair";
	    }
	    strtemp =  new Array();
	    for(j=0; j<stridentificateur.length; j++) {
		  strtemp[j] = current_tableau[i_page][strnamebdd][stridentificateur[j]];
		  remplacerTexte(idContent[j], strtemp[j]);
	    }
        }else{
            id_lign.className = "newBoxTable_lign off";
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

-->
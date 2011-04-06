<!--


// initialisation des type de forfaits possible pour l'achat d'un nouveau forfait
var Tableau_forfait_list            =  new Array();              // tableau des forfait
var Tableau_forfait             =  new Array();              // forfait selectionner
var Tableau_forfait_filter            =  new Array();              // forfait selectionner


//---------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage d'un nouveau forfait
//---------------------------------------------------------------------------------------------------------------------

//---------------------------------------------------------------------------------------------------------
// wizard de nouveau forfait
//---------------------------------------------------------------------------------------------------------

function displayNewForfait(interupteur) {
    displayBlack(interupteur);
    document.getElementById('New_wiz_layer').className = interupteur;
    NMcurrent_stape = 'page_information';
    affiche_Tableau_forfait_list();
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
	affich_detail_forfait();
	document.getElementById('wiz_annul').className    =  'on' ;
	document.getElementById('wiz_suiv').className    =  'off' ;
	document.getElementById('wiz_valid').className    =  'on' ;
	document.getElementById('wiz_fin').className    =  'off' ;
        affiche_NM_page();
    }
    else if(NMcurrent_stape == 'page_fichier'){
	send_new_forfait_info();
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

//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'obtention de la liste des forfaits
//-------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage du tableau des resultats
function init_Tableau_forfait_list(Tableau_forfait_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_forfait_temp)
    {   
        Tableau_forfait_list = Tableau_forfait_temp;
    }
    else
    {
        Tableau_forfait_list[0]         =  new Array();
        Tableau_forfait_list[0]['name'] = 'aucun résultat disponnible';
    }
    //alert(array2json(Tableau_forfait_list));
    affiche_Tableau_forfait_list();
}
// requette pour l'obtention du tableau des resultats
function get_Tableau_forfait_list()
{ 
    var url_php = "/sc_admin_detail_company/get_list_forfait";
    $.getJSON(url_php,{},init_Tableau_forfait_list);
}

// filtre du tableau
function filtre_Tableau_forfait_list(){
    Tableau_forfait_filter = Tableau_forfait_list;
}

// affichage du tableau decompte calcul
function affiche_Tableau_forfait_list(){
    filtre_Tableau_forfait_list();
    taille_tableau_content  =  taille_tableau_content_page['new_forfait'];
    var current_tableau     =  Tableau_forfait_filter;
    var strname             =  'new_forfait';
    var strnamebdd          =  'forfait';
    var stridentificateur   =  new Array('name','price','nb_jetons','nb_jetons_tempon','price_jeton');
    affiche_Tableau_new(current_tableau, strname, strnamebdd, stridentificateur);
    select_new_forfait(0);
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



// affiche la page num pour la liste des forfait
function go_page_new_forfait(num){
    if(num=='first'){
        content_tableau_current_page['new_forfait'] = 0;
    }else if(num=='end'){
        content_tableau_current_page['new_forfait'] = content_tableau_liste_page['new_forfait'].length-1;
    }else{
        var num_page = num + content_tableau_curseur_page['new_forfait'];
        content_tableau_current_page['new_forfait'] = content_tableau_liste_page['new_forfait'][num_page]-1;    
    }
    affiche_Tableau_forfait();
}


// selectionner (activer) un matériaux de la liste pour creer un nouveau materiaux
function select_new_forfait(num){
	var new_forfait_select = content_tableau_connect['new_forfait'][num];
	Tableau_forfait = clone(Tableau_forfait_list[new_forfait_select]);
	for(i=0; i<taille_tableau_content_page['new_forfait'] ;i++){
		strContent_check = 'new_forfait_check_' + i;
		id_check = document.getElementById(strContent_check);
		if(i==new_forfait_select){
			id_check.checked=true;
		}else{
			id_check.checked=false;
		}
	}
	//alert(array2json(Tableau_forfait));
}

// afficher le détail d'un forfait
function affich_detail_forfait(){
    var table_detail = Tableau_forfait['forfait'];
    //afficher le detail d'un model
    //alert(array2json(Tableau_forfait));
    for(key in table_detail){
	    var strContent_detail_key = 'forfait_' + key ;
	    var strContent_resume_key = 'resume_' + key ;
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
// fonctions utiles pour l'obtention de la liste des forfaits
//-------------------------------------------------------------------------------------------------

// requette pour l'obtention du tableau des resultats
function ok_new_forfait_info(result)
{
	//alert(result);
	document.getElementById('new_forfait_pic_wait').classname = 'off';
	document.getElementById('new_forfait_pic_ok').classname = 'on';
	get_current_calcul_account(Current_company['id']);
}


function send_new_forfait_info()
{ 
    document.getElementById('new_forfait_pic_wait').classname = 'on';
    document.getElementById('new_forfait_pic_ok').classname = 'off';
    var url_php = "/sc_admin_detail_company/valid_new_forfait";
    $.getJSON(url_php,{"id_company": Current_company['id'], "id_forfait":Tableau_forfait['forfait']['id']},ok_new_forfait_info);
}

-->
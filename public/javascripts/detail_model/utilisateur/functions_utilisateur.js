<!--


// initialisation des type de utilisateurs possible pour l'achat d'un nouveau utilisateur
var Tableau_utilisateur_new_list            =  new Array();              // tableau des utilisateur
var Tableau_utilisateur_new             =  new Array();              // utilisateur selectionner
var NUcurrent_stape			= 'page_information';
Tableau_utilisateur_new_filter         =  new Array();              // utilisateur selectionner
Tableau_utilisateur_select_filter = new Array();
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
    get_Tableau_utilisateur_new_list();
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
	affiche_Tableau_utilisateur_select_list();
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
function init_Tableau_utilisateur_new_list(Tableau_utilisateur_new_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_utilisateur_new_temp)
    {   
        Tableau_utilisateur_new_list = Tableau_utilisateur_new_temp;
	for(i in Tableau_utilisateur_new_list){
	    Tableau_utilisateur_new_list[i]['user']['select'] = false;
	    Tableau_utilisateur_new_list[i]['user']['droit'] = 'gestion';
	    //alert(array2json(Tableau_utilisateur_new_list[i]['user']));
	}
    }
    else
    {
        Tableau_utilisateur_new_list[0]         =  new Array();
        Tableau_utilisateur_new_list[0]['name'] = 'aucun résultat disponnible';
    }
    //alert(array2json(Tableau_utilisateur_new_list));
    affiche_Tableau_utilisateur_new_list();
}
// requette pour l'obtention du tableau des resultats
function get_Tableau_utilisateur_new_list()
{ 
    var url_php = "/detail_model/get_list_utilisateur_new";
    $.getJSON(url_php,{},init_Tableau_utilisateur_new_list);
}

// filtre du tableau
function filtre_Tableau_utilisateur_new_list(){
    Tableau_utilisateur_new_filter = Tableau_utilisateur_new_list;
}

// affichage du tableau decompte memory
function affiche_Tableau_utilisateur_new_list(){
    filtre_Tableau_utilisateur_new_list();
    taille_tableau_content  =  taille_tableau_content_page['new_utilisateur'];
    var current_tableau     =  Tableau_utilisateur_new_filter;
    var strname             =  'new_utilisateur';
    var strnamebdd          =  'user';
    var stridentificateur   =  new Array('name','email','role');
    affiche_Tableau_new(current_tableau, strname, strnamebdd, stridentificateur);
    select_new_utilisateur(-1);
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
    affiche_Tableau_utilisateur_new_list();
}


// selectionner (activer) un ou plusieurs utilsateurs de la liste 
function select_new_utilisateur(num){
	if(num == -1){
		for(i=0; i<content_tableau_connect['new_utilisateur'].length ;i++){
			strContent_check = 'new_utilisateur_check_' + i;
			id_check = document.getElementById(strContent_check);
			if(id_check != null){
				id_check.checked=false;
			}
		}
		for(i in Tableau_utilisateur_new_list){
		    Tableau_utilisateur_new_list[i]['user']['select'] = false;
		}
	}else{
		var new_utilisateur_select = content_tableau_connect['new_utilisateur'][num];
		strContent_check = 'new_utilisateur_check_' + num;
		id_check = document.getElementById(strContent_check);
		if(Tableau_utilisateur_new_filter[new_utilisateur_select]['user']['select']){
			Tableau_utilisateur_new_filter[new_utilisateur_select]['user']['select']=false;
			id_check.checked=false;
		}else{
			Tableau_utilisateur_new_filter[new_utilisateur_select]['user']['select']=true;
			id_check.checked=true;
		}
	}
}

// filtre du tableau
function filtre_Tableau_utilisateur_select_list(){
	Tableau_utilisateur_select_filter = new Array();
	num_select = 0;
	for(i in Tableau_utilisateur_new_list){
		if(Tableau_utilisateur_new_list[i]['user']['select']){
			Tableau_utilisateur_select_filter[num_select] = Tableau_utilisateur_new_list[i];
			num_select += 1;
		}
	}
}

// affichage du tableau decompte memory
function affiche_Tableau_utilisateur_select_list(){
    filtre_Tableau_utilisateur_select_list();
    taille_tableau_content  =  taille_tableau_content_page['select_utilisateur'];
    var current_tableau     =  Tableau_utilisateur_select_filter;
    var strname             =  'select_utilisateur';
    var strnamebdd          =  'user';
    var stridentificateur   =  new Array('name','email','role');
    affiche_Tableau_new(current_tableau, strname, strnamebdd, stridentificateur);
}

// affiche la page num pour la liste des utilisateur
function go_page_select_utilisateur(num){
    if(num=='first'){
        content_tableau_current_page['select_utilisateur'] = 0;
    }else if(num=='end'){
        content_tableau_current_page['select_utilisateur'] = content_tableau_liste_page['select_utilisateur'].length-1;
    }else{
        var num_page = num + content_tableau_curseur_page['select_utilisateur'];
        content_tableau_current_page['select_utilisateur'] = content_tableau_liste_page['select_utilisateur'][num_page]-1;    
    }
    affiche_Tableau_utilisateur_select_list();
}


// afficher le détail d'un utilisateur
function affich_detail_utilisateur_new(){
    var table_detail = Tableau_utilisateur_new['utilisateur'];
    //afficher le detail d'un model
    //alert(array2json(Tableau_utilisateur_new));
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
	affich_Utilisateurs();
}


function send_new_utilisateur_info()
{ 
    send_info = array2json(Tableau_utilisateur_select_filter);
    alert(send_info);
    document.getElementById('new_utilisateur_pic_wait').classname = 'on';
    document.getElementById('new_utilisateur_pic_ok').classname = 'off';
    var url_php = "/detail_model/valid_new_utilisateur";
    $.get(url_php,{"id_model": model_id, "file":send_info},ok_new_utilisateur_info);
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
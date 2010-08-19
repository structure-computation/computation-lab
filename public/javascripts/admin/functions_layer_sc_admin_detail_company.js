<!--
//---------------------------------------------------------------------------------------------------------
// initialisation
//---------------------------------------------------------------------------------------------------------


var Current_company                   =  new Array();              // company courrante
var Current_calcul_account             =  new Array();              // calcul account courrant
var Current_memory_account             =  new Array();              // memory account courrant

var NMcurrent_stape                 =  0;                        // étape pour le wizzard nouveau resultat

var Tableau_gestionnaires              =  new Array();              // tableau des gestionnaires
var Tableau_gestionnaires_filter            =  new Array();              // tableau des resultats filtres pour l'affichage

//initialisation de la taille du tableau pour la box content et de la table de correspondance
var taille_tableau_content          =  20;                       // taille du tableau dans la content box
var content_tableau_connect         =  new Array();              // connectivité entre l'id de l'element graphique (div) et l'élément du tableau affiché dedans  
var content_tableau_current_page    =  new Array();              // numéro de la page du tableau (sert pour la définition de la connectivité)    
var content_tableau_curseur_page    =  new Array();              // nombre de page du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_liste_page      =  new Array();              // liste des pages du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_page            =  new Array('gestionnaire','new_forfait','new_abonnement');    // initialisation des pages avec tableau dynamique

var taille_tableau_content_page     =  new Array()               // taille du tableau dans la content box
taille_tableau_content_page['gestionnaire'] = 20;
taille_tableau_content_page['new_forfait'] = 8;
taille_tableau_content_page['new_abonnement'] = 8;


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


//---------------------------------------------------------------------------------------------------------
// pour l'affichage des différent onglet du modele
//---------------------------------------------------------------------------------------------------------

function cadres_off(){
  list_str_id = new Array('CadreAbonnement', 'CadreForfait', 'CadreGestionnaires', 'CadreDescription');
  list_str_menu_id = new Array('MenuCompanyAbonnement', 'MenuCompanyForfait', 'MenuCompanyGestionnaires', 'MenuCompanyDescription');
  for(i=0; i<list_str_id.length; i++){
    strtemp = list_str_id[i];
    id_off = document.getElementById(strtemp);
    if(id_off != null){
      id_off.className = 'off';
    }
  }
  
  for(i=0; i<list_str_menu_id.length; i++){
    strtemp = list_str_menu_id[i];
    id_not_selected = document.getElementById(strtemp);
    if(id_not_selected != null){
      //alert(strtemp);
      id_not_selected.className = '';
    }
  }
}

function affich_Abonnement(){
  cadres_off();
  id_on = document.getElementById('CadreAbonnement');	
  id_on.className = 'on';
  
  id_selected = document.getElementById('MenuCompanyAbonnement');	
  id_selected.className = 'selected';
}

function affich_Forfait(){
  cadres_off();
  id_on = document.getElementById('CadreForfait');	
  id_on.className = 'on';
  
  id_selected = document.getElementById('MenuCompanyForfait');	
  id_selected.className = 'selected';
}

function affich_Gestionnaires(){
  get_Tableau_gestionnaires(Current_company['id']);
  cadres_off();
  id_on = document.getElementById('CadreGestionnaires');	
  id_on.className = 'on';
  
  id_selected = document.getElementById('MenuCompanyGestionnaires');	
  id_selected.className = 'selected';
}

function affich_Description(){
  cadres_off();
  id_on = document.getElementById('CadreDescription');	
  id_on.className = 'on';
  
  id_selected = document.getElementById('MenuCompanyDescription');	
  id_selected.className = 'selected';
}


//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'obtention de la liste des resultats (tableau)
//-------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage du tableau des resultats
function init_Tableau_gestionnaires(Tableau_gestionnaires_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_gestionnaires_temp)
    {   
        Tableau_gestionnaires = Tableau_gestionnaires_temp;
    }
    else
    {
        Tableau_gestionnaires[0]         =  new Array();
        Tableau_gestionnaires[0]['name'] = 'aucun résultat disponnible';
    }
    //alert(array2json(Tableau_resultat));
    affiche_Tableau_gestionnaires();
}
// requette pour l'obtention du tableau des resultats
function get_Tableau_gestionnaires(id_company)
{ 
    var url_php = "/sc_admin_detail_company/get_list_gestionnaires";
    $.getJSON(url_php,{"id_company": id_company},init_Tableau_gestionnaires);
}

// filtre du tableau
function filtre_Tableau_gestionnaires(){
    Tableau_gestionnaires_filter = Tableau_gestionnaires;
}

// affichage du tableau decompte calcul
function affiche_Tableau_gestionnaires(){
    filtre_Tableau_gestionnaires();
    taille_tableau_content  =  taille_tableau_content_page['gestionnaire'];
    var current_tableau     =  Tableau_gestionnaires_filter;
    var strname             =  'gestionnaire';
    var strnamebdd          =  'user';
    var stridentificateur   =  new Array('email','name');
    affiche_Tableau_content(current_tableau, strname, strnamebdd, stridentificateur);
}


//------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des tableaux
//------------------------------------------------------------------------------------------------------


// affichage des tableau content ('Resultat')
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
            id_lign.className = "contentBoxTable_lign on";
	    if(pair(i)){
		id_pair.className = "contentBoxTable_lign_pair";
	    }else{
		id_pair.className = "contentBoxTable_lign_impair";
	    }
	    strtemp =  new Array();
	    for(j=0; j<stridentificateur.length; j++) {
		  strtemp[j] = current_tableau[i_page][strnamebdd][stridentificateur[j]];
		  remplacerTexte(idContent[j], strtemp[j]);
	    }
        }else{
            id_lign.className = "contentBoxTable_lign off";
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



// affiche la page num pour la liste des gestionnaires
function go_page_gestionnaires(num){
    if(num=='first'){
        content_tableau_current_page['gestionnaire'] = 0;
    }else if(num=='end'){
        content_tableau_current_page['gestionnaire'] = content_tableau_liste_page['gestionnaire'].length-1;
    }else{
        var num_page = num + content_tableau_curseur_page['gestionnaire'];
        content_tableau_current_page['gestionnaire'] = content_tableau_liste_page['gestionnaire'][num_page]-1;    
    }
    affiche_Tableau_gestionnaires();
}


//---------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage du detail de la company
//---------------------------------------------------------------------------------------------------------

// traitement en fin de requette pour laffichage de la company
function init_Current_company(Current_company_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Current_company_temp)
    {   
        Current_company = Current_company_temp['company'];
    }
    //alert('ok');
    //alert(array2json(Current_company));
    affich_detail_company();
}
// requette pour l'obtention du tableau des resultats
function get_Current_company(id_company)
{ 
    var url_php = "/sc_admin_detail_company/index";
    $.getJSON(url_php,{"id_company": id_company},init_Current_company);
}



// afficher le détail d'une company
function affich_detail_company(){
    var table_detail = Current_company;
    //afficher le detail d'un model
    for(key in table_detail){
	    var strContent_detail_key = 'company_detail_' + key ;
	    var id_detail_key = document.getElementById(strContent_detail_key);
	    if(id_detail_key != null){
		strContent = new String();
		strContent = table_detail[key];
		//id_detail_key.value = Tableau_model_filter[num_select][key] ;
		remplacerTexte(id_detail_key, strContent);
	    }
    }
}


//---------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage du detail du calcul account
//---------------------------------------------------------------------------------------------------------

// traitement en fin de requette pour laffichage de la company
function init_current_calcul_account(Current_calcul_account_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Current_calcul_account_temp)
    {   
        Current_calcul_account = Current_calcul_account_temp['calcul_account'];
    }
    //alert('ok');
    //alert(array2json(Current_company));
    affich_detail_calcul_account();
}
// requette pour l'obtention du tableau des resultats
function get_current_calcul_account(id_company)
{ 
    var url_php = "/sc_admin_detail_company/get_calcul_account";
    $.getJSON(url_php,{"id_company": id_company},init_current_calcul_account);
}



// afficher le détail d'une company
function affich_detail_calcul_account(){
    var table_detail = Current_calcul_account;
    //afficher le detail d'un model
    for(key in table_detail){
	    var strContent_detail_key = 'calcul_account_' + key ;
	    var strContent_info_key = 'calcul_account_info_' + key ;
	    var id_detail_key = document.getElementById(strContent_detail_key);
	    var id_info_key = document.getElementById(strContent_info_key);
	    if(id_detail_key != null){
		strContent = new String();
		strContent = table_detail[key];
		remplacerTexte(id_detail_key, strContent);
	    }
	    if(id_info_key != null){
		strContent = new String();
		if(key=='base_jeton'){
			strContent = table_detail[key] + table_detail['report_jeton'];
			
		}else{
			strContent = table_detail[key];
		}
		remplacerTexte(id_info_key, strContent);
	    }
    }
    // taille de la progress_bar
    var progress_bar = document.getElementById('calcul_account_progress_bar'); 
    var info_progress_bar = document.getElementById('calcul_account_info_progress_bar');
    
    var taille_max= 294;
    var max_jeton = Current_calcul_account['report_jeton'] + Current_calcul_account['base_jeton'] + 1;
    var used_jeton = Current_calcul_account['used_jeton'];
    var taille_actuelle= used_jeton * taille_max / max_jeton;
    if(taille_actuelle>taille_max){taille_actuelle=taille_max;}
    
    progress_bar.style.width = taille_actuelle + 'px'; 
    info_progress_bar.style.width = taille_actuelle + 'px'; 
    //alert(progress_bar.style.width);
}


//---------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage du detail du memory account
//---------------------------------------------------------------------------------------------------------

// traitement en fin de requette pour laffichage du memory account
function init_current_memory_account(Current_memory_account_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Current_memory_account_temp)
    {   
        Current_memory_account = Current_memory_account_temp['memory_account'];
    }
    //alert('ok');
    //alert(array2json(Current_company));
    affich_detail_memory_account();
}
// requette pour l'obtention du tableau des resultats
function get_current_memory_account(id_company)
{ 
    var url_php = "/sc_admin_detail_company/get_memory_account";
    $.getJSON(url_php,{"id_company": id_company},init_current_memory_account);
}



// afficher le détail d'une company
function affich_detail_memory_account(){
    var table_detail = Current_memory_account;
    //afficher le detail d'un model
    for(key in table_detail){
	    var strContent_detail_key = 'memory_account_' + key ;
	    var strContent_info_key = 'memory_account_info_' + key ;
	    var id_detail_key = document.getElementById(strContent_detail_key);
	    var id_info_key = document.getElementById(strContent_info_key);
	    if(id_detail_key != null){
		strContent = new String();
		strContent = table_detail[key];
		remplacerTexte(id_detail_key, strContent);
	    }
	    if(id_info_key != null){
		strContent = new String();
		if(key=='base_jeton'){
			strContent = table_detail[key] + 10;
			
		}else{
			strContent = table_detail[key];
		}
		remplacerTexte(id_info_key, strContent);
	    }
    }
    // taille de la progress_bar
    var progress_bar = document.getElementById('memory_account_progress_bar'); 
    var info_progress_bar = document.getElementById('memory_account_info_progress_bar');
    
    var taille_max= 294;
    var max_memory = Current_memory_account['assigned_memory'] + 1;
    var used_memory = Current_memory_account['used_memory'];
    var taille_actuelle= used_memory * taille_max / max_memory;
    if(taille_actuelle>taille_max){taille_actuelle=taille_max;}
    
    progress_bar.style.width = taille_actuelle + 'px'; 
    info_progress_bar.style.width = taille_actuelle + 'px'; 
    //alert(progress_bar.style.width);
}



-->
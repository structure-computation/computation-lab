<!--
//---------------------------------------------------------------------------------------------------------
// initialisation
//---------------------------------------------------------------------------------------------------------


var Current_model                   =  new Array();              // modèle courrant

var NMcurrent_stape                 =  0;                        // étape pour le wizzard nouveau resultat

var Tableau_resultat                   =  new Array();              // tableau des resultats
var Tableau_resultat_filter            =  new Array();              // tableau des resultats filtres pour l'affichage

var Tableau_utilisateur                   =  new Array();              // tableau des resultats
var Tableau_utilisateur_filter            =  new Array();              // tableau des resultats filtres pour l'affichage

//initialisation de la taille du tableau pour la box content et de la table de correspondance
var taille_tableau_content          =  20;                       // taille du tableau dans la content box
var content_tableau_connect         =  new Array();              // connectivité entre l'id de l'element graphique (div) et l'élément du tableau affiché dedans  
var content_tableau_current_page    =  new Array();              // numéro de la page du tableau (sert pour la définition de la connectivité)    
var content_tableau_curseur_page    =  new Array();              // nombre de page du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_liste_page      =  new Array();              // liste des pages du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_page            =  new Array('resultat','utilisateur','file','new_utilisateur','select_utilisateur');    // initialisation des pages avec tableau dynamique

var taille_tableau_content_page     =  new Array()               // taille du tableau dans la content box
taille_tableau_content_page['resultat'] = 20;
taille_tableau_content_page['utilisateur'] = 20;
taille_tableau_content_page['file'] = 20;
taille_tableau_content_page['new_utilisateur'] = 8;
taille_tableau_content_page['select_utilisateur'] = 8;


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

// numero du calcul(resultat) selectionné pour la suppression
var num_delete_resultat = -1;

// pour le browser de navigation dans le model
//s_browser = new ScBrowser( "exploreModel" );

//---------------------------------------------------------------------------------------------------------
// pour l'affichage des différent onglet du modele
//---------------------------------------------------------------------------------------------------------

function cadres_off(){
  list_str_id = new Array('CadreOutils', 'CadreResultats', 'CadreUtilisateurs', 'CadreForum', 'CadreFile');
  list_str_menu_id = new Array('MenuModelOutils', 'MenuModelResultats', 'MenuModelUtilisateurs', 'MenuModelForum', 'MenuModelFile');
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

function affich_Outils(){
  cadres_off();
  id_on = document.getElementById('CadreOutils');	
  id_on.className = 'on';
  
  id_selected = document.getElementById('MenuModelOutils');	
  id_selected.className = 'selected';
}

function affich_Resultats(){
  get_Tableau_resultat(Current_model['id']);
  cadres_off();
  id_on = document.getElementById('CadreResultats');	
  id_on.className = 'on';
  
  id_selected = document.getElementById('MenuModelResultats');	
  id_selected.className = 'selected';
}

function affich_Utilisateurs(){
  get_Tableau_utilisateur(Current_model['id']);
  cadres_off();
  id_on = document.getElementById('CadreUtilisateurs');	
  id_on.className = 'on';
  
  id_selected = document.getElementById('MenuModelUtilisateurs');	
  id_selected.className = 'selected';
}

function affich_Forum(){
  cadres_off();
  id_on = document.getElementById('CadreForum');	
  id_on.className = 'on';
  
  id_selected = document.getElementById('MenuModelForum');	
  id_selected.className = 'selected';
}

function affich_Description(){
  cadres_off();
  id_on = document.getElementById('CadreDescription');	
  id_on.className = 'on';
  
  id_selected = document.getElementById('MenuModelDescription');	
  id_selected.className = 'selected';
}

function affich_File(){
  s_browser.launch( function( rep ) { alert( rep ); } );
//   get_Tableau_file(Current_model['id']);
  cadres_off();
  id_on = document.getElementById('CadreFile');  
  id_on.className = 'on';
  
  id_selected = document.getElementById('MenuModelFile');        
  id_selected.className = 'selected';
}


//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'onglet outil
//-------------------------------------------------------------------------------------------------
// telecharger le nom et la description du model
function send_model_mesh()
{
    // pour l'envoie du tableau model_new
    var queryString = $('#sc_model_form').formSerialize();
    $('#sc_model_form').ajaxSubmit(function(json) {
	var url_php = "/detail_model/index?id_model=" + Current_model['id'] ;
	$(location).attr('href',url_php);   
    });
}

// telecharger un fichier
function send_model_file()
{
    // pour l'envoie du tableau model_new
    var queryString = $('#send_file_form').formSerialize();
    $('#send_file_form').ajaxSubmit(function(json) {
        var url_php = "/detail_model/index?id_model=" + Current_model['id'] ;
        $(location).attr('href',url_php);   
    });
}


function refresh_page()
{
    var url_php = "/detail_model/index?id_model=" + Current_model['id'] ;
    $(location).attr('href',url_php);   
}


//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'obtention de la liste des resultats (tableau)
//-------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage du tableau des resultats
function init_Tableau_resultat(Tableau_resultat_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_resultat_temp)
    {   
        Tableau_resultat = Tableau_resultat_temp;
    }
    else
    {
        Tableau_resultat[0]         =  new Array();
        Tableau_resultat[0]['name'] = 'aucun résultat disponnible';
    }
    //alert(array2json(Tableau_resultat));
    affiche_Tableau_resultat();
}
// requette pour l'obtention du tableau des resultats
function get_Tableau_resultat(id_model)
{ 
    var url_php = "/detail_model/get_list_resultat";
    $.getJSON(url_php,{"id_model": id_model},init_Tableau_resultat);
}

// filtre du tableau
function filtre_Tableau_resultat(){
    //Tableau_resultat_filter = Tableau_resultat;
    Tableau_resultat_filter = new Array();
    for(i=0; i<Tableau_resultat.length; i++) {
       if(Tableau_resultat[i]['calcul_result']['state']=='temp' || Tableau_resultat[i]['calcul_result']['state']=='deleted'){
          //Tableau_resultat_filter.push(Tableau_resultat[i]);
       }else{
          Tableau_resultat_filter.push(Tableau_resultat[i]);
       }
    }
}

// affichage du tableau decompte calcul
function affiche_Tableau_resultat(){
    filtre_Tableau_resultat();
    taille_tableau_content  =  taille_tableau_content_page['resultat'];
    var current_tableau     =  Tableau_resultat_filter;
    var strname             =  'resultat';
    var strnamebdd          =  'calcul_result';
    var stridentificateur   =  new Array('result_date','name');
    affiche_Tableau_content(current_tableau, strname, strnamebdd, stridentificateur);
    complete_affiche_Tableau_resultat(current_tableau, strname, strnamebdd);
}

// complément pour l'affichage des résultats. changement de couleur en fonction du status... 
function complete_affiche_Tableau_resultat(current_tableau, strname, strnamebdd){
    var taille_Tableau=current_tableau.length;
    for(i=0; i<taille_tableau_content; i++) {
        i_page = i + content_tableau_current_page[strname] * taille_tableau_content;
        content_tableau_connect[strname][i]=i_page;
        
        strContent_lign = strname + '_lign_' + i;
	strContent_pair = strname + '_pair_' + i;
	strContent = 'resultat_4_' + i;
	//alert(strContent_lign);
	var id_lign  = document.getElementById(strContent_lign);
	var id_pair  = document.getElementById(strContent_pair);
	var idContent = document.getElementById(strContent);
        
        if(i_page<taille_Tableau){
            id_lign.className = "contentBoxTable_lign on";
            if(current_tableau[i_page][strnamebdd]['state']=='in_process'){
                id_pair.className = "contentBoxTable_lign_in_process";
                strtemp = 'process' ;
                remplacerTexte(idContent, strtemp);
            }else if(current_tableau[i_page][strnamebdd]['state']=='echec'){
                id_pair.className = "contentBoxTable_lign_echec";
                strtemp = 'echec' ;
                remplacerTexte(idContent, strtemp);
            }else{
                strtemp = '' ;
                remplacerTexte(idContent, strtemp);
            }
        }else{
            id_lign.className = "contentBoxTable_lign off";
        }
    }
}

// telecharger le resultat
function download_resultat(num){
    var num_select = content_tableau_connect['resultat'][num];
    var id_resultat = Tableau_resultat_filter[num_select]['calcul_result']['id'];
    if(Tableau_resultat_filter[num_select]['calcul_result']['state']=='finish'){
        var url_php = "/detail_model/download_resultat?id_model=" + model_id + "&id_resultat=" + id_resultat ;
        $(location).attr('href',url_php);  
    }else{
        alert('aucun résultat à télécharger');
    }
}

// affiche la page num pour la liste des resultats
function go_page_resultat(num){
    if(num=='first'){
        content_tableau_current_page['resultat'] = 0;
    }else if(num=='end'){
        content_tableau_current_page['resultat'] = content_tableau_liste_page['resultat'].length-1;
    }else{
        var num_page = num + content_tableau_curseur_page['resultat'];
        content_tableau_current_page['resultat'] = content_tableau_liste_page['resultat'][num_page]-1;    
    }
    affiche_Tableau_resultat();
}

//---------------------------------------------------------------------------------------------------------
// wizard de suppression du resultat ou calcul
//---------------------------------------------------------------------------------------------------------

// affichage du cache noir et du wizard suppression
function displayDeleteResultat(interupteur) {
    displayBlack(interupteur);
    document.getElementById('Delete_wiz_layer_resultat').className = "Delete_wiz_layer " + interupteur;
    
    document.getElementById('Delete_model_pic').className    =  'on' ;
    document.getElementById('Delete_model_pic_wait').className    =  'off' ;
    document.getElementById('Delete_model_pic_ok').className    =  'off' ;
    document.getElementById('Delete_model_pic_failed').className    =  'off' ;
    
    document.getElementById('Delete_wiz_annul').className    =  'left on' ;
    document.getElementById('Delete_wiz_delete').className    =  'right on' ;
    document.getElementById('Delete_wiz_close').className    =  'right off' ;
}

// fonction appellé à partir du tableau des modèles
function delete_resultat(num){
    var num_select = content_tableau_connect['resultat'][num];
    num_delete_resultat = num_select;
    var id_resultat = Tableau_resultat_filter[num_select]['calcul_result']['id'];
    displayDeleteResultat('on');
    var table_detail = Tableau_resultat_filter[num_select]['calcul_result'];
    for(key in table_detail){
        var strContent_detail_key = 'resultat_delete_' + key ;
        var id_detail_key = document.getElementById(strContent_detail_key);
        if(id_detail_key != null){
            strContent = new String();
            strContent = table_detail[key];
            //id_detail_key.value = Tableau_model_filter[num_select][key] ;
            remplacerTexte(id_detail_key, strContent);
        }
    }
}

// validation de la suppression
function valid_delete_resultat(){
    var id_resultat = Tableau_resultat_filter[num_delete_resultat]['calcul_result']['id'];
    document.getElementById('Delete_model_pic').className    =  'off' ;
    document.getElementById('Delete_model_pic_wait').className    =  'on' ;
    
    document.getElementById('Delete_wiz_delete').className    =  'right off' ;
    document.getElementById('Delete_wiz_close').className    =  'right on' ;
    
    var url_php = "/detail_model/delete_resultat";
    $.get(url_php,{"id_model": model_id, "id_resultat": id_resultat},resultat_delete);
}

// résultat de la requette de suppression
function resultat_delete(resultat){
    document.getElementById('Delete_model_pic_wait').className    =  'off' ;
    if(resultat == "true"){
      document.getElementById('Delete_model_pic_ok').className    =  'on' ;
      document.getElementById('Delete_model_pic_failed').className    =  'off' ;  
      get_Tableau_resultat(model_id);
    }else if(resultat == "false"){
      document.getElementById('Delete_model_pic_ok').className    =  'off' ;
      document.getElementById('Delete_model_pic_failed').className    =  'on' ;
    }
}


//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'obtention de la liste des utilisateurs (tableau)
//-------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage du tableau des resultats
function init_Tableau_utilisateur(Tableau_utilisateur_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_utilisateur_temp)
    {   
        Tableau_utilisateur = Tableau_utilisateur_temp;
    }
    else
    {
        Tableau_utilisateur[0]         =  new Array();
        Tableau_utilisateur[0]['name'] = 'aucun utilisateur disponnible';
    }
    //alert(array2json(Tableau_resultat));
    affiche_Tableau_utilisateur();
}
// requette pour l'obtention du tableau des resultats
function get_Tableau_utilisateur(id_model)
{ 
    var url_php = "/detail_model/get_list_utilisateur";
    $.getJSON(url_php,{"id_model": id_model},init_Tableau_utilisateur);
}

// filtre du tableau
function filtre_Tableau_utilisateur(){
    Tableau_utilisateur_filter = Tableau_utilisateur;
}

// affichage du tableau decompte calcul
function affiche_Tableau_utilisateur(){
    filtre_Tableau_utilisateur();
    taille_tableau_content  =  taille_tableau_content_page['utilisateur'];
    var current_tableau     =  Tableau_utilisateur_filter;
    var strname             =  'utilisateur';
    var strnamebdd          =  'user';
    var stridentificateur   =  new Array('email','name','role');
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




//---------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage du detail du modele
//---------------------------------------------------------------------------------------------------------

// traitement en fin de requette pour laffichage du tableau des resultats
function init_Current_model(Current_model_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Current_model_temp)
    {   
        Current_model = Current_model_temp['sc_model'];
    }
    //alert('ok');
    //alert(array2json(Current_model));
    affich_detail_modele();
}
// requette pour l'obtention du tableau des resultats
function get_Current_model(id_model)
{ 
    var url_php = "/detail_model/index";
    $.getJSON(url_php,{"id_model": id_model},init_Current_model);
}



// afficher le détail d'un modele
function affich_detail_modele(){
    var table_detail = Current_model;
    //afficher le detail d'un model
    for(key in table_detail){
	    var strContent_detail_key = 'sc_model_detail_' + key ;
	    var id_detail_key = document.getElementById(strContent_detail_key);
	    if(id_detail_key != null){
		strContent = new String();
		strContent = table_detail[key];
		//id_detail_key.value = Tableau_model_filter[num_select][key] ;
		remplacerTexte(id_detail_key, strContent);
	    }
    }
}

//---------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour aller sur les pages calcul ou visualisation de SCcompute
//---------------------------------------------------------------------------------------------------------------------

// lancer un calcul sur le model
function go_calcul(){
    var url_php = "/calcul/index?id_model=" + Current_model['id'] ;
    //alert(Current_model['id']);
    $(location).attr('href',url_php);
}

// visualiser le model
function go_visu(){
    var url_php = "/visualisation/index?id_model=" + Current_model['id'] ;
    //alert(Current_model['id']);
    $(location).attr('href',url_php);
}


-->
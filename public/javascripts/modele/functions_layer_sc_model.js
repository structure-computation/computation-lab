<!--

//---------------------------------------------------------------------------------------------------------
// initialisation
//---------------------------------------------------------------------------------------------------------

var NMcurrent_stape                 =  0;                        // étape pour le wizzard nouveau model

var Tableau_model                   =  new Array();              // tableau des models
var Tableau_model_filter            =  new Array();              // tableau des models filtres pour l'affichage

//initialisation de la taille du tableau pour la box content et de la table de correspondance
var taille_tableau_content          =  20;                       // taille du tableau dans la content box
var content_tableau_connect         =  new Array();              // connectivité entre l'id de l'element graphique (div) et l'élément du tableau affiché dedans  
var content_tableau_current_page    =  new Array();              // numéro de la page du tableau (sert pour la définition de la connectivité)    
var content_tableau_curseur_page    =  new Array();              // nombre de page du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_liste_page      =  new Array();              // liste des pages du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_page            =  new Array('sc_model');    // initialisation des pages avec tableau dynamique

for(i=0; i<content_tableau_page.length ; i++){
    content_tableau_connect[content_tableau_page[i]] = new Array(taille_tableau_content);
    content_tableau_current_page[content_tableau_page[i]] = 0;
    content_tableau_curseur_page[content_tableau_page[i]] = 0;
    content_tableau_liste_page[content_tableau_page[i]] = [1];
    for(j=0; j<taille_tableau_content ; j++){
        content_tableau_connect[content_tableau_page[i]][j]=j;
    }
}

// initialisation du tableau des info sur le nouveau modele
var Tableau_new_model_info  =  new Array();
Tableau_new_model_info['id_user'] = 'test';
Tableau_new_model_info['id_company'] = 'test';
Tableau_new_model_info['id_project'] = 'test';
Tableau_new_model_info['name'] = 'super';
Tableau_new_model_info['dim'] = 'test';
Tableau_new_model_info['description'] = 'description cool';



//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'obtention de la liste des modeles (tableau)
//-------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage du tableau des models
function init_Tableau_model(Tableau_model_temp)
// function init_Tableau_model(response)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_model_temp)
    {   
        // Tableau_model = clone(Tableau_model_temp);
        Tableau_model = Tableau_model_temp;
    }
    else
    {
        Tableau_model[0]         =  new Array();
        Tableau_model[0]['name'] = 'aucun model';
    }
    affiche_Tableau_model();
}

// requette pour l'obtention du tableau des models
function get_Tableau_model()
{
    var url_php = "/modele/index";
    // $.getJSON(url_php,init_Tableau_model);
    $.getJSON(url_php,[],init_Tableau_model);
}


//---------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage de la liste des modeles (tableau)
//---------------------------------------------------------------------------------------------------------------------

function filtre_Tableau_model(){
    Tableau_model_filter = Tableau_model;
    
}

// affichage du tableau des models
function affiche_Tableau_model(){
    taille_tableau_content  =  20;
    filtre_Tableau_model();
    var current_tableau     =  Tableau_model_filter;
    var strname             =  'sc_model';
    // var stridentificateur   =  new Array('name','project','new_results','résults');
    var stridentificateur   =  new Array('name','description','new_results','résults');
    affiche_Tableau_content(current_tableau, strname, stridentificateur);
}

// affichage des tableau content ('sc_model')
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
        var id_lign  = document.getElementById(strContent_lign);
	var id_pair  = document.getElementById(strContent_pair);
        var id_2     = document.getElementById(strContent_2);
        var id_3     = document.getElementById(strContent_3);
        var id_4     = document.getElementById(strContent_4);
        
        if(i_page<taille_Tableau){
            id_lign.className = "largeBoxTable_Model_lign on";
	    if(pair(i)){
		id_pair.className = "largeBoxTable_Model_lign_pair";
	    }else{
		id_pair.className = "largeBoxTable_Model_lign_impair";
	    }
            // TODO: Ajout temporaire de 'sc_model' pour s'adapter au test courant.
            strtemp_2 = current_tableau[i_page]['sc_model'][stridentificateur[0]];
            strtemp_3 = current_tableau[i_page]['sc_model'][stridentificateur[1]];
            strtemp_4 = current_tableau[i_page]['sc_model'][stridentificateur[2]] + '/' + current_tableau[i_page][stridentificateur[3]];
            remplacerTexte(id_2, strtemp_2);
            remplacerTexte(id_3, strtemp_3);
            remplacerTexte(id_4, strtemp_4);
        }else{
            id_lign.className = "largeBoxTable_Model_lign off";
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

// affiche la page num pour la liste des models
function go_page_model(num){
    if(num=='first'){
        content_tableau_current_page['sc_model'] = 0;
    }else if(num=='end'){
        content_tableau_current_page['sc_model'] = content_tableau_liste_page['sc_model'].length-1;
    }else{
        var num_page = num + content_tableau_curseur_page['sc_model'];
        content_tableau_current_page['sc_model'] = content_tableau_liste_page['sc_model'][num_page]-1;    
    }
    affiche_Tableau_model();
}

//---------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage du detail d'un modele
//---------------------------------------------------------------------------------------------------------------------


// afficher le détail d'un modele
function affich_detail_modele(num){
    var num_select = content_tableau_connect['sc_model'][num];
    var table_detail = Tableau_model_filter[num_select]['sc_model'];
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
 
    strModelListe = 'ModelListe';    
    IdModelListe     = document.getElementById(strModelListe);
    IdModelListe.className = "off";
    strModelDetail = 'ModelDetail';    
    IdModelDetail  = document.getElementById(strModelDetail);
    IdModelDetail.className = "on";
    //setTimeout($('#ModelListe').slideUp("slow"),1250);
}
// fermer le détail d'un modele
function ferme_detail_modele(){
    strModelDetail = 'ModelDetail';    
    IdModelDetail  = document.getElementById(strModelDetail);
    IdModelDetail.className = "off";
    trModelListe = 'ModelListe';    
    IdModelListe     = document.getElementById(strModelListe);
    IdModelListe.className = "on";
    //setTimeout($('#ModelDetail').slideUp("slow"),1250);
    
}

//---------------------------------------------------------------------------------------------------------
// wizard de creation model
//---------------------------------------------------------------------------------------------------------

function displayNewModel(interupteur) {
    displayBlack(interupteur);
    document.getElementById('New_wiz_layer').className = interupteur;
    NMcurrent_stape = 'page_information';
    if(interupteur=='on'){
	new_model_info_affiche_value();
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
        //send_new_model_info();
        NMcurrent_stape = 'page_resume';
	affich_new_model_resume();
        affiche_NM_page();
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

//afficher les info d'un nouveau model
function new_model_info_affiche_value(){
	for(key in Tableau_new_model_info){
		var strContent_info_key = 'sc_model_info_' + key ;
		var id_info_key = document.getElementById(strContent_info_key);
		if(id_info_key != null){
			id_info_key.value = Tableau_new_model_info[key] ;
		}
	}
	
}

//changer les info d'un nouveau model
function new_model_info_change_value(){
	for(key in Tableau_new_model_info){
		var strContent_info_key = 'sc_model_info_' + key ;
		var id_info_key = document.getElementById(strContent_info_key);
		if(id_info_key != null){
			Tableau_new_model_info[key] = id_info_key.value ;
		}
	}
	
}

// afficher le resumé d'un materiaux
function affich_new_model_resume(){
   for(key in Tableau_new_model_info){
		var str_info_key = 'sc_model_resume_' + key ;
		var id_info_key = document.getElementById(str_info_key);
		if(id_info_key != null){
			strContent_info_key = Tableau_new_model_info[key] ; 
			remplacerTexte(id_info_key, strContent_info_key);
		}
	}
}

//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'envoie des infos sur le nouveau model
//-------------------------------------------------------------------------------------------------

// Always send the authenticity_token with ajax
// $(document).ajaxSend(function(event, request, settings) {
//   if ( settings.type == 'post' || settings.type == 'put' ) {
//     settings.data = (settings.data ? settings.data + "&" : "")
//       + "authenticity_token=" + encodeURIComponent( AUTH_TOKEN );
//     request.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
//   }
// });


// telecharger le fichier de maillage de maniere asynchrone
function UploadAsyncrone() {
    $("#fichier").makeAsyncUploader({
      upload_url: "/modele/upload", 
      flash_url: '/javascripts/sources_ext/swfupload.swf',
      button_image_url: '/images/blankButton.png'
    });
//     $('#fichier').uploadify({
//         'uploader': '/javascripts/sources_ext/jquery_uploadify/uploadify.swf',
//         'script':    '/modele/upload',
//         'scriptData': { 'format': 'json'},// 'authenticity_token': encodeURIComponent('<%= form_authenticity_token if protect_against_forgery? %>'), '<%= Rails.configuration.action_controller.session[:session_key]%>': '<%= u session.session_id %>' },
//         'cancelImg': '/images/cancel.png',
//         'scriptAccess': 'always',
//         //'buttonImg': '/images/blankButton.png',
//         'auto'           : true,
//     });

    //alert('on est dans la fonction');
}  

// $(document).ajaxSend(function(event, request, settings) {
//   if (typeof(AUTH_TOKEN) == "undefined") return;
//   // settings.data is a serialized string like "foo=bar&baz=boink" (or null)
//   settings.data = settings.data || "";
//   settings.data += (settings.data ? "&" : "") + "authenticity_token=" + encodeURIComponent(AUTH_TOKEN);
// });

// telecharger le nom et la description du model
function send_new_model_info()
{
    var url_php = "/modele/create";
    var param1 = array2object(Tableau_new_model_info);
    var Tableau_new_model_info_post         =  new Object(); 
    Tableau_new_model_info_post['sc_model'] =  new Object(); 
    Tableau_new_model_info_post['sc_model'] = param1;
    $.ajax({
	url: "/modele/create",
	type: 'POST',
	dataType: 'json',
	data: $.toJSON(Tableau_new_model_info_post),
	contentType: 'application/json; charset=utf-8',
	success: function(json) {
	    alert(json);
	}
    });

}


-->
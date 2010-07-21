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

var taille_tableau_content_page     =  new Array()               // taille du tableau dans la content box
taille_tableau_content_page['sc_model'] = 20;


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

// initialisation du tableau des info sur le nouveau modele
var Tableau_new_model_info  =  new Array();
Tableau_new_model_info['id_user'] = 'test';
Tableau_new_model_info['id_company'] = 'test';
Tableau_new_model_info['id_project'] = 'test';
Tableau_new_model_info['name'] = '';
Tableau_new_model_info['dimension'] = 'test';
Tableau_new_model_info['description'] = '';



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

// affichage du tableau modeles
function affiche_Tableau_model(){
    taille_tableau_content  =  taille_tableau_content_page['sc_model'];
    filtre_Tableau_model();
    var current_tableau     =  Tableau_model_filter;
    var strname             =  'sc_model';
    var strnamebdd          =  'sc_model';
    var stridentificateur   =  new Array('name','project','results');
    affiche_Tableau_content(current_tableau, strname, strnamebdd, stridentificateur);
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
// fonctions utiles pour aller sur les pages calcul, resultat ou visualisation de SCcompute
//---------------------------------------------------------------------------------------------------------------------


// lancer un calcul sur le model
function go_calcul(num){
    var num_select = content_tableau_connect['sc_model'][num];
    if(Tableau_model_filter[num_select]['sc_model']['state'] != "active"){
	alert("Vous devez d'abord déposer votre maillage");
    }else{
	var id_model = Tableau_model_filter[num_select]['sc_model']['id'];
	var url_php = "/calcul/index?id_model=" + id_model ;
	$(location).attr('href',url_php);
    }
}

// visualiser le model
function go_visu(num){
    var num_select = content_tableau_connect['sc_model'][num];
    if(Tableau_model_filter[num_select]['sc_model']['state'] != "active"){
	alert("Vous devez d'abord déposer votre maillage");
    }else{
	var id_model = Tableau_model_filter[num_select]['sc_model']['id'];
	var url_php = "/visualisation/index?id_model=" + id_model ;
	$(location).attr('href',url_php);
    }
}


// afficher le détail d'un modele
function go_detail_model(num){
    var num_select = content_tableau_connect['sc_model'][num];
    var id_model = Tableau_model_filter[num_select]['sc_model']['id'];
    var url_php = "/detail_model/index?id_model=" + id_model ;
    $(location).attr('href',url_php);
}

// aller voir les resultats
function go_resultat(num){
    var num_select = content_tableau_connect['sc_model'][num];
    var id_model = Tableau_model_filter[num_select]['sc_model']['id'];
    var url_php = "/resultat/index?id_model=" + id_model ;
    $(location).attr('href',url_php);
}

// effacer un modele
function resultat_delete(resultat){
    alert(resultat);
    get_Tableau_model();
}

function delete_model(num){
    var num_select = content_tableau_connect['sc_model'][num];
    var id_model = Tableau_model_filter[num_select]['sc_model']['id'];
    var url_php = "/modele/delete";
    $.get(url_php,{"id_model": id_model},resultat_delete);
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
	document.getElementById('wiz_annul').className    =  'on' ;
	document.getElementById('wiz_suiv').className    =  'off' ;
	document.getElementById('wiz_valid').className    =  'on' ;
	document.getElementById('wiz_fin').className    =  'off' ;
        affiche_NM_page();
    }
    else if(NMcurrent_stape == 'page_fichier'){
        send_new_model_info();
        NMcurrent_stape = 'page_resume';
	document.getElementById('wiz_annul').className    =  'off' ;
	document.getElementById('wiz_suiv').className    =  'off' ;
	document.getElementById('wiz_valid').className    =  'off' ;
	document.getElementById('wiz_fin').className    =  'on' ;
	affich_new_model_resume();
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

// fin du wizard nouveau modele
function NM_fin_wizard(){
    displayNewModel('off');
    get_Tableau_model();
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


function  ajax_form(){ 
    $('#sc_model_form').ajaxForm({dataType: 'script'});
    //alert("Thank you for your comment!"); 
}

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
    $("#new_model_pic_wait").ajaxStart(function(){
      $(this).show();
      $("#new_model_pic_ok").hide();
    });
    
    // pour l'envoie du tableau model_new
    var param1 = array2object(Tableau_new_model_info);
    var Tableau_new_model_info_post         =  new Object(); 
    Tableau_new_model_info_post['sc_model'] =  new Object(); 
    Tableau_new_model_info_post['sc_model'] = param1;
    
    var queryString = $('#sc_model_form').formSerialize();
    $('#sc_model_form').ajaxSubmit(function(json) {
	    //alert(json);
	    $("#new_model_pic_wait").hide();
	    $("#new_model_pic_ok").show();
	});

//     $.ajax({
// 	//url: "/modele/create",
// 	url: "/modele/send_info",
// 	type: 'POST',
// 	//dataType: 'text',
// 	//data: $.toJSON(Tableau_new_model_info_post),
// 	data: queryString,
// 	//contentType: 'application/json; charset=utf-8',
// 	success: function(json) {
// 	    alert(json);
// 	    $("#new_model_pic_wait").hide();
// 	    $("#new_model_pic_ok").show();
// 	}
//     });

}


-->
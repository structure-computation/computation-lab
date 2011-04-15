<!--
//---------------------------------------------------------------------------------------------------------
// initialisation
//---------------------------------------------------------------------------------------------------------

var NMcurrent_stape                 =  0;                        // étape pour le wizzard nouveau membre

var Tableau_membre                   =  new Array();              // tableau des membres
var Tableau_membre_filter            =  new Array();              // tableau des membres filtres pour l'affichage

//initialisation de la taille du tableau pour la box content et de la table de correspondance
var taille_tableau_content          =  20;                       // taille du tableau dans la content box
var content_tableau_connect         =  new Array();              // connectivité entre l'id de l'element graphique (div) et l'élément du tableau affiché dedans  
var content_tableau_current_page    =  new Array();              // numéro de la page du tableau (sert pour la définition de la connectivité)    
var content_tableau_curseur_page    =  new Array();              // nombre de page du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_liste_page      =  new Array();              // liste des pages du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_page            =  new Array('membre');    // initialisation des pages avec tableau dynamique

var taille_tableau_content_page     =  new Array()               // taille du tableau dans la content box
taille_tableau_content_page['membre'] = 20;


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

// numero du membre selectionné pour la suppression
var num_delete_membre = -1;

// initialisation du tableau des info sur le nouveau membree
var Tableau_new_membre  =  new Array();



//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'obtention de la liste des membres (tableau)
//-------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage du tableau des membres
function init_Tableau_membre(Tableau_membre_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_membre_temp)
    {   
        Tableau_membre = Tableau_membre_temp;
    }
    else
    {
        Tableau_membre[0]         =  new Array();
        Tableau_membre[0]['name'] = 'aucun membre';
    }
    affiche_Tableau_membre();
}
// requette pour l'obtention du tableau des membres
function get_Tableau_membre()
{ 
    var url_php = "/company/list_membre";
    $.getJSON(url_php,[],init_Tableau_membre);
}


//------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage de la liste des membres (tableau)
//------------------------------------------------------------------------------------------------------

function filtre_Tableau_membre(){
    Tableau_membre_filter = Tableau_membre;
}

// affichage du tableau membre
function affiche_Tableau_membre(){
    taille_tableau_content  =  taille_tableau_content_page['membre'];
    filtre_Tableau_membre();
    var current_tableau     =  Tableau_membre_filter;
    var strname             =  'membre';
    var strnamebdd          =  'user';
    var stridentificateur   =  new Array('email','firstname','role','state');
    affiche_Tableau_content(current_tableau, strname, strnamebdd, stridentificateur);
}

// affiche la page num pour la liste des membres
function go_page_membre(num){
    if(num=='first'){
        content_tableau_current_page['membre'] = 0;
    }else if(num=='end'){
        content_tableau_current_page['membre'] = content_tableau_liste_page['membre'].length-1;
    }else{
        var num_page = num + content_tableau_curseur_page['membre'];
        content_tableau_current_page['membre'] = content_tableau_liste_page['membre'][num_page]-1;    
    }
    affiche_Tableau_membre();
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
// fonctions utiles pour l'affichage du detail d'un membre
//---------------------------------------------------------------------------------------------------------------------


// afficher le détail d'un membre
function affich_detail_membre(num){
    var num_select = content_tableau_connect['membre'][num];
    var table_detail = Tableau_membre_filter[num_select]['user'];
    //test1=array2json(table_detail);
    //alert(test1);
    //afficher le detail d'un membre
    for(key in table_detail){
	    var strContent_detail_key = 'membre_detail_' + key ;
	    var id_detail_key = document.getElementById(strContent_detail_key);
	    if(id_detail_key != null){
		strContent = new String();
		strContent = table_detail[key];
		//id_detail_key.value = Tableau_membre_filter[num_select][key] ;
		remplacerTexte(id_detail_key, strContent);
	    }
    }
 
    strModelListe = 'MembreListe';    
    IdModelListe     = document.getElementById(strModelListe);
    IdModelListe.className = "off";
    strModelDetail = 'MembreDetail';    
    IdModelDetail  = document.getElementById(strModelDetail);
    IdModelDetail.className = "on";
    //setTimeout($('#ModelListe').slideUp("slow"),1250);
}
// fermer le détail d'un membree
function ferme_detail_membre(){
    strModelDetail = 'MembreDetail';    
    IdModelDetail  = document.getElementById(strModelDetail);
    IdModelDetail.className = "off";
    trModelListe = 'MembreListe';    
    IdModelListe     = document.getElementById(strModelListe);
    IdModelListe.className = "on";
    //setTimeout($('#ModelDetail').slideUp("slow"),1250);
    
}

//---------------------------------------------------------------------------------------------------------
// wizard de suppression d'un membre
//---------------------------------------------------------------------------------------------------------

// affichage du cache noir et du wizard suppression
function displayDeleteMembre(interupteur) {
    displayBlack(interupteur);
    document.getElementById('Delete_wiz_layer').className = "Delete_wiz_layer " + interupteur;
    
    document.getElementById('Delete_membre_pic').className    =  'on' ;
    document.getElementById('Delete_membre_pic_wait').className    =  'off' ;
    document.getElementById('Delete_membre_pic_ok').className    =  'off' ;
    document.getElementById('Delete_membre_pic_failed').className    =  'off' ;
    
    document.getElementById('Delete_wiz_annul').className    =  'left on' ;
    document.getElementById('Delete_wiz_delete').className    =  'right on' ;
    document.getElementById('Delete_wiz_close').className    =  'right off' ;
}

// fonction appellé à partir du tableau des modèles
function delete_membre(num){
    var num_select = content_tableau_connect['membre'][num];
    num_delete_membre = num_select;
    var id_membre = Tableau_membre_filter[num_select]['user']['id'];
    displayDeleteMembre('on');
    var table_detail = Tableau_membre_filter[num_select]['user'];
    for(key in table_detail){
	    var strContent_detail_key = 'membre_delete_' + key ;
	    var id_detail_key = document.getElementById(strContent_detail_key);
	    if(id_detail_key != null){
		strContent = new String();
		strContent = table_detail[key];
		//id_detail_key.value = Tableau_membre_filter[num_select][key] ;
		remplacerTexte(id_detail_key, strContent);
	    }
    }
}

// validation de la suppression
function valid_delete_membre(){
    var id_membre = Tableau_membre_filter[num_delete_membre]['user']['id'];
    
    document.getElementById('Delete_membre_pic').className    =  'off' ;
    document.getElementById('Delete_membre_pic_wait').className    =  'on' ;
    
    document.getElementById('Delete_wiz_delete').className    =  'right off' ;
    document.getElementById('Delete_wiz_close').className    =  'right on' ;
    
    var url_php = "/company/delete_user";
//     var url_php = "/users/destroy";
    $.get(url_php,{"id_membre": id_membre},resultat_delete);
}

// résultat de la requette de suppression
function resultat_delete(resultat){
    document.getElementById('Delete_membre_pic_wait').className    =  'off' ;
    //alert(resultat);
    if(resultat.match("true")){
      document.getElementById('Delete_membre_pic_ok').className    =  'on' ;
      document.getElementById('Delete_membre_pic_failed').className    =  'off' ;  
      get_Tableau_membre();
    }else if(resultat.match("false")){
      document.getElementById('Delete_membre_pic_ok').className    =  'off' ;
      document.getElementById('Delete_membre_pic_failed').className    =  'on' ;
    }
}


//---------------------------------------------------------------------------------------------------------
// wizard de creation membre
//---------------------------------------------------------------------------------------------------------

function displayNewMembre(interupteur) {
    displayBlack(interupteur);
    document.getElementById('New_wiz_layer').className = interupteur;
    NMcurrent_stape = 'page_information';
    if(interupteur=='on'){
	new_membre_affiche_value();
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
        send_new_membre();
        NMcurrent_stape = 'page_resume';
	affich_new_membre_resume();
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

// afficher le resumé d'un materiaux
function affich_new_membre_resume(){
   for(key in Tableau_new_membre){
		var str_info_key = 'new_membre_resume_' + key ;
		var id_info_key = document.getElementById(str_info_key);
		if(id_info_key != null){
			strContent_info_key = Tableau_new_membre[key] ; 
			remplacerTexte(id_info_key, strContent_info_key);
		}
	}
}

//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'envoie des infos sur le nouveau membre
//-------------------------------------------------------------------------------------------------


// telecharger le nom et la description du membre
function send_new_membre()
{
    alert(array2json(Tableau_new_membre));
    var param1 = array2object(Tableau_new_membre);
    var Tableau_new_membre_post         =  new Object(); 
    Tableau_new_membre_post['user']     =  new Object(); 
    Tableau_new_membre_post['user']     =  param1;
    alert(array2json(Tableau_new_membre_post));
    $.ajax({
	//url: "/company/create_user",
	url: "/member/create",
	type: 'POST',
	dataType: 'text',
	data: $.toJSON(param1),
	contentType: 'application/json; charset=utf-8',
	success: function(json) {
	    //alert(json);
	    get_Tableau_membre();
	}
    });

}

-->
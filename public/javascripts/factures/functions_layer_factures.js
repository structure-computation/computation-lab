<!--
//---------------------------------------------------------------------------------------------------------
// initialisation
//---------------------------------------------------------------------------------------------------------

var NMcurrent_stape                 =  0;                        // étape pour le wizzard nouveau facture

var Tableau_facture                   =  new Array();              // tableau des factures
var Tableau_facture_filter            =  new Array();              // tableau des factures filtres pour l'affichage

//initialisation de la taille du tableau pour la box content et de la table de correspondance
var taille_tableau_content          =  20;                       // taille du tableau dans la content box
var content_tableau_connect         =  new Array();              // connectivité entre l'id de l'element graphique (div) et l'élément du tableau affiché dedans  
var content_tableau_current_page    =  new Array();              // numéro de la page du tableau (sert pour la définition de la connectivité)    
var content_tableau_curseur_page    =  new Array();              // nombre de page du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_liste_page      =  new Array();              // liste des pages du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_page            =  new Array('facture');    // initialisation des pages avec tableau dynamique

var taille_tableau_content_page     =  new Array()               // taille du tableau dans la content box
taille_tableau_content_page['facture'] = 10;


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

//------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage de la liste des factures
//------------------------------------------------------------------------------------------------------

// traitement en fin de requette pour laffichage du tableau des materials
function init_Tableau_facture(Tableau_facture_temp)
{
    //alert(Tableau_facture_temp);
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_facture_temp)
    {   
        Tableau_facture = Tableau_facture_temp;
    }
    else
    {
        Tableau_facture[0]         =  new Array();
        Tableau_facture[0]['total'] = 'aucune facture';
    }
    affiche_Tableau_facture();
}
// requette pour l'obtention du tableau des materials
function get_Tableau_facture()
{ 
    var url_php = "/factures/get_facture";
    $.getJSON(url_php,[],init_Tableau_facture);
}

function filtre_Tableau_facture(){
    Tableau_facture_filter = Tableau_facture;
    var taille_Tableau=Tableau_facture_filter.length;
    for(i=0; i<taille_Tableau; i++) {
       Tableau_facture_filter[i]['facture']['numero'] = 'numéro_' + i ;
    }
}

// affichage du tableau decompte calcul
function affiche_Tableau_facture(){
    //alert(Tableau_facture[0]['facture']['created_at']);
    taille_tableau_content  =  taille_tableau_content_page['facture'];
    filtre_Tableau_facture();
    var current_tableau     =  Tableau_facture_filter;
    var strname             =  'facture';
    var strnamebdd          =  'facture';
    var stridentificateur   =  new Array('created_at','numero','type','total_calcul','total_memory','total');
    affiche_Tableau_content(current_tableau, strname, strnamebdd, stridentificateur);
}

// affiche la page num pour le decompte calcul
function go_page_facture(num){
    if(num=='first'){
        content_tableau_current_page['facture'] = 0;
    }else if(num=='end'){
        content_tableau_current_page['facture'] = content_tableau_liste_page['facture'].length-1;
    }else{
        var num_page = num + content_tableau_curseur_page['facture'];
        content_tableau_current_page['facture'] = content_tableau_liste_page['facture'][num_page]-1;    
    }
    affiche_Tableau_facture();
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
// fonctions utiles pour l'affichage du detail d'un facture
//---------------------------------------------------------------------------------------------------------------------


// afficher le détail d'un facture
function affich_detail_facture(num){
    var num_select = content_tableau_connect['facture'][num];
    var table_detail = Tableau_facture_filter[num_select]['user'];
    //test1=array2json(table_detail);
    //alert(test1);
    //afficher le detail d'un facture
    for(key in table_detail){
	    var strContent_detail_key = 'facture_detail_' + key ;
	    var id_detail_key = document.getElementById(strContent_detail_key);
	    if(id_detail_key != null){
		strContent = new String();
		strContent = table_detail[key];
		//id_detail_key.value = Tableau_facture_filter[num_select][key] ;
		remplacerTexte(id_detail_key, strContent);
	    }
    }
 
    strModelListe = 'FactureListe';    
    IdModelListe     = document.getElementById(strModelListe);
    IdModelListe.className = "off";
    strModelDetail = 'FactureDetail';    
    IdModelDetail  = document.getElementById(strModelDetail);
    IdModelDetail.className = "on";
    //setTimeout($('#ModelListe').slideUp("slow"),1250);
}
// fermer le détail d'un facturee
function ferme_detail_facture(){
    strModelDetail = 'FactureDetail';    
    IdModelDetail  = document.getElementById(strModelDetail);
    IdModelDetail.className = "off";
    trModelListe = 'FactureListe';    
    IdModelListe     = document.getElementById(strModelListe);
    IdModelListe.className = "on";
    //setTimeout($('#ModelDetail').slideUp("slow"),1250);
    
}

-->
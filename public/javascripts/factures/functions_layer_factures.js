<!--
//---------------------------------------------------------------------------------------------------------
// initialisation
//---------------------------------------------------------------------------------------------------------

var NMcurrent_stape                 =  0;                        // étape pour le wizzard nouveau facture

var Tableau_facture                   =  new Array();              // tableau des factures
var Tableau_facture_filter            =  new Array();              // tableau des factures filtres pour l'affichage
var current_facture_num	              =  -1;                       // numéro de la facture courrante dans Tableau_facture_filter

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
    //alert(array2json(Tableau_facture_temp));
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
//     var taille_Tableau=Tableau_facture_filter.length;
//     for(i=0; i<taille_Tableau; i++) {
//        Tableau_facture_filter[i]['facture']['numero'] = 'numéro_' + i ;
//     }
}

// affichage du tableau decompte calcul
function affiche_Tableau_facture(){
    //alert(Tableau_facture[0]['facture']['created_at']);
    taille_tableau_content  =  taille_tableau_content_page['facture'];
    filtre_Tableau_facture();
    var current_tableau     =  Tableau_facture_filter;
    var strname             =  'facture';
    var strnamebdd          =  'facture';
    var stridentificateur   =  new Array('ref','facture_type','total_price_HT','total_price_TTC','statut');
    affiche_Tableau_content(current_tableau, strname, strnamebdd, stridentificateur);
    supp_affiche_Tableau_factures();
}

// supplément pour l'affichage du tableau des factures
function supp_affiche_Tableau_factures(){
    for(i=0; i<taille_tableau_content_page['facture']; i++) {
        i_page = i + content_tableau_current_page['facture'] * taille_tableau_content_page['facture'];
	taille_Tableau=Tableau_facture_filter.length;
	if(i_page<taille_Tableau){
		if(Tableau_facture_filter[i_page]['facture']['statut']=='unpaid'){
// 			strContent_4 = 'facture_4_' + i;
// 			id_4  = document.getElementById(strContent_4);
// 			id_4.className = "contentBoxTable_3 on";
			strContent_pair = 'facture_pair_' + i;
			id_pair  = document.getElementById(strContent_pair);
			if(pair(i)){
			    id_pair.className = "largeBoxTable_lign_pair textred";
			}else{
			    id_pair.className = "largeBoxTable_lign_impair textred";
			}
// 		}else if(Tableau_factures_filter[i_page]['facture']['statut']=='paid'){
// 			strContent_4 = 'facture_4_' + i;
// 			id_4  = document.getElementById(strContent_4);
// 			id_4.className = "contentBoxTable_3 off";
		}
	}
    }
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
    current_facture_num = num_select;
    var table_detail = Tableau_facture_filter[num_select]['facture'];
    //test1=array2json(table_detail);
    //alert(test1);
    //afficher le detail d'un facture
    for(key in table_detail){
	    var strContent_detail_key = 'facture_detail_' + key ;
	    var id_detail_key = document.getElementById(strContent_detail_key);
	    if(id_detail_key != null){
		if(key == 'statut'){
			if(table_detail[key] == 'paid'){strContent = 'payée';}
			else if(table_detail[key] == 'unpaid'){strContent = 'en attente de paiement';}
		}else{
			strContent = table_detail[key];
		}
		remplacerTexte(id_detail_key, strContent);
		
	    }
    }
    
    id_calcul = document.getElementById("facture_detail_type_calcul");
    id_memoire = document.getElementById("facture_detail_type_memoire");
    if(table_detail['facture_type'] == 'calcul'){
	id_calcul.className = 'DetailCadreModel1 on';
	id_memoire.className = 'DetailCadreModel1 off';
	var table_detail_forfait = Tableau_facture_filter[num_select]['forfait'];
	for(key in table_detail_forfait){
		var strContent_detail_key = 'facture_detail_forfait_' + key ;
	      // alert(strContent_detail_key);
		var id_detail_key = document.getElementById(strContent_detail_key);
		if(id_detail_key != null){
		    strContent = new String();
		    strContent = table_detail_forfait[key];
		    remplacerTexte(id_detail_key, strContent);
		}
	}
    }else if(table_detail['facture_type'] == 'memoire'){
	id_calcul.className = 'DetailCadreModel1 off';
	id_memoire.className = 'DetailCadreModel1 on';
	var table_detail_abonnement = Tableau_facture_filter[num_select]['abonnement'];
	for(key in table_detail_abonnement){
		var strContent_detail_key = 'facture_detail_abonnement_' + key ;
		var id_detail_key = document.getElementById(strContent_detail_key);
		if(id_detail_key != null){
		    strContent = new String();
		    strContent = table_detail_abonnement[key];
		    remplacerTexte(id_detail_key, strContent);
		}
	}
    }
 
    strModelListe = 'FactureListe';    
    IdModelListe     = document.getElementById(strModelListe);
    IdModelListe.className = "off";
    strModelDetail = 'FactureDetail';    
    IdModelDetail  = document.getElementById(strModelDetail);
    IdModelDetail.className = "on";
    strfooter_top_3 = 'footer_top_3';    
    Idfooter_top_3  = document.getElementById(strfooter_top_3);
    Idfooter_top_3.className = "on";
    
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
    strfooter_top_3 = 'footer_top_3';    
    Idfooter_top_3  = document.getElementById(strfooter_top_3);
    Idfooter_top_3.className = "off";
    //setTimeout($('#ModelDetail').slideUp("slow"),1250);
    
}

//---------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour le téléchargement d'une facture
//---------------------------------------------------------------------------------------------------------------------

function download_facture(){
    //alert(current_facture_num);
    var id_facture = Tableau_facture_filter[current_facture_num]['facture']['id'];
    var url_php = "/factures/download_facture?id_facture=" + id_facture ;
    $(location).attr('href',url_php);  
}


-->
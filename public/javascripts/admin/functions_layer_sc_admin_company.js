<!--
//---------------------------------------------------------------------------------------------------------
// initialisation
//---------------------------------------------------------------------------------------------------------

var NMcurrent_stape                 =  0;                        // étape pour le wizzard nouveau company

var Tableau_company                   =  new Array();              // tableau des companys
var Tableau_company_filter            =  new Array();              // tableau des companys filtres pour l'affichage

//initialisation de la taille du tableau pour la box content et de la table de correspondance
var taille_tableau_content          =  20;                       // taille du tableau dans la content box
var content_tableau_connect         =  new Array();              // connectivité entre l'id de l'element graphique (div) et l'élément du tableau affiché dedans  
var content_tableau_current_page    =  new Array();              // numéro de la page du tableau (sert pour la définition de la connectivité)    
var content_tableau_curseur_page    =  new Array();              // nombre de page du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_liste_page      =  new Array();              // liste des pages du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_page            =  new Array('company');    // initialisation des pages avec tableau dynamique

for(i=0; i<content_tableau_page.length ; i++){
    content_tableau_connect[content_tableau_page[i]] = new Array(taille_tableau_content);
    content_tableau_current_page[content_tableau_page[i]] = 0;
    content_tableau_curseur_page[content_tableau_page[i]] = 0;
    content_tableau_liste_page[content_tableau_page[i]] = [1];
    for(j=0; j<taille_tableau_content ; j++){
        content_tableau_connect[content_tableau_page[i]][j]=j;
    }
}


//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'obtention de la liste des companys (tableau)
//-------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage du tableau des companys
function init_Tableau_company(Tableau_company_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_company_temp)
    {   
        Tableau_company = Tableau_company_temp;
    }
    else
    {
        Tableau_company[0]         =  new Array();
        Tableau_company[0]['name'] = 'aucun company';
    }
    affiche_Tableau_company();
}
// requette pour l'obtention du tableau des companys
function get_Tableau_company()
{ 
    var url_php = "/sc_admin_company/index";
    $.getJSON(url_php,[],init_Tableau_company);
}


//------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage de la liste des companys (tableau)
//------------------------------------------------------------------------------------------------------

function filtre_Tableau_company(){
    Tableau_company_filter = Tableau_company;
}

// affichage du tableau des companys
function affiche_Tableau_company(){
    taille_tableau_content  =  20;
    filtre_Tableau_company();
    var current_tableau     =  Tableau_company_filter;
    var strname             =  'company';
    // var stridentificateur   =  new Array('name','project','new_results','résults');
    var stridentificateur   =  new Array('name','name','city','country');
    affiche_Tableau_content(current_tableau, strname, stridentificateur);
}

// affichage des tableau content ('LM_company')
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
	strContent_5 = strname + '_5_' + i;
        var id_lign  = document.getElementById(strContent_lign);
	var id_pair  = document.getElementById(strContent_pair);
        var id_2     = document.getElementById(strContent_2);
        var id_3     = document.getElementById(strContent_3);
        var id_4     = document.getElementById(strContent_4);
	var id_5     = document.getElementById(strContent_5);
        
        if(i_page<taille_Tableau){
            id_lign.className = "largeBoxTable_Company_lign on";
	    if(pair(i)){
		id_pair.className = "largeBoxTable_Company_lign_pair";
	    }else{
		id_pair.className = "largeBoxTable_Company_lign_impair";
	    }
            strtemp_2 = current_tableau[i_page]['company'][stridentificateur[0]];
            strtemp_3 = current_tableau[i_page]['company'][stridentificateur[1]];
            strtemp_4 = current_tableau[i_page]['company'][stridentificateur[2]];
	    strtemp_5 = current_tableau[i_page]['company'][stridentificateur[3]];
            remplacerTexte(id_2, strtemp_2);
            remplacerTexte(id_3, strtemp_3);
            remplacerTexte(id_4, strtemp_4);
	    remplacerTexte(id_5, strtemp_5);
        }else{
            id_lign.className = "largeBoxTable_Company_lign off";
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

// affiche la page num pour la liste des companys
function go_page_company(num){
    if(num=='first'){
        content_tableau_current_page['company'] = 0;
    }else if(num=='end'){
        content_tableau_current_page['company'] = content_tableau_liste_page['company'].length-1;
    }else{
        var num_page = num + content_tableau_curseur_page['company'];
        content_tableau_current_page['company'] = content_tableau_liste_page['company'][num_page]-1;    
    }
    affiche_Tableau_company();
}



-->
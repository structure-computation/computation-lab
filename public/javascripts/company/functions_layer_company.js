<!--
//---------------------------------------------------------------------------------------------------------
// initialisation
//---------------------------------------------------------------------------------------------------------

var Tableau_solde_calcul                   =  new Array();              // tableau du solde calcul
var Tableau_solde_calcul_filter            =  new Array();              // tableau du solde calcul filtres pour l'affichage
var Tableau_facture	                   =  new Array();              // tableau du solde calcul
var Tableau_facture_filter  	           =  new Array();              // tableau du solde calcul filtres pour l'affichage
var Tableau_gestionnaire	           =  new Array();              // tableau du solde calcul
var Company_detail			   =  new Array();              // detail de la company


//initialisation de la taille du tableau pour la box content et de la table de correspondance
var taille_tableau_content          =  20;                       // taille du tableau dans la content box
var content_tableau_connect         =  new Array();              // connectivité entre l'id de l'element graphique (div) et l'élément du tableau affiché dedans  
var content_tableau_current_page    =  new Array();              // numéro de la page du tableau (sert pour la définition de la connectivité)    
var content_tableau_curseur_page    =  new Array();              // nombre de page du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_liste_page      =  new Array();              // liste des pages du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_page            =  new Array('solde_calcul','facture','gestionnaire');    // initialisation des pages avec tableau dynamique
var taille_tableau_content_page     =  new Array()               // taille du tableau dans la content box
taille_tableau_content_page['solde_calcul'] = 10;
taille_tableau_content_page['facture'] = 10;
taille_tableau_content_page['gestionnaire'] = 10;


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

//-----------------------------------------------------------------------------------------------------------
// affichage des contenu a partir de fleches
//-----------------------------------------------------------------------------------------------------------

var bool_affiche_compte_abonnement = false ;

function affich_contenu_compte_abonnement(){
	if(!bool_affiche_compte_abonnement){
		// switch du contenu
		$('#CompteAbonnementContent').slideDown("slow");
		// bouton afficher
		id_fleche_compte_abonnement = document.getElementById('CompteAbonnementFleche');	
		id_fleche_compte_abonnement.className = 'ResumeCompte1Selected';
		bool_affiche_compte_abonnement = true ;
	}
	else if(bool_affiche_compte_abonnement){
		// switch du contenu
		$('#CompteAbonnementContent').slideUp("slow");
		// bouton afficher
		id_fleche_compte_abonnement = document.getElementById('CompteAbonnementFleche');	
		id_fleche_compte_abonnement.className = 'ResumeCompte1';
		bool_affiche_compte_abonnement = false ;
	}
}

var bool_affiche_factures = false ;

function affich_contenu_factures(){
	if(!bool_affiche_factures){
		get_Tableau_facture();
		// switch du contenu
		$('#FactureContent').slideDown("slow");
		// bouton afficher
		id_fleche_compte_abonnement = document.getElementById('FactureFleche');	
		id_fleche_compte_abonnement.className = 'ResumeCompte1Selected';
		bool_affiche_factures = true ;
	}
	else if(bool_affiche_factures){
		// switch du contenu
		$('#FactureContent').slideUp("slow");
		// bouton afficher
		id_fleche_compte_abonnement = document.getElementById('FactureFleche');	
		id_fleche_compte_abonnement.className = 'ResumeCompte1';
		bool_affiche_factures = false ;
	}
}

var bool_affiche_profil_company = false ;

function affich_contenu_profil_company(){
	if(!bool_affiche_profil_company){
		get_Tableau_gestionnaire();
		// switch du contenu
		$('#ProfilCompanyContent').slideDown("slow");
		// bouton afficher
		id_fleche_compte_abonnement = document.getElementById('ProfilCompanyFleche');	
		id_fleche_compte_abonnement.className = 'ResumeCompte1Selected';
		bool_affiche_profil_company = true ;
	}
	else if(bool_affiche_profil_company){
		// switch du contenu
		$('#ProfilCompanyContent').slideUp("slow");
		// bouton afficher
		id_fleche_compte_abonnement = document.getElementById('ProfilCompanyFleche');	
		id_fleche_compte_abonnement.className = 'ResumeCompte1';
		bool_affiche_profil_company = false ;
	}
}

//-----------------------------------------------------------------------------------------------------------
// dans le contenu de la liste des facture
//-----------------------------------------------------------------------------------------------------------

function affich_liste_facture(){
  id_off = document.getElementById('FCDetail');	
  id_off.className = 'CompteContent off';
  id_on = document.getElementById('FCListe');	
  id_on.className = 'CompteContent on';
  
  id_not_selected = document.getElementById('FMDetail');	
  id_not_selected.className = '';
  id_selected = document.getElementById('FMListe');	
  id_selected.className = 'selected';
}

function affich_detail_facture(){
  id_off = document.getElementById('FCListe');	
  id_off.className = 'CompteContent off';
  id_on = document.getElementById('FCDetail');	
  id_on.className = 'CompteContent on';
  
  id_not_selected = document.getElementById('FMListe');	
  id_not_selected.className = '';
  id_selected = document.getElementById('FMDetail');	
  id_selected.className = 'selected';
}



//-----------------------------------------------------------------------------------------------------------
// dans le contenu du profil company
//-----------------------------------------------------------------------------------------------------------

function affich_gestionnaire(){
  id_off = document.getElementById('PCCDetail');	
  id_off.className = 'CompteContent off';
  id_on = document.getElementById('PCCGestinaire');	
  id_on.className = 'CompteContent on';
  
  id_not_selected = document.getElementById('PCMDetail');	
  id_not_selected.className = '';
  id_selected = document.getElementById('PCMGestinaire');	
  id_selected.className = 'selected';
}

function affich_detail_company(){
  get_company_detail();
  id_off = document.getElementById('PCCGestinaire');	
  id_off.className = 'CompteContent off';
  id_on = document.getElementById('PCCDetail');	
  id_on.className = 'CompteContent on';
  
  id_not_selected = document.getElementById('PCMGestinaire');	
  id_not_selected.className = '';
  id_selected = document.getElementById('PCMDetail');	
  id_selected.className = 'selected';
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
    var url_php = "/company/get_facture";
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
    var stridentificateur   =  new Array('created_at','numero','total_calcul','total_memory','total');
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
// fonctions utiles pour l'affichage de la liste des gestionnaires
//------------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage du tableau des user gestionnaires
function init_Tableau_gestionnaire(Tableau_gestionnaire_temp)
{
    //alert($.toJSON(Tableau_gestionnaire_temp));
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_gestionnaire_temp)
    {   
        Tableau_gestionnaire = Tableau_gestionnaire_temp;
    }
    else
    {
        Tableau_gestionnaire[0]         =  new Array();
        Tableau_gestionnaire[0]['user'] = 'aucune entrée';
    }
    affiche_Tableau_gestionnaire();
}
// requette pour l'obtention du tableau des materials
function get_Tableau_gestionnaire()
{ 
    var url_php = "/company/get_gestionnaire";
    $.getJSON(url_php,[],init_Tableau_gestionnaire);
}

// affichage du tableau decompte calcul
function affiche_Tableau_gestionnaire(){
    taille_tableau_content  =  taille_tableau_content_page['gestionnaire'];
    var current_tableau     =  Tableau_gestionnaire;
    var strname             =  'gestionnaire';
    var strnamebdd          =  'user';
    var stridentificateur   =  new Array('date','name','email');
    affiche_Tableau_content(current_tableau, strname, strnamebdd, stridentificateur);
}

// affiche la page num pour le decompte calcul
function go_page_gestionnaire(num){
    if(num=='first'){
        content_tableau_current_page['gestionnaire'] = 0;
    }else if(num=='end'){
        content_tableau_current_page['gestionnaire'] = content_tableau_liste_page['gestionnaire'].length-1;
    }else{
        var num_page = num + content_tableau_curseur_page['gestionnaire'];
        content_tableau_current_page['gestionnaire'] = content_tableau_liste_page['gestionnaire'][num_page]-1;    
    }
    affiche_Tableau_gestionnaire();
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


//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'obtention du detail de la company
//-------------------------------------------------------------------------------------------------
// traitement en fin de requette pour l'obtention du detail
function init_company_detail(company_temp)
{
    if (company_temp)
    {   
        Company_detail = company_temp;
    }
    else
    {
        user_detail         =  new Array();
        user_detail['name'] = 'aucun membre';
    }
    fill_detail_company();
}
// requette pour l'obtention du tableau des membres
function get_company_detail(){ 
    var url_php = "/company/index";
    $.getJSON(url_php,[],init_company_detail);
}

// afficher le détail d'une company
function fill_detail_company(){
    var table_detail = Company_detail['company'];
    for(key in table_detail){
	    var strContent_detail_key = 'company_detail_' + key ;
	    var id_detail_key = document.getElementById(strContent_detail_key);
	    if(id_detail_key != null){
		strContent = new String();
		strContent = table_detail[key];
		remplacerTexte(id_detail_key, strContent);
	    }
    }
}


-->
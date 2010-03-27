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

for(i=0; i<content_tableau_page.length ; i++){
    content_tableau_connect[content_tableau_page[i]] = new Array(taille_tableau_content);
    content_tableau_current_page[content_tableau_page[i]] = 0;
    content_tableau_curseur_page[content_tableau_page[i]] = 0;
    content_tableau_liste_page[content_tableau_page[i]] = [1];
    for(j=0; j<taille_tableau_content ; j++){
        content_tableau_connect[content_tableau_page[i]][j]=j;
    }
}

//-----------------------------------------------------------------------------------------------------------
// affichage des contenu a partir de fleches
//-----------------------------------------------------------------------------------------------------------

var bool_affiche_compte_calcul = false ;

function affich_contenu_compte_calcul(){
	if(!bool_affiche_compte_calcul){
		// switch du contenu
		$('#CompteCalculContent').slideDown("slow");
		// bouton afficher
		id_fleche_compte_calcul = document.getElementById('CompteCalculFleche');	
		id_fleche_compte_calcul.className = 'ResumeCompte1Selected';
		bool_affiche_compte_calcul = true ;
	}
	else if(bool_affiche_compte_calcul){
		// switch du contenu
		$('#CompteCalculContent').slideUp("slow");
		// bouton afficher
		id_fleche_compte_calcul = document.getElementById('CompteCalculFleche');	
		id_fleche_compte_calcul.className = 'ResumeCompte1';
		bool_affiche_compte_calcul = false ;
	}
}

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
  id_off = document.getElementById('PCCGestinaire');	
  id_off.className = 'CompteContent off';
  id_on = document.getElementById('PCCDetail');	
  id_on.className = 'CompteContent on';
  
  id_not_selected = document.getElementById('PCMGestinaire');	
  id_not_selected.className = '';
  id_selected = document.getElementById('PCMDetail');	
  id_selected.className = 'selected';
}


-->
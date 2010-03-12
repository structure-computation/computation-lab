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
// affichage du contenu du compte calcul
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

-->
<!--

//------------------------------------------------------------------------------------------------------------------
// affichage du contenu du compte calcul
//------------------------------------------------------------------------------------------------------------------

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
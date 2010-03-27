<!--
//---------------------------------------------------------------------------------------------------------
// initialisation
//---------------------------------------------------------------------------------------------------------

user_detail  =  new Array();              // initialisation des onfo user

//-----------------------------------------------------------------------------------------------------------
// affichage des contenu a partir de fleches
//-----------------------------------------------------------------------------------------------------------

var bool_affiche_user_detail = false ;

function affich_contenu_profil_user(){
	if(!bool_affiche_user_detail){
		// switch du contenu
		$('#ProfilUserContent').slideDown("slow");
		// bouton afficher
		id_fleche_compte_calcul = document.getElementById('ProfilUserFleche');	
		id_fleche_compte_calcul.className = 'ResumeCompte1Selected';
		bool_affiche_user_detail = true ;
	}
	else if(bool_affiche_user_detail){
		// switch du contenu
		$('#ProfilUserContent').slideUp("slow");
		// bouton afficher
		id_fleche_compte_calcul = document.getElementById('ProfilUserFleche');	
		id_fleche_compte_calcul.className = 'ResumeCompte1';
		bool_affiche_user_detail = false ;
	}
}

//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'obtention du detail du user
//-------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage du tableau des membres
function init_user_detail(user_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (user_temp)
    {   
        user_detail = user_temp;
    }
    else
    {
        user_detail         =  new Array();
        user_detail['name'] = 'aucun membre';
    }
    affich_detail_user();
    affich_contenu_profil_user();
}
// requette pour l'obtention du tableau des membres
function get_user_detail()
{ 
    var url_php = "/accueil/index";
    $.getJSON(url_php,[],init_user_detail);
}

//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage du détail du user
//-------------------------------------------------------------------------------------------------

// afficher le détail d'un membre
function affich_detail_user(){
    var table_detail = user_detail['user'];
    for(key in table_detail){
	    var strContent_detail_key = 'membre_detail_' + key ;
	    var id_detail_key = document.getElementById(strContent_detail_key);
	    if(id_detail_key != null){
		strContent = new String();
		strContent = table_detail[key];
		remplacerTexte(id_detail_key, strContent);
	    }
    }
}

-->
<!--

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


//---------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage du detail du memory account
//---------------------------------------------------------------------------------------------------------

// traitement en fin de requette pour laffichage du memory account
function init_current_memory_account(Current_memory_account_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Current_memory_account_temp)
    {   
        Current_memory_account = Current_memory_account_temp['memory_account'];
    }
    //alert('ok');
    //alert(array2json(Current_company));
    affich_detail_memory_account();
}
// requette pour l'obtention du tableau des resultats
function get_current_memory_account(id_company)
{ 
    var url_php = "/companies/get_memory_account";
    $.getJSON(url_php,{"id_company": id_company},init_current_memory_account);
}



// afficher le détail d'une company
function affich_detail_memory_account(){
    var table_detail = Current_memory_account;
    //afficher le detail d'un model
    for(key in table_detail){
	    var strContent_detail_key = 'memory_account_' + key ;
	    var strContent_info_key = 'memory_account_info_' + key ;
	    var id_detail_key = document.getElementById(strContent_detail_key);
	    var id_info_key = document.getElementById(strContent_info_key);
	    if(id_detail_key != null){
		strContent = new String();
		strContent = table_detail[key];
		remplacerTexte(id_detail_key, strContent);
	    }
	    if(id_info_key != null){
		strContent = new String();
		if(key=='base_jeton'){
			strContent = table_detail[key] + 10;
			
		}else{
			strContent = table_detail[key];
		}
		remplacerTexte(id_info_key, strContent);
	    }
    }
    // affichage de la progress_bar
    var greybar = document.getElementById('memory_account_info_greybar'); 
    var redbar = document.getElementById('memory_account_info_redbar'); 
    
    greybar.className = 'ResumeCompte3GreenBar on';
    redbar.className = 'ResumeCompte3RedBar off';
    
    // taille de la progress_bar
    var progress_bar = document.getElementById('memory_account_progress_bar'); 
    var info_progress_bar = document.getElementById('memory_account_info_progress_bar');
    
    var taille_max= 294;
    var max_memory = Current_memory_account['assigned_memory'] + 1;
    var used_memory = Current_memory_account['used_memory'];
    var taille_actuelle= used_memory * taille_max / max_memory;
    if(taille_actuelle>taille_max){
        // on affiche la barre rouge
	greybar.className = 'ResumeCompte3GreenBar off';
	redbar.className = 'ResumeCompte3RedBar on';
	taille_actuelle=taille_max;
    }
    
    progress_bar.style.width = taille_actuelle + 'px'; 
    info_progress_bar.style.width = taille_actuelle + 'px'; 
    //alert(progress_bar.style.width);
}

//---------------------------------------------------------------------------------------------------------
// fonctions utiles pour la modification du compte
//---------------------------------------------------------------------------------------------------------



function modif_compte_abonnement(){
    alert("Pour toute modification merci de contacter nos conseillers");
}
-->
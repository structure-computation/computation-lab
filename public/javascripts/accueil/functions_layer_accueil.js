<!--
//---------------------------------------------------------------------------------------------------------
// initialisation
//---------------------------------------------------------------------------------------------------------

user_detail  =  new Array();              // initialisation des onfo user
var Tableau_gestionnaire	           =  new Array();              // tableau du solde calcul


//initialisation de la taille du tableau pour la box content et de la table de correspondance
var taille_tableau_content          =  20;                       // taille du tableau dans la content box
var content_tableau_connect         =  new Array();              // connectivité entre l'id de l'element graphique (div) et l'élément du tableau affiché dedans  
var content_tableau_current_page    =  new Array();              // numéro de la page du tableau (sert pour la définition de la connectivité)    
var content_tableau_curseur_page    =  new Array();              // nombre de page du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_liste_page      =  new Array();              // liste des pages du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_page            =  new Array('gestionnaire');    // initialisation des pages avec tableau dynamique
var taille_tableau_content_page     =  new Array()               // taille du tableau dans la content box
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

user_change_detail  =  new Array();              // initialisation des info changement detail user
user_change_mdp     =  new Array();              // initialisation des info changement mdp user

//-----------------------------------------------------------------------------------------------------------
// affichage des contenu a partir de fleches
//-----------------------------------------------------------------------------------------------------------

var bool_affiche_user_detail = false ;

function affich_contenu_profil_user(){
        get_user_detail();
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
//     affich_contenu_profil_user();
}
// requette pour l'obtention du tableau des membres
function get_user_detail()
{ 
    var url_php = "/accueil/index";
    $.getJSON(url_php,[],init_user_detail);
}

// afficher le détail d'un membre
function affich_detail_user(){
    id_detail_user = document.getElementById('Box_detail_user');
    id_change_detail_user = document.getElementById('Box_change_detail_user'); 
    id_change_mdp_user = document.getElementById('Box_change_mdp_user');       
    id_detail_user.className = 'on';
    id_change_detail_user.className = 'off';
    id_change_mdp_user.className = 'off';
    var table_detail = user_detail['user'];
    for(key in table_detail){
	    var strContent_detail_key = 'membre_detail_' + key ;
	    //alert(strContent_detail_key);
	    var id_detail_key = document.getElementById(strContent_detail_key);
	    if(id_detail_key != null){
		strContent = new String();
		strContent = table_detail[key];
		remplacerTexte(id_detail_key, strContent);
	    }
    }
}

// afficher le changement de détail d'un membre
function affich_change_detail_user(){
    user_change_detail = clone(user_detail['user']);
    id_detail_user = document.getElementById('Box_detail_user');
    id_change_detail_user = document.getElementById('Box_change_detail_user'); 
    id_change_mdp_user = document.getElementById('Box_change_mdp_user');       
    id_detail_user.className = 'off';
    id_change_detail_user.className = 'on';
    id_change_mdp_user.className = 'off';
    for(key in user_change_detail){
        var strContent_detail_key = 'membre_detail_change_' + key ;
        //alert(strContent_detail_key);
        var id_detail_key = document.getElementById(strContent_detail_key);
        if(id_detail_key != null){
            strContent = new String();
            strContent = user_change_detail[key];
            remplacerTexte(id_detail_key, strContent);
        }
    }
    for(key in user_change_detail){
        var strContent_detail_key = 'membre_change_' + key ;
        //alert(strContent_detail_key);
        var id_detail_key = document.getElementById(strContent_detail_key);
        if(id_detail_key != null){
            strContent = new String();
            strContent = user_change_detail[key];
            id_detail_key.value = strContent ;
        }
    }
}

//changer les info d'un user
function user_detail_change_value(){
      for(key in user_change_detail){
              var strContent_info_key = 'membre_change_' + key ;
              var id_info_key = document.getElementById(strContent_info_key);
              if(id_info_key != null){
                      user_change_detail[key] = id_info_key.value ;
              }
      }   
}

// valider les changement d'info d'un user
function user_detail_change_valid()
{
//     alert(array2json(Tableau_new_membre));
    var param1 = array2object(user_change_detail);
    $.ajax({
        url: "/accueil/change_detail",
        type: 'POST',
        dataType: 'text',
        data: $.toJSON(param1),
        contentType: 'application/json; charset=utf-8',
        success: function(json) {
            //alert(json);
            get_user_detail();
        }
    });

}


// afficher le changement de mdp d'un membre
function affich_change_mdp_user(){
    user_change_mdp['password'] = '';
    user_change_mdp['new_password'] = '';
    user_change_mdp['password_confirmation'] = '';
    id_detail_user = document.getElementById('Box_detail_user');
    id_change_detail_user = document.getElementById('Box_change_detail_user'); 
    id_change_mdp_user = document.getElementById('Box_change_mdp_user');       
    id_detail_user.className = 'off';
    id_change_detail_user.className = 'off';
    id_change_mdp_user.className = 'on';
    
    for(key in user_change_mdp){
        var strContent_detail_key = 'membre_change_' + key ;
        var id_detail_key = document.getElementById(strContent_detail_key);
        if(id_detail_key != null){
            strContent = new String();
            strContent = user_change_mdp[key];
            id_detail_key.value = strContent ;
        }
    }
}

//changer le mdp du membre
function user_mdp_change_value(){
      for(key in user_change_mdp){
              var strContent_info_key = 'membre_change_' + key ;
              var id_info_key = document.getElementById(strContent_info_key);
              if(id_info_key != null){
                      user_change_mdp[key] = id_info_key.value ;
              }
      }   
}

// valider le changement du mdp du user
function user_mdp_change_valid()
{
    if(user_change_mdp['new_password'] == user_change_mdp['password_confirmation']){
      var param1 = array2object(user_change_mdp);
      $.ajax({
          url: "/accueil/change_mdp",
          type: 'POST',
          dataType: 'text',
          data: $.toJSON(param1),
          contentType: 'application/json; charset=utf-8',
          success: function(json) {
              if(json == 'success'){
                alert("Mot de passe modifié");
                get_user_detail();
              }else{
                alert("Votre mot de passe n'a pas été modifié !");
                affich_change_mdp_user();
              }
          }
      });
    }else{
      alert("Vous n'avez pas taper les deux mêmes valeurs pour votre nouveau mot de passe");
      affich_change_mdp_user();
    }

}



//------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage de la liste des gestionnaires
//------------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage du tableau des user gestionnaires
function init_Tableau_gestionnaire(Tableau_gestionnaire_temp)
{
    //alert(Tableau_solde_calcul_temp);
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






-->
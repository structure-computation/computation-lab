
//-----------------------------------------------------------------------------------------------------------
// affichage des contenu a partir de fleches
//-----------------------------------------------------------------------------------------------------------
var bool_affiche_compte_calcul = false;

function affich_contenu_compte_calcul() {
    if (!bool_affiche_compte_calcul) {
        // switch du contenu
        $('#CompteCalculContent').slideDown("slow");
        // bouton afficher
        id_fleche_compte_calcul = document.getElementById('CompteCalculFleche');
        id_fleche_compte_calcul.className = 'ResumeCompte1Selected';
        bool_affiche_compte_calcul = true;
    }
    else if (bool_affiche_compte_calcul) {
        // switch du contenu
        $('#CompteCalculContent').slideUp("slow");
        // bouton afficher
        id_fleche_compte_calcul = document.getElementById('CompteCalculFleche');
        id_fleche_compte_calcul.className = 'ResumeCompte1';
        bool_affiche_compte_calcul = false;
    }
}


//---------------------------------------------------------------------------------------------------------
// pour l'affichage des différent onglet du compte calcul
//---------------------------------------------------------------------------------------------------------
function compte_calcul_cadres_off() {
    list_str_id = new Array('CCCadreUtilisation', 'CCCadreDescription');
    list_str_menu_id = new Array('CCMUtilisation', 'CCMDescription');
    for (i = 0; i < list_str_id.length; i++) {
        strtemp = list_str_id[i];
        id_off = document.getElementById(strtemp);
        if (id_off != null) {
            id_off.className = 'off';
        }
    }

    for (i = 0; i < list_str_menu_id.length; i++) {
        strtemp = list_str_menu_id[i];
        id_not_selected = document.getElementById(strtemp);
        if (id_not_selected != null) {
            //alert(strtemp);
            id_not_selected.className = '';
        }
    }
}

function compte_calcul_affich_Utilisation() {
    compte_calcul_cadres_off();
    id_on = document.getElementById('CCCadreUtilisation');
    id_on.className = 'on';

    id_selected = document.getElementById('CCMUtilisation');
    id_selected.className = 'selected';
}

function compte_calcul_affich_Description() {
    compte_calcul_cadres_off();
    id_on = document.getElementById('CCCadreDescription');
    id_on.className = 'on';

    id_selected = document.getElementById('CCMDescription');
    id_selected.className = 'selected';
}

//------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage de le solde du compte calcul
//------------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage du tableau des materials
function init_Tableau_solde_calcul(Tableau_solde_calcul_temp)
 {
    //alert(Tableau_solde_calcul_temp);
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_solde_calcul_temp)
    {
        Tableau_solde_calcul = Tableau_solde_calcul_temp;
    }
    else
    {
        Tableau_solde_calcul[0] = new Array();
        Tableau_solde_calcul[0]['solde_type'] = 'aucune entrée';
    }
    affiche_Tableau_solde_calcul();
}

// TODO: Supprimer
// requette pour l'obtention du tableau des materials
// function get_Tableau_solde_calcul()
//  {
//     var url_php = "/companies/get_solde";
//     $.getJSON(url_php, [], init_Tableau_solde_calcul);
// }

function filtre_Tableau_solde_calcul() {
    Tableau_solde_calcul_filter = Tableau_solde_calcul;
}

// affichage du tableau decompte calcul
function affiche_Tableau_solde_calcul() {
    taille_tableau_content = taille_tableau_content_page['solde_calcul'];
    filtre_Tableau_solde_calcul();
    var current_tableau = Tableau_solde_calcul_filter;
    var strname = 'solde_calcul';
    var strnamebdd = 'solde_calcul_account';
    var stridentificateur = new Array('created_at', 'solde_type', 'debit_jeton', 'credit_jeton', 'solde_jeton', 'solde_jeton_tempon');
    affiche_Tableau_content(current_tableau, strname, strnamebdd, stridentificateur);
}

// affiche la page num pour le decompte calcul
function go_page_solde_calcul(num) {
    if (num == 'first') {
        content_tableau_current_page['solde_calcul'] = 0;
    } else if (num == 'end') {
        content_tableau_current_page['solde_calcul'] = content_tableau_liste_page['solde_calcul'].length - 1;
    } else {
        var num_page = num + content_tableau_curseur_page['solde_calcul'];
        content_tableau_current_page['solde_calcul'] = content_tableau_liste_page['solde_calcul'][num_page] - 1;
    }
    affiche_Tableau_solde_calcul();
}


//---------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage de la description du calcul account
//---------------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage de la company
function init_current_calcul_account(Current_calcul_account_temp)
 {
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Current_calcul_account_temp)
    {
        Current_calcul_account = Current_calcul_account_temp['calcul_account'];
    }
    //alert('ok');
    //alert(array2json(Current_company));
    affich_detail_calcul_account();
}






// afficher le détail d'une company
function affich_detail_calcul_account() {
    var table_detail = Current_calcul_account;
    //afficher le detail d'un model
    for (key in table_detail) {
        var strContent_detail_key = 'calcul_account_' + key;
        var strContent_info_key = 'calcul_account_info_' + key;
        var id_detail_key = document.getElementById(strContent_detail_key);
        var id_info_key = document.getElementById(strContent_info_key);
        if (id_detail_key != null) {
            strContent = new String();
            strContent = table_detail[key];
            remplacerTexte(id_detail_key, strContent);
        }
        if (id_info_key != null) {
            strContent = new String();
            if (key == 'base_jeton') {
                strContent = table_detail[key] + table_detail['report_jeton'];

            } else {
                strContent = table_detail[key];
            }
            remplacerTexte(id_info_key, strContent);
        }
    }

    // affichage de la progress_bar
    var greybar = document.getElementById('calcul_account_info_greybar');
    var redbar = document.getElementById('calcul_account_info_redbar');

    greybar.className = 'ResumeCompte3GreenBar on';
    redbar.className = 'ResumeCompte3RedBar off';

    // taille de la progress_bar
    var progress_bar = document.getElementById('calcul_account_progress_bar');
    var info_progress_bar = document.getElementById('calcul_account_info_progress_bar');

    var taille_max = 294;
    var max_jeton = Current_calcul_account['report_jeton'] + Current_calcul_account['base_jeton'] + 1;
    var used_jeton = Current_calcul_account['used_jeton'];
    var taille_actuelle = used_jeton * taille_max / max_jeton;
    if (taille_actuelle > taille_max) {
        // on affiche la barre rouge
        greybar.className = 'ResumeCompte3GreenBar off';
        redbar.className = 'ResumeCompte3RedBar on';
        taille_actuelle = taille_max;
    }

    progress_bar.style.width = taille_actuelle + 'px';
    info_progress_bar.style.width = taille_actuelle + 'px';
    //alert(progress_bar.style.width);
}

//---------------------------------------------------------------------------------------------------------
// fonctions utiles pour la modification du compte
//---------------------------------------------------------------------------------------------------------


function modif_compte_calcul() {
    alert("Pour toute modification merci de contacter nos conseillers");
}


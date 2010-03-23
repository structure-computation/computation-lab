<!--

//------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage de la liste des materials (tableau)
//------------------------------------------------------------------------------------------------------

// affichage du tableau des new_materials
function affiche_Tableau_new_material(){
    taille_tableau_content  =  taille_tableau_content_page['new_material'];
    var current_tableau     =  Tableau_material_new_list;
    var strname             =  'new_material';
    var stridentificateur   =  new Array('elastique','plastique','endomageable','visqueux');
    affiche_Tableau_new(current_tableau, strname, stridentificateur);
    select_new_material(0);
}

// affichage des tableau content ('LM_material')
function affiche_Tableau_new(current_tableau, strname, stridentificateur){
    //var taille_Tableau=current_tableau.length;
    var taille_Tableau=2;
    //alert(taille_tableau_content);
    for(i=0; i<taille_tableau_content; i++) {
        i_page = i + content_tableau_current_page[strname] * taille_tableau_content;
	//alert(i_page);
        content_tableau_connect[strname][i]=i_page;
        
        strContent_lign = strname + '_lign_' + i;
	strContent_pair = strname + '_pair_' + i;
	strContent_num = strname + '_num_' + i;
        strContent_type = strname + '_type_' + i;
        strContent_elastique = strname + '_elastique_' + i;
        strContent_plastique = strname + '_plastique_' + i;
	strContent_endomageable = strname + '_endomageable_' + i;
	strContent_visqueux = strname + '_visqueux_' + i;
        var id_lign  = document.getElementById(strContent_lign);
	var id_pair  = document.getElementById(strContent_pair);
	var id_num     = document.getElementById(strContent_num);
        var id_type     = document.getElementById(strContent_type);
        var id_elastique     = document.getElementById(strContent_elastique);
        var id_plastique     = document.getElementById(strContent_plastique);
	var id_endomageable     = document.getElementById(strContent_endomageable);
	var id_visqueux     = document.getElementById(strContent_visqueux);
        
        if(i_page<taille_Tableau){
            id_lign.className = "newBoxTable_Material_lign on";
	    if(pair(i)){
		id_pair.className = "newBoxTable_Material_lign_pair";
	    }else{
		id_pair.className = "newBoxTable_Material_lign_impair";
	    }
	    strtemp_num = current_tableau[i_page]['type_num'];
            remplacerTexte(id_num, strtemp_num);
            strtemp_type = current_tableau[i_page]['mtype'];
            remplacerTexte(id_type, strtemp_type);
            //elastique
	    if(current_tableau[i_page]['comp'].match('el')){
		    id_elastique.className = "NC_box_check_prop actif";
	    }else{ 
		    id_elastique.className = "NC_box_check_prop";
	    }
	    //plastique
	    if(current_tableau[i_page]['comp'].match('pl')){
		    id_plastique.className = "NC_box_check_prop actif";
	    }else{ 
		    id_plastique.className = "NC_box_check_prop";
	    }
	    //endomageable
	    if(current_tableau[i_page]['comp'].match('en')){
		    id_endomageable.className = "NC_box_check_prop actif";
	    }else{ 
		    id_endomageable.className = "NC_box_check_prop";
	    }
	    //visqueux	
	    if(current_tableau[i_page]['comp'].match('vi')){
		    id_visqueux.className = "NC_box_check_prop actif";
	    }else{ 
		    id_visqueux.className = "NC_box_check_prop";
	    }	
	    
        }else{
            id_lign.className = "newBoxTable_Material_lign off";
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

// affiche la page num pour la liste des materials
function go_page_new_material(num){
    if(num=='first'){
        content_tableau_current_page['new_material'] = 0;
    }else if(num=='end'){
        content_tableau_current_page['new_material'] = content_tableau_liste_page['new_material'].length-1;
    }else{
        var num_page = num + content_tableau_curseur_page['new_material'];
        content_tableau_current_page['new_material'] = content_tableau_liste_page['new_material'][num_page]-1;    
    }
    affiche_Tableau_new_material();
}

// selectionner (activer) un matériaux de la liste pour creer un nouveau materiaux
function select_new_material(num){
	var new_mat_select = content_tableau_connect['new_material'][num];
	Tableau_material_new = Tableau_material_new_list[new_mat_select];
	for(i=0; i<taille_tableau_content_page['new_material'] ;i++){
		strContent_check = 'new_material_check_' + i;
		id_check = document.getElementById(strContent_check);
		if(i==new_mat_select){
			id_check.checked=true;
		}else{
			id_check.checked=false;
		}
	}
}


//------------------------------------------------------------------------------------------------------
// liste des matériaux disponnibles
//------------------------------------------------------------------------------------------------------


var Tableau_material_new_list              =  new Array();              // tableau des nouveaux materials

// initialisation d'un matériaux elastique isotrope numero 1
Tableau_material_new_list[0]               =  new Array();
Tableau_material_new_list[0]["name"]='Nouveau matériaux';
Tableau_material_new_list[0]["familly"]='métaux';
//Tableau_material_new_list_list[1]["user_id"]='Nouveau matériaux';
Tableau_material_new_list[0]["project_id"]=-1;
Tableau_material_new_list[0]["reference"]=-1;
Tableau_material_new_list[0]["id_select"]=-1;
Tableau_material_new_list[0]["name_select"]='';
Tableau_material_new_list[0]["description"]='description';
Tableau_material_new_list[0]["mtype"]='isotrope';
Tableau_material_new_list[0]["comp"]='el';
Tableau_material_new_list[0]["type_num"]=0;
Tableau_material_new_list[0]["dir_1_x"]=1;
Tableau_material_new_list[0]["dir_2_x"]=0;
Tableau_material_new_list[0]["dir_3_x"]=0;
Tableau_material_new_list[0]["dir_1_y"]=0;
Tableau_material_new_list[0]["dir_2_y"]=1;
Tableau_material_new_list[0]["dir_3_y"]=0;
Tableau_material_new_list[0]["dir_1_z"]=0;
Tableau_material_new_list[0]["dir_2_z"]=0;
Tableau_material_new_list[0]["dir_3_z"]=1;
Tableau_material_new_list[0]["E_1"]=200e9;
Tableau_material_new_list[0]["E_2"]=200e9;
Tableau_material_new_list[0]["E_3"]=200e9;
Tableau_material_new_list[0]["cis_1"]=0;
Tableau_material_new_list[0]["cis_2"]=0;
Tableau_material_new_list[0]["cis_3"]=0;
Tableau_material_new_list[0]["mu_12"]=0.3;
Tableau_material_new_list[0]["mu_23"]=0.3;
Tableau_material_new_list[0]["mu_31"]=0.3;
Tableau_material_new_list[0]["alpha_1"]=0;
Tableau_material_new_list[0]["alpha_2"]=0;
Tableau_material_new_list[0]["alpha_3"]=0;
Tableau_material_new_list[0]["rho"]=2e3;
Tableau_material_new_list[0]["sigma_p_1"]=200e6;
Tableau_material_new_list[0]["sigma_p_2"]=200e6;
Tableau_material_new_list[0]["sigma_p_3"]=200e6;
Tableau_material_new_list[0]["sigma_r_1"]=300e6;
Tableau_material_new_list[0]["sigma_r_2"]=300e6;
Tableau_material_new_list[0]["sigma_r_3"]=300e6;
Tableau_material_new_list[0]["sigma_e_1"]=200e6;
Tableau_material_new_list[0]["sigma_e_2"]=200e6;
Tableau_material_new_list[0]["sigma_e_3"]=200e6;
Tableau_material_new_list[0]["dp_1"]=200e6;
Tableau_material_new_list[0]["dp_2"]=200e6;
Tableau_material_new_list[0]["dp_3"]=200e6;
Tableau_material_new_list[0]["p_1"]=200e6;
Tableau_material_new_list[0]["p_2"]=200e6;
Tableau_material_new_list[0]["p_3"]=200e6;
Tableau_material_new_list[0]["ed_1"]=200e6;
Tableau_material_new_list[0]["ed_2"]=200e6;
Tableau_material_new_list[0]["ed_3"]=200e6;


// initialisation d'un matériaux elastique orthotrope numero 2
Tableau_material_new_list[1]               =  new Array();
Tableau_material_new_list[1]["name"]='Nouveau matériaux';
Tableau_material_new_list[1]["familly"]='métaux';
//Tableau_material_new_list[1]["user_id"]='Nouveau matériaux';
Tableau_material_new_list[1]["project_id"]=-1;
Tableau_material_new_list[1]["reference"]=-1;
Tableau_material_new_list[1]["id_select"]=-1;
Tableau_material_new_list[1]["name_select"]='';
Tableau_material_new_list[1]["description"]='description';
Tableau_material_new_list[1]["mtype"]='orthotrope';
Tableau_material_new_list[1]["comp"]='el pl en';
Tableau_material_new_list[1]["type_num"]=1;
Tableau_material_new_list[1]["dir_1_x"]=1;
Tableau_material_new_list[1]["dir_2_x"]=0;
Tableau_material_new_list[1]["dir_3_x"]=0;
Tableau_material_new_list[1]["dir_1_y"]=0;
Tableau_material_new_list[1]["dir_2_y"]=1;
Tableau_material_new_list[1]["dir_3_y"]=0;
Tableau_material_new_list[1]["dir_1_z"]=0;
Tableau_material_new_list[1]["dir_2_z"]=0;
Tableau_material_new_list[1]["dir_3_z"]=1;
Tableau_material_new_list[1]["E_1"]=200e9;
Tableau_material_new_list[1]["E_2"]=200e9;
Tableau_material_new_list[1]["E_3"]=200e9;
Tableau_material_new_list[1]["cis_1"]=0;
Tableau_material_new_list[1]["cis_2"]=0;
Tableau_material_new_list[1]["cis_3"]=0;
Tableau_material_new_list[1]["mu_12"]=0.3;
Tableau_material_new_list[1]["mu_23"]=0.3;
Tableau_material_new_list[1]["mu_31"]=0.3;
Tableau_material_new_list[1]["alpha_1"]=0;
Tableau_material_new_list[1]["alpha_2"]=0;
Tableau_material_new_list[1]["alpha_3"]=0;
Tableau_material_new_list[1]["rho"]=2e3;
Tableau_material_new_list[1]["sigma_p_1"]=200e6;
Tableau_material_new_list[1]["sigma_p_2"]=200e6;
Tableau_material_new_list[1]["sigma_p_3"]=200e6;
Tableau_material_new_list[1]["sigma_r_1"]=300e6;
Tableau_material_new_list[1]["sigma_r_2"]=300e6;
Tableau_material_new_list[1]["sigma_r_3"]=300e6;
Tableau_material_new_list[1]["sigma_e_1"]=200e6;
Tableau_material_new_list[1]["sigma_e_2"]=200e6;
Tableau_material_new_list[1]["sigma_e_3"]=200e6;
Tableau_material_new_list[1]["dp_1"]=200e6;
Tableau_material_new_list[1]["dp_2"]=200e6;
Tableau_material_new_list[1]["dp_3"]=200e6;
Tableau_material_new_list[1]["p_1"]=200e6;
Tableau_material_new_list[1]["p_2"]=200e6;
Tableau_material_new_list[1]["p_3"]=200e6;
Tableau_material_new_list[1]["ed_1"]=200e6;
Tableau_material_new_list[1]["ed_2"]=200e6;
Tableau_material_new_list[1]["ed_3"]=200e6;

Tableau_material_new = Tableau_material_new_list[0];
-->
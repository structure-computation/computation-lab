<!--

//------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage de la liste des materials (tableau)
//------------------------------------------------------------------------------------------------------

// affichage du tableau des new_materials
function affiche_Tableau_new_link(){
    taille_tableau_content  =  taille_tableau_content_page['new_link'];
    var current_tableau     =  Tableau_link_new_list;
    var strname             =  'new_link';
    var stridentificateur   =  new Array('parfaite','elastique','contact','plastique','cassable');
    affiche_Tableau_new(current_tableau, strname, stridentificateur);
    select_new_link(0);
}

// affichage des tableau content ('LM_link')
function affiche_Tableau_new(current_tableau, strname, stridentificateur){
    var taille_Tableau=current_tableau.length;
    //var taille_Tableau=2;
    //alert(taille_tableau_content);
    for(i=0; i<taille_tableau_content; i++) {
        i_page = i + content_tableau_current_page[strname] * taille_tableau_content;
	//alert(i_page);
        content_tableau_connect[strname][i]=i_page;
        
        strContent_lign = strname + '_lign_' + i;
	strContent_pair = strname + '_pair_' + i;
	strContent_num = strname + '_num_' + i;
        strContent_parfaite = strname + '_parfaite_' + i;
        strContent_elastique = strname + '_elastique_' + i;
	strContent_contact = strname + '_contact_' + i;
        strContent_plastique = strname + '_plastique_' + i;
	strContent_cassable = strname + '_cassable_' + i;
        var id_lign  = document.getElementById(strContent_lign);
	var id_pair  = document.getElementById(strContent_pair);
	var id_num     = document.getElementById(strContent_num);
        var id_parfaite     = document.getElementById(strContent_parfaite);
        var id_elastique     = document.getElementById(strContent_elastique);
	var id_contact     = document.getElementById(strContent_contact);
        var id_plastique     = document.getElementById(strContent_plastique);
	var id_cassable     = document.getElementById(strContent_cassable);
        
        if(i_page<taille_Tableau){
            id_lign.className = "newBoxTable_lign on";
	    if(pair(i)){
		id_pair.className = "newBoxTable_lign_pair";
	    }else{
		id_pair.className = "newBoxTable_lign_impair";
	    }
	    strtemp_num = current_tableau[i_page]['type_num'];
            remplacerTexte(id_num, strtemp_num);
	    // comportement générique
	    if(current_tableau[i_page]['comp_generique'].match('Pa')) {
		    id_parfaite.className = "NC_box_radio_prop actif";
		    id_elastique.className = "NC_box_radio_prop";
		    id_contact.className = "NC_box_radio_prop";
	    }else if(current_tableau[i_page]['comp_generique'].match('El')) {
		    id_parfaite.className = "NC_box_radio_prop";
		    id_elastique.className = "NC_box_radio_prop actif";
		    id_contact.className = "NC_box_radio_prop";  
	    }else if(current_tableau[i_page]['comp_generique'].match('Co')) {
		    id_parfaite.className = "NC_box_radio_prop";
		    id_elastique.className = "NC_box_radio_prop";
		    id_contact.className = "NC_box_radio_prop actif";
	    }
            //comportement complexe plastique
	    if(current_tableau[i_page]['comp_complexe'].match('Pl')){
		    id_plastique.className = "NC_box_check_prop actif";
	    }else{ 
		    id_plastique.className = "NC_box_check_prop";
	    }
	    //comportement complexe cassable
	    if(current_tableau[i_page]['comp_complexe'].match('Ca')){
		    id_cassable.className = "NC_box_check_prop actif";
	    }else{ 
		    id_cassable.className = "NC_box_check_prop";
	    }   
        }else{
            id_lign.className = "newBoxTable_lign off";
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

// affiche la page num pour la liste des links
function go_page_new_link(num){
    if(num=='first'){
        content_tableau_current_page['new_link'] = 0;
    }else if(num=='end'){
        content_tableau_current_page['new_link'] = content_tableau_liste_page['new_link'].length-1;
    }else{
        var num_page = num + content_tableau_curseur_page['new_link'];
        content_tableau_current_page['new_link'] = content_tableau_liste_page['new_link'][num_page]-1;    
    }
    affiche_Tableau_new_link();
}

// selectionner (activer) une liaison de la liste pour creer un nouvelle liaison
function select_new_link(num){
	var new_link_select = content_tableau_connect['new_link'][num];
	Tableau_link_new = clone(Tableau_link_new_list[new_link_select]);
	for(i=0; i<taille_tableau_content_page['new_link'] ;i++){
		strContent_check = 'new_link_check_' + i;
		id_check = document.getElementById(strContent_check);
		if(i==new_link_select){
			id_check.checked=true;
		}else{
			id_check.checked=false;
		}
	}
}


//------------------------------------------------------------------------------------------------------
// liste des liaisons disponnibles
//------------------------------------------------------------------------------------------------------


var Tableau_link_new_list              =  new Array();              // tableau des nouveaux links

// initialisation d'une liaison parfaite numero 0
Tableau_link_new_list[0]               =  new Array();
Tableau_link_new_list[0]["name"]='Nouvelle liaison';
Tableau_link_new_list[0]["familly"]='soudure';
//Tableau_link_new_list[0]["user_id"
Tableau_link_new_list[0]["project_id"]=-1;
Tableau_link_new_list[0]["reference"]=-1;
Tableau_link_new_list[0]["id_select"]=-1;
Tableau_link_new_list[0]["name_select"]='';
Tableau_link_new_list[0]["description"]='description';
Tableau_link_new_list[0]["comp_generique"]='Pa';
Tableau_link_new_list[0]["comp_complexe"]='';
Tableau_link_new_list[0]["type_num"]=0;
Tableau_link_new_list[0]["Ep"]=0;
Tableau_link_new_list[0]["jeux"]=0;
Tableau_link_new_list[0]["R"]=200000;
Tableau_link_new_list[0]["f"]=0,3;
Tableau_link_new_list[0]["Lp"]=200000;
Tableau_link_new_list[0]["Dp"]=0;
Tableau_link_new_list[0]["p"]=0;
Tableau_link_new_list[0]["Lr"]=300000;

// initialisation d'une liaison élastique numero 1
Tableau_link_new_list[1]               =  new Array();
Tableau_link_new_list[1]["name"]='Nouvelle liaison';
Tableau_link_new_list[1]["familly"]='soudure';
//Tableau_link_new_list[0]["user_id"
Tableau_link_new_list[1]["project_id"]=-1;
Tableau_link_new_list[1]["reference"]=-1;
Tableau_link_new_list[1]["id_select"]=-1;
Tableau_link_new_list[1]["name_select"]='';
Tableau_link_new_list[1]["description"]='description';
Tableau_link_new_list[1]["comp_generique"]='El';
Tableau_link_new_list[1]["comp_complexe"]='';
Tableau_link_new_list[1]["type_num"]=1;
Tableau_link_new_list[1]["Ep"]=0;
Tableau_link_new_list[1]["jeux"]=0;
Tableau_link_new_list[1]["R"]=200000;
Tableau_link_new_list[1]["f"]=0,3;
Tableau_link_new_list[1]["Lp"]=200000;
Tableau_link_new_list[1]["Dp"]=0;
Tableau_link_new_list[1]["p"]=0;
Tableau_link_new_list[1]["Lr"]=300000;

// initialisation d'une liaison contact numero 1
Tableau_link_new_list[2]               =  new Array();
Tableau_link_new_list[2]["name"]='Nouvelle liaison';
Tableau_link_new_list[2]["familly"]='soudure';
//Tableau_link_new_list[0]["user_id"
Tableau_link_new_list[2]["project_id"]=-1;
Tableau_link_new_list[2]["reference"]=-1;
Tableau_link_new_list[2]["id_select"]=-1;
Tableau_link_new_list[2]["name_select"]='';
Tableau_link_new_list[2]["description"]='description';
Tableau_link_new_list[2]["comp_generique"]='Co';
Tableau_link_new_list[2]["comp_complexe"]='';
Tableau_link_new_list[2]["type_num"]=2;
Tableau_link_new_list[2]["Ep"]=0;
Tableau_link_new_list[2]["jeux"]=0;
Tableau_link_new_list[2]["R"]=200000;
Tableau_link_new_list[2]["f"]=0,3;
Tableau_link_new_list[2]["Lp"]=200000;
Tableau_link_new_list[2]["Dp"]=0;
Tableau_link_new_list[2]["p"]=0;
Tableau_link_new_list[2]["Lr"]=300000;


// initialisation d'une liaison parfaite numero 0
Tableau_link_new_list[3]               =  new Array();
Tableau_link_new_list[3]["name"]='Nouvelle liaison';
Tableau_link_new_list[3]["familly"]='soudure';
//Tableau_link_new_list[3]["user_id"
Tableau_link_new_list[3]["project_id"]=-1;
Tableau_link_new_list[3]["reference"]=-1;
Tableau_link_new_list[3]["id_select"]=-1;
Tableau_link_new_list[3]["name_select"]='';
Tableau_link_new_list[3]["description"]='description';
Tableau_link_new_list[3]["comp_generique"]='Pa';
Tableau_link_new_list[3]["comp_complexe"]='Ca';
Tableau_link_new_list[3]["type_num"]=3;
Tableau_link_new_list[3]["Ep"]=0;
Tableau_link_new_list[3]["jeux"]=0;
Tableau_link_new_list[3]["R"]=200000;
Tableau_link_new_list[3]["f"]=0,3;
Tableau_link_new_list[3]["Lp"]=200000;
Tableau_link_new_list[3]["Dp"]=0;
Tableau_link_new_list[3]["p"]=0;
Tableau_link_new_list[3]["Lr"]=300000;

// initialisation d'une liaison élastique numero 1
Tableau_link_new_list[4]               =  new Array();
Tableau_link_new_list[4]["name"]='Nouvelle liaison';
Tableau_link_new_list[4]["familly"]='soudure';
//Tableau_link_new_list[0]["user_id"
Tableau_link_new_list[4]["project_id"]=-1;
Tableau_link_new_list[4]["reference"]=-1;
Tableau_link_new_list[4]["id_select"]=-1;
Tableau_link_new_list[4]["name_select"]='';
Tableau_link_new_list[4]["description"]='description';
Tableau_link_new_list[4]["comp_generique"]='El';
Tableau_link_new_list[4]["comp_complexe"]='Ca';
Tableau_link_new_list[4]["type_num"]=4;
Tableau_link_new_list[4]["Ep"]=0;
Tableau_link_new_list[4]["jeux"]=0;
Tableau_link_new_list[4]["R"]=200000;
Tableau_link_new_list[4]["f"]=0,3;
Tableau_link_new_list[4]["Lp"]=200000;
Tableau_link_new_list[4]["Dp"]=0;
Tableau_link_new_list[4]["p"]=0;
Tableau_link_new_list[4]["Lr"]=300000;

// initialisation d'une liaison contact numero 1
Tableau_link_new_list[5]               =  new Array();
Tableau_link_new_list[5]["name"]='Nouvelle liaison';
Tableau_link_new_list[5]["familly"]='soudure';
//Tableau_link_new_list[0]["user_id"
Tableau_link_new_list[5]["project_id"]=-1;
Tableau_link_new_list[5]["reference"]=-1;
Tableau_link_new_list[5]["id_select"]=-1;
Tableau_link_new_list[5]["name_select"]='';
Tableau_link_new_list[5]["description"]='description';
Tableau_link_new_list[5]["comp_generique"]='Pa';
Tableau_link_new_list[5]["comp_complexe"]='Pl Ca';
Tableau_link_new_list[5]["type_num"]=5;
Tableau_link_new_list[5]["Ep"]=0;
Tableau_link_new_list[5]["jeux"]=0;
Tableau_link_new_list[5]["R"]=200000;
Tableau_link_new_list[5]["f"]=0,3;
Tableau_link_new_list[5]["Lp"]=200000;
Tableau_link_new_list[5]["Dp"]=0;
Tableau_link_new_list[5]["p"]=0;
Tableau_link_new_list[5]["Lr"]=300000;


Tableau_link_new = Tableau_link_new_list[0];
-->
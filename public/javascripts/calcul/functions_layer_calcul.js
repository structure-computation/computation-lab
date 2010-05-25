<!--
//------------------------------------------------------------------------------------------------------
// fonctions génériques
//------------------------------------------------------------------------------------------------------

function clone(myArray){
    var newArray = new Array();
    for (var property in myArray){
        newArray[property] = typeof (myArray[property]) == 'object' || typeof (myArray[property]) == 'Array' ? clone(myArray[property]) : myArray[property]
    } 
    return newArray
}


function pair(nombre)
{
   return ((nombre-1)%2);
}

// convertir une array en json string
function array2json(arr) {
    var parts = [];
    var is_list = (Object.prototype.toString.apply(arr) === '[object Array]');
    var virgule ='on';

    for(var key in arr) {
    	//if(key!='clone'){
	    	var value = arr[key];
	        if(typeof value == "object") { //Custom handling for arrays
		    var str = "";
		    //if(!is_list) 
		    str =  key ;
		    parts.push(str);
		    virgule ='off';
	            if(is_list) parts.push(array2json(value)); /* :RECURSION: */
	            else parts[key] = array2json(value); /* :RECURSION: */
	            //else parts.push('"' + key + '":' + returnedVal);
	        } else {
	        	if(typeof value != "function"){
		            var str = "";
		            //if(!is_list) 
		             str =  '\''+key + '\':';
		
		            //Custom handling for multiple data types
		            if(typeof value == "number") str += value; //Numbers
		            else if(value === false) str += 'false'; //The booleans
		            else if(value === true) str += 'true';
		            else str +=  '\''+value+'\'' ; //All other things
		            // :TODO: Is there any more datatype we should be in the lookout for? (Functions?)
	            	parts.push(str);
	        	}
	        }
    	//}
    }
    if(virgule =='on'){
      var json = parts.join(", ");
      return '[' + json + ']';//Return numerical JSON
    }
    else if(virgule =='off'){
      var json = parts.join("");
      return '[' + json + ']';//Return associative JSON
    }
    
    //if(is_list) return '{' + json + '}';//Return numerical JSON
    //return '{' + json + '}';//Return associative JSON
}
function array2object(array){
    var object = new Object();
    for(var key in array) {
	var value = array[key];
	if(typeof value == "Array" || typeof value == "object") { //Custom handling for arrays
            object[key] = array2object(value);
        } else {
            object[key] = value;
        }
    }
    return object;
}

//----------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des cache noir et des wizard
//----------------------------------------------------------------------------------------------------------

function displayBlack(interupteur) {
    var arrLinkId    = new Array('bl_1');
    var intNbLinkElt = new Number(arrLinkId.length);
    var strContent   = new String();

    for (i=0; i<intNbLinkElt; i++) {
        strContent = arrLinkId[i];
        if ( interupteur == "on" ) {
            id_black = document.getElementById(strContent);
	    if(id_black != null){
		    id_black.className = "black on";
	    }
        }
        if ( interupteur == "off" ) {
	    id_black = document.getElementById(strContent);
	    if(id_black != null){
		    id_black.className = "black off";
	    }
        }
    }   
}
// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des différentes pages :
// ('page_initialisation', 'page_materiaux', 'page_liaisons', 'page_CL', 'page_options', 'page_multiresolution', 'page_previsions')
// -------------------------------------------------------------------------------------------------------------------------------------------

function next_stape(){
	if(NC_current_page == 'page_options'){
		if (NC_current_step < 6){
			 NC_current_step = 6;
		}
		affiche_NC_page_previsions();
	}
	else if(NC_current_page == 'page_CLs'){
		if (NC_current_step < 5){
			 NC_current_step = 5;
		}
		affiche_NC_page_options();
	}
	else if(NC_current_page == 'page_liaisons'){
		if (NC_current_step < 4){
			 NC_current_step = 4;
		}
		affiche_NC_page_CLs();
	}
	else if(NC_current_page == 'page_materiaux'){
		if (NC_current_step < 3){
			 NC_current_step = 3;
		}
		affiche_NC_page_liaisons();
	}
	else if(NC_current_page == 'page_initialisation'){
		if (NC_current_step < 2){
			 NC_current_step = 2;
			 get_new_calculresult(model_id);
		}
		affiche_NC_page_materiaux();
	}
}
function previous_stape(){
	if(NC_current_page == 'page_materiaux'){
		affiche_NC_page_initialisation();
	}
	else if(NC_current_page == 'page_liaisons'){
		affiche_NC_page_materiaux();
	}
	else if(NC_current_page == 'page_CLs'){
		affiche_NC_page_liaisons();
	}
	else if(NC_current_page == 'page_options'){
		affiche_NC_page_CLs();
	}
	else if(NC_current_page == 'page_previsions'){
		affiche_NC_page_options();
	}
}



// afficher une page et cacher les autres
function affiche_NC_page(scrollbar_state,box_prop_state){
	// scroll bar
	id_scroll = document.getElementById('NC_contentscrollbar');	
	id_scroll.className = scrollbar_state;
	// box propriete
	id_box_prop = document.getElementById('NC_box_prop');	
	id_box_prop.className = box_prop_state;
	current_box_prop_state = box_prop_state;
	
	var affiche_on = NC_current_page;
	//var affiche_off = new Array('page_initialisation', 'page_materiaux', 'page_liaisons', 'page_CLs', 'page_options', 'page_multiresolution', 'page_previsions');
	var affiche_off = new Array('page_initialisation', 'page_materiaux', 'page_liaisons', 'page_CLs', 'page_options', 'page_previsions');
	var taille_off = new Number(affiche_off.length);
	// var taille_off = 1;
	
	// on cache tout
	for(i_off=0; i_off<taille_off; i_off++){
		if(i_off < NC_current_step) {
			var className = "actif";
		}else{
			var className = "";
		}
		strContent_PB_page = 'NC_PB_' + affiche_off[i_off] ;
		var id_PB_page = document.getElementById(strContent_PB_page);
		id_PB_page.className = className ;
	}
	
	var taille_off = 6;
	for(i_off=0; i_off<taille_off; i_off++){
		for(i=0; i<3; i++) {
			strContent_page = new String();
			strContent_page = 'NC_' + affiche_off[i_off] + '_' + i ;
			strContent_page_active = new String();
			strContent_page_active = 'NC_' + affiche_off[i_off] + '_active_' + i ;
						var id_page = document.getElementById(strContent_page);
			if(id_page!=null){
				id_page.className = "off";
			}
			var id_page_active = document.getElementById(strContent_page_active);
			if(id_page_active!=null){
				id_page_active.className = "off";
			}
		}
	}
	// on affiche les éléments de la bonne page
	strContent_PB_page = 'NC_PB_' + affiche_on ;
	var id_PB_page = document.getElementById(strContent_PB_page);
	id_PB_page.className = "select";
	for(i=0; i<10; i++) {
		strContent_page = new String();
		strContent_page = 'NC_' + affiche_on + '_' + i ;
		strContent_page_active = new String();
		strContent_page_active = 'NC_' + affiche_on + '_active_' + i ;
		if(id_page = document.getElementById(strContent_page)){
			id_page.className = "on";
		}
		if(id_page_active = document.getElementById(strContent_page_active)){
			id_page_active.className = "on";
		}
	}
	//affich_prop_visu('visu');
	//equal_height_NC_fake();	
}

// switch de l'affichage entre la box visu et la box propriete
function affich_prop_visu_state(){
	if(NC_current_prop_visu=='visu') affich_prop_visu('prop');
	else if(NC_current_prop_visu=='prop') affich_prop_visu('visu');
}

// switch de l'affichage entre la box visu et la box propriete
function affich_prop_visu(affich_box){
	NC_current_prop_visu = affich_box;
	if(affich_box=='visu'){
		// switch du contenu
		$('#NC_content_box_visu').slideDown("slow",equal_height_NC_fake);
		$('#NC_content_box_prop').slideUp("slow",equal_height_NC_fake);
		// bouton afficher
		id_top_box_prop_3_visu = document.getElementById('NC_top_box_visu_3');	
		id_top_box_prop_3_visu.className = 'NC_triangle_bas';
		id_top_box_visu_3_prop = document.getElementById('NC_top_box_prop_3');	
		id_top_box_visu_3_prop.className = 'NC_triangle_cote';
	}
	if(affich_box=='prop'){
		// switch du contenu
		$('#NC_content_box_prop').slideDown("slow",equal_height_NC_fake);
		$('#NC_content_box_visu').slideUp("slow",equal_height_NC_fake);
		// bouton afficher
		id_top_box_prop_3_visu = document.getElementById('NC_top_box_visu_3');	
		id_top_box_prop_3_visu.className = 'NC_triangle_cote';
		id_top_box_visu_3_prop = document.getElementById('NC_top_box_prop_3');	
		id_top_box_visu_3_prop.className = 'NC_triangle_bas';
	}
}


// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions permettant l'affichage des tableau dans les colone droite, gauche, et les twin box de la partie active  
// -------------------------------------------------------------------------------------------------------------------------------------------

// affichage des tableau left ('calcul', 'mat', 'liaison', 'CL')
function affiche_Tableau_left(current_tableau,strname,stridentificateur){
	var taille_Tableau=current_tableau.length;
	for(i=0; i<taille_tableau_left; i++) {
		i_page = i + left_tableau_current_page[strname] * taille_tableau_left;
		left_tableau_connect[strname][i]=i_page;
		strContent_pair = strname + '_pair_' + i;
		strContent_1 = strname + '_1_' + i;
		strContent_1a = strname + '_1a_' + i;
		strContent_11 = strname + '_11_' + i;
		strContent_12 = strname + '_12_' + i;
		strContent_14 = strname + '_14_' + i;
		var id_pair  = document.getElementById(strContent_pair);
		var id_1 = document.getElementById(strContent_1);
		var id_1a = document.getElementById(strContent_1a);
		var id_11 = document.getElementById(strContent_11);
		var id_12 = document.getElementById(strContent_12);
		var id_14 = document.getElementById(strContent_14);
		id_1.className = "tableNC_box_0 off";
		if(i_page<taille_Tableau){
			if(strname=='CLv'){
				id_1.className = "tableNC_box_0_CLv";
			}else{
				id_1.className = "tableNC_box_0 on";
				if(pair(i)){
				    id_pair.className = "tableNC_pair";
				}else{
				    id_pair.className = "tableNC_impair";
				}
			}
			if(strname=='CL' || strname=='CLv'){	
				id_11.className = "tableNC_box_1 CL_" + current_tableau[i]['type_picto'];
			}else{
				id_11.className = "tableNC_box_1 "+strname;
			}
			id_14.className = "tableNC_box_4";
			strtemp = new String();
			strtemp = current_tableau[i_page][stridentificateur];
			remplacerTexte(id_12, strtemp);
		}
	}
	// pour l'affichage des page en bas de la boite
	if(strname=='CL' || strname=='CLv'){
	}else{
		var nb_page = Math.floor(taille_Tableau/taille_tableau_left)+1;
		if(nb_page < 5){
			left_tableau_curseur_page[strname] = 0;
		}else{
			if(left_tableau_current_page[strname] >= nb_page-3){
				left_tableau_curseur_page[strname] = nb_page-5;
			}else if(left_tableau_current_page[strname] < 3){
				left_tableau_curseur_page[strname] = 0;
			}else{
				left_tableau_curseur_page[strname] = left_tableau_current_page[strname]-2;
			}
		}
		left_tableau_liste_page[strname] = new Array();
		for(i=0; i<nb_page; i++) {
			left_tableau_liste_page[strname][i] = i+1;
		}
		for(i=left_tableau_curseur_page[strname]; i<left_tableau_curseur_page[strname]+5; i++) { // on affiche un lien vers 5 pages
			if(i<nb_page){
				strpage = new String();
				strpage = left_tableau_liste_page[strname][i];
			}else{
				strpage = "";
			}
			strContent_page = new String();
			strContent_page = strname + '_page_' + (i-left_tableau_curseur_page[strname]);
			var id_page = document.getElementById(strContent_page);
			remplacerTexte(id_page, strpage);
			if(i==left_tableau_current_page[strname]){
				id_page.className = 'page_select';
			}else{
				id_page.className = '';
			}
		}	
	}
}

// affichage des tableau twin_left ('mat_twin', 'liaison_twin', 'CL_twin')
function affiche_Tableau_twin_left(current_tableau,strname,stridentificateur){
	var taille_Tableau=current_tableau.length;
	for(i=0; i<taille_tableau_twin_left; i++) {
		i_page = i + twin_left_tableau_current_page[strname] * taille_tableau_twin_left;
		twin_left_tableau_connect[strname][i]=i_page;
		strContent_pair = strname + '_pair_' + i;
		strContent_1 = strname + '_1_' + i;
		strContent_1a = strname + '_1a_' + i;
		strContent_11 = strname + '_11_' + i;
		strContent_12 = strname + '_12_' + i;
		strContent_14 = strname + '_14_' + i;
		var id_pair  = document.getElementById(strContent_pair);
		var id_1 = document.getElementById(strContent_1);
		var id_1a = document.getElementById(strContent_1a);
		var id_11 = document.getElementById(strContent_11);
		var id_12 = document.getElementById(strContent_12);
		var id_14 = document.getElementById(strContent_14);
		id_1.className = "tableNC_twin_box_0 off";
		id_pair.className = "tableNC_twin_pair";
		if(i_page<taille_Tableau){
			id_1.className = "tableNC_twin_box_0 on";
			if(pair(i)){
			    id_pair.className = "tableNC_twin_pair";
			}else{
			    id_pair.className = "tableNC_twin_impair";
			}
			if(strname=='CL_twin'){
				id_11.className = "tableNC_box_1 CL_" + current_tableau[i]['type_picto']	;
			}else{
				id_11.className = "tableNC_box_1 "+strname;
			}
			id_14.className = "tableNC_box_4";
			strtemp = new String();
			strtemp = current_tableau[i_page][stridentificateur];
			remplacerTexte(id_12, strtemp);
		}
	}
	// pour l'affichage des page en bas de la boite
	var nb_page = Math.floor(taille_Tableau/taille_tableau_twin_left)+1;
	if(nb_page < 5){
		twin_left_tableau_curseur_page[strname] = 0;
	}else{
		if(twin_left_tableau_current_page[strname] >= nb_page-3){
			twin_left_tableau_curseur_page[strname] = nb_page-5;
		}else if(twin_left_tableau_current_page[strname] < 3){
			twin_left_tableau_curseur_page[strname] = 0;
		}else{
			twin_left_tableau_curseur_page[strname] = twin_left_tableau_current_page[strname]-2;
		}
	}
	twin_left_tableau_liste_page[strname] = new Array();
	for(i=0; i<nb_page; i++) {
		twin_left_tableau_liste_page[strname][i] = i+1;
	}
	for(i=twin_left_tableau_curseur_page[strname]; i<twin_left_tableau_curseur_page[strname]+5; i++) { // on affiche un lien vers 5 pages
		if(i<nb_page){
			strpage = new String();
			strpage = twin_left_tableau_liste_page[strname][i];
		}else{
			strpage = "";
		}
		strContent_page = new String();
		strContent_page = strname + '_1page_' + (i-twin_left_tableau_curseur_page[strname]);
		var id_page = document.getElementById(strContent_page);
		remplacerTexte(id_page, strpage);
		if(i==twin_left_tableau_current_page[strname]){
			id_page.className = 'page_select';
		}else{
			id_page.className = '';
		}
		
	}

}



// affichage des tableau right ('piece', 'interface', 'bord')
function affiche_Tableau_right(current_tableau,strname,stridentificateur){
	var taille_Tableau=current_tableau.length;
	for(i=0; i<taille_tableau_right; i++) {
		i_page = i + right_tableau_current_page[strname] * taille_tableau_right;
		right_tableau_connect[strname][i]=i_page;
		strContent_pair = strname + '_pair_' + i;
		strContent_1 = strname + '_1_' + i;
		strContent_1r = strname + '_1r_' + i;
		strContent_11 = strname + '_11_' + i;
		strContent_12 = strname + '_12_' + i;
		strContent_14 = strname + '_14_' + i;
		var id_pair  = document.getElementById(strContent_pair);
		var id_1 = document.getElementById(strContent_1);
		var id_1r = document.getElementById(strContent_1a);
		var id_11 = document.getElementById(strContent_11);
		var id_12 = document.getElementById(strContent_12);
		var id_14 = document.getElementById(strContent_14);
		id_1.className = "tableNC_box_0 off";
		if(i_page<taille_Tableau){
			id_1.className = "tableNC_box_0 on";
			if(pair(i)){
			    id_pair.className = "tableNC_pair";
			}else{
			    id_pair.className = "tableNC_impair";
			}
			if(current_tableau[i_page]['group']=='true'){
				id_11.className = "tableNC_box_1 "+strname;
			}else if(current_tableau[i_page]['group']!='-1'){
				id_11.className = "tableNC_box_1 "+strname+" tableNC_box_retrait_10";
			}else{
				id_11.className = "tableNC_box_1 "+strname;
			}
			strtemp = new String();
			strtemp = current_tableau[i_page][stridentificateur];
			remplacerTexte(id_12, strtemp);
		}
	}
	// pour l'affichage des page en bas de la boite
	var nb_page = Math.floor(taille_Tableau/taille_tableau_right)+1;
	if(nb_page < 5){
		right_tableau_curseur_page[strname] = 0;
	}else{
		if(right_tableau_current_page[strname] >= nb_page-3){
			right_tableau_curseur_page[strname] = nb_page-5;
		}else if(right_tableau_current_page[strname] < 3){
			right_tableau_curseur_page[strname] = 0;
		}else{
			right_tableau_curseur_page[strname] = right_tableau_current_page[strname]-2;
		}
	}
	right_tableau_liste_page[strname] = new Array();
	for(i=0; i<nb_page; i++) {
		right_tableau_liste_page[strname][i] = i+1;
	}
	for(i=right_tableau_curseur_page[strname]; i<right_tableau_curseur_page[strname]+5; i++) { // on affiche un lien vers 5 pages
		if(i<nb_page){
			strpage = new String();
			strpage = right_tableau_liste_page[strname][i];
		}else{
			strpage = "";
		}
		strContent_page = new String();
		strContent_page = strname + '_page_' + (i-right_tableau_curseur_page[strname]);
		var id_page = document.getElementById(strContent_page);
		remplacerTexte(id_page, strpage);
		if(i==right_tableau_current_page[strname]){
			id_page.className = 'page_select';
		}else{
			id_page.className = '';
		}
		
	}

}

// affichage des tableau twin_right strname:('piece_twin', 'interface_twin', 'bord_twin')
function affiche_Tableau_twin_right(current_tableau,strname,stridentificateur){
	if(current_tableau[0] == "null"){
		var taille_Tableau=0;
	}else{
		var taille_Tableau=current_tableau.length;
	}
	for(i=0; i<taille_tableau_twin_right; i++) {
		i_page = i + twin_right_tableau_current_page[strname] * taille_tableau_twin_right;
		twin_right_tableau_connect[strname][i]=i_page;
		strContent_pair = strname + '_pair_' + i;
		strContent_1 = strname + '_1_' + i;
		strContent_1r = strname + '_1r_' + i;
		strContent_11 = strname + '_11_' + i;
		strContent_12 = strname + '_12_' + i;
		strContent_14 = strname + '_14_' + i;
		var id_pair  = document.getElementById(strContent_pair);
		var id_1 = document.getElementById(strContent_1);
		var id_1r = document.getElementById(strContent_1a);
		var id_11 = document.getElementById(strContent_11);
		var id_12 = document.getElementById(strContent_12);
		var id_14 = document.getElementById(strContent_14);
		id_1.className = "tableNC_twin_box_0 off";
		id_pair.className = "tableNC_twin_pair";
		if(i_page<taille_Tableau){
			id_1.className = "tableNC_twin_box_0 on";
			if(pair(i)){
			    id_pair.className = "tableNC_twin_pair";
			}else{
			    id_pair.className = "tableNC_twin_impair";
			}
			if(current_tableau[i_page]['group']=='true'){
				id_11.className = "tableNC_box_1 "+strname;
				id_14.className = "tableNC_box_4";
			}else if(current_tableau[i_page]['group']!='-1'){
				id_11.className = "tableNC_box_1 "+strname+" tableNC_box_retrait_10";
				id_14.className = "";
			}else{
				id_11.className = "tableNC_box_1 "+strname;
				id_14.className = "";
			}
			strtemp = new String();
			strtemp = current_tableau[i_page][stridentificateur];
			remplacerTexte(id_12, strtemp);
		}
	}
	// pour l'affichage des page en bas de la boite
	var nb_page = Math.floor(taille_Tableau/taille_tableau_twin_right)+1;
	if(nb_page < 5){
		twin_right_tableau_curseur_page[strname] = 0;
	}else{
		if(twin_right_tableau_current_page[strname] >= nb_page-3){
			twin_right_tableau_curseur_page[strname] = nb_page-5;
		}else if(twin_right_tableau_current_page[strname] < 3){
			twin_right_tableau_curseur_page[strname] = 0;
		}else{
			twin_right_tableau_curseur_page[strname] = twin_right_tableau_current_page[strname]-2;
		}
	}
	twin_right_tableau_liste_page[strname] = new Array();
	for(i=0; i<nb_page; i++) {
		twin_right_tableau_liste_page[strname][i] = i+1;
	}
	for(i=twin_right_tableau_curseur_page[strname]; i<twin_right_tableau_curseur_page[strname]+5; i++) { // on affiche un lien vers 5 pages
		if(i<nb_page){
			strpage = new String();
			strpage = twin_right_tableau_liste_page[strname][i];
		}else{
			strpage = "";
		}
		strContent_page = new String();
		strContent_page = strname + '_2page_' + (i-twin_right_tableau_curseur_page[strname]);
		var id_page = document.getElementById(strContent_page);
		remplacerTexte(id_page, strpage);
		if(i==twin_right_tableau_current_page[strname]){
			id_page.className = 'page_select';
		}else{
			id_page.className = '';
		}
		
	}
}


// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions permettant le déplacement de la partie centrale et de la scroll bar 
// -------------------------------------------------------------------------------------------------------------------------------------------

// foncion pour le scrolling des boites centrales -----------------------------------------------------
function NC_scroll_left_prog(t){
	var marge_scrollbar = document.getElementById('NC_marge_scrollbar'); // déplacement scrollbar
	var NC_contentcenter = document.getElementById('NC_contentcenter'); // déplacement NC_contentcenter
		       
	var widthmarge	= 1; 
	
	var margeActuel	= 5;	 	
	var margeBut = 260;

	NC_contentcenter.style.marginLeft =	margeActuel + 'px'; 
	
	var timer;
	var fct = function ()
	{
		widthmarge += 20;
		margeActuel += 20;
		
		if( margeActuel >= margeBut )
		{
			margeActuel = margeBut; 
			widthmarge = 255;
			marge_scrollbar.style.width =	widthmarge + 'px';
			NC_contentcenter.style.marginLeft =	margeActuel + 'px';  
			clearInterval(timer);   //Arrête le time
		}
		marge_scrollbar.style.width =	widthmarge + 'px';
		NC_contentcenter.style.marginLeft =	margeActuel + 'px';
	};

	fct(); 
	timer = setInterval(fct,t);    //Toute les 40 ms
}

function NC_scroll_right_prog(t){
	var marge_scrollbar = document.getElementById('NC_marge_scrollbar'); // déplacement scrollbar
	var NC_contentcenter = document.getElementById('NC_contentcenter'); // déplacement NC_contentcenter
		       
	var widthmarge	= 255; 
	
	var margeActuel	= 260;	 	
	var margeBut = 5; 

	NC_contentcenter.style.marginLeft =	margeActuel + 'px'; 
	
	var timer;
	var fct = function ()
	{
		widthmarge -= 20;
		margeActuel -= 20;
		
		if( margeActuel <= margeBut )
		{
			margeActuel = margeBut; 
			widthmarge = 1;
			marge_scrollbar.style.width =	widthmarge + 'px';
			NC_contentcenter.style.marginLeft =	margeActuel + 'px';  
			clearInterval(timer);   //Arrête le time
		}
		marge_scrollbar.style.width =	widthmarge + 'px';
		NC_contentcenter.style.marginLeft =	margeActuel + 'px';
	};
	fct(); 
	timer = setInterval(fct,t);    //Toute les 40 ms
}

function NC_scroll(){
	if(NC_current_scroll=='left'){
		NC_scroll_right_prog(20);
		NC_current_scroll = 'right';
	}
	else{
		NC_scroll_left_prog(20);
		NC_current_scroll = 'left';
	}
}

// height de fake_NC_contentcenter égale à celle de NC_contentcenter
function equal_height_NC_fake(){
	var hauteur=document.getElementById("NC_contentcenter").offsetHeight;
	document.getElementById("fake_NC_contentcenter").style.height=hauteur+"px";
}

// -------------------------------------------------------------------------------------------------------------------------------------------
// autres fonctions (pas encore util)
// -------------------------------------------------------------------------------------------------------------------------------------------
//afficher et cacher des filtres
function displayfilter(eltId) {
	arrLinkId = new Array('projet_pathbar_filter');
	intNbLinkElt = new Number(arrLinkId.length);
	strContent = new String();
	for (i=0; i<intNbLinkElt; i++) {
		strContent = arrLinkId[i];
		if ( eltId == "on" ) {
			document.getElementById(strContent).className = "on";
			document.getElementById("projet_pathbar_2_vew").className = "on";
			document.getElementById("projet_pathbar_2_hide").className = "off";
		}
		if ( eltId == "off" ) {
			document.getElementById(strContent).className = "off";
			document.getElementById("projet_pathbar_2_vew").className = "off";
			document.getElementById("projet_pathbar_2_hide").className = "on";
		}
	}	
}



-->
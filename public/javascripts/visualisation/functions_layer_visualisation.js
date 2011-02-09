<!--

// ------------------------------------------------------------------------------------------------------------
// initialisation de l'ensemble des variable utile pour la mise en page (affichage) 
// ------------------------------------------------------------------------------------------------------------
var model_id = '' ; 					// identite du modele courant
var NC_current_scroll = 'left';				// état de la scrollbar horizontale
var dim_model = 3;				// dimension du problème

var Tableau_model                   =  new Array();              // tableau des info du modèle

var Tableau_pieces                   =  new Array();              // tableau des pieces
var Tableau_pieces_filter            =  new Array();              // tableau des pieces filtres pour l'affichage
var Tableau_interfaces                   =  new Array();              // tableau des interfaces 
var Tableau_interfaces_filter            =  new Array();              // tableau des interfaces filtres pour l'affichage
var Tableau_bords                    =  new Array();              // tableau des bords
var Tableau_bords_filter             =  new Array();              // tableau des bords filtres pour l'affichage

//initialisation de la taille du tableau pour la box content et de la table de correspondance
var taille_tableau_content          =  20;                       // taille du tableau dans la content box
var content_tableau_connect         =  new Array();              // connectivité entre l'id de l'element graphique (div) et l'élément du tableau affiché dedans  
var content_tableau_current_page    =  new Array();              // numéro de la page du tableau (sert pour la définition de la connectivité)    
var content_tableau_curseur_page    =  new Array();              // nombre de page du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_liste_page      =  new Array();              // liste des pages du tableau (sert pour l'affichage des page en bas des tableaux)
var content_tableau_page            =  new Array('piece','interface','bord');    // initialisation des pages avec tableau dynamique

var taille_tableau_content_page     =  new Array()               // taille du tableau dans la content box
taille_tableau_content_page['piece'] = 20;
taille_tableau_content_page['interface'] = 20;
taille_tableau_content_page['bord'] = 20;


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

var image_3d;

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
    var is_list2 = (Object.prototype.toString.apply(arr) === '[object Object]');
    var virgule ='on';

    for(var key in arr) {
	var value = arr[key];
	if(typeof value == "object") { //Custom handling for arrays
		var str = "";
		var str2 = "";
		//alert('object_' + key);
		if(is_list2){ 
			str =  '\"'+key + '\":';
			virgule ='on';
			str2 = array2json(value); /* :RECURSION: */
			str += str2;
			//str = '{' + str + '}'
			parts.push(str);
 		} else if(is_list) {
 			if(isNaN(key)){
				str =  '\"'+key + '\":';
				virgule ='on';
				str2 = array2json(value); /* :RECURSION: */
				str += str2;
				//str = '{' + str + '}'
				parts.push(str);
			}else{
				virgule ='off'
				parts.push(array2json(value)); /* :RECURSION: */
			}
		}else {
			parts[key] = array2json(value); /* :RECURSION: */
		}
		//else parts.push('"' + key + '":' + returnedVal);
	} else {
		if(typeof value != "function"){
			//virgule ='on';
			var str = "";
			//if(!is_list) 
			str =  '\"'+key + '\":';
	    
			//Custom handling for multiple data types
			if(typeof value == "number") str += value; //Numbers
			else if(value === false) str += 'false'; //The booleans
			else if(value === true) str += 'true';
			else str +=  '\"'+value+'\"' ; //All other things
			// :TODO: Is there any more datatype we should be in the lookout for? (Functions?)
			parts.push(str);
		}
	}
    }
    if(virgule =='on'){
      var json = parts.join(", ");
      return '{' + json + '}';//Return numerical JSON
    }
    else if(virgule =='off'){
      var json = parts.join(", ");
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
function object2array(object){
    var array = new Array();
    for(var key in object) {
	var value = object[key];
	if(typeof value == "Array" || typeof value == "object") { //Custom handling for arrays
            array[key] = object2array(value);
        } else {
            array[key] = value;
        }
    }
    return array;
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



// ---------------------------------------------------------------------------------------------------------
// affichage des boites de droite
// ---------------------------------------------------------------------------------------------------------

function cadres_off(){
  list_str_id = new Array( 'page_righ_piece','page_righ_interface','page_righ_bord');
  list_str_menu_id = new Array('MenuPieces', 'MenuInterfaces', 'MenuBords');
  for(i=0; i<list_str_id.length; i++){
    strtemp = list_str_id[i];
    id_off = document.getElementById(strtemp);
    if(id_off != null){
      id_off.className = 'NC_box off';
    }
  }
  
  for(i=0; i<list_str_menu_id.length; i++){
    strtemp = list_str_menu_id[i];
    id_not_selected = document.getElementById(strtemp);
    if(id_not_selected != null){
      //alert(strtemp);
      id_not_selected.className = '';
    }
  }
}

function affich_Pieces(){
  cadres_off();
  id_on = document.getElementById('page_righ_piece');	
  id_on.className = 'NC_box on';
  
  id_selected = document.getElementById('MenuPieces');	
  id_selected.className = 'selected';
}

function affich_Interfaces(){
  cadres_off();
  id_on = document.getElementById('page_righ_interface');	
  id_on.className = 'NC_box on';
  
  id_selected = document.getElementById('MenuInterfaces');	
  id_selected.className = 'selected';
}

function affich_Bords(){
  cadres_off();
  id_on = document.getElementById('page_righ_bord');	
  id_on.className = 'NC_box on';
  
  id_selected = document.getElementById('MenuBords');	
  id_selected.className = 'selected';
}

// ---------------------------------------------------------------------------------------------------------
// autres fonctions 
// ---------------------------------------------------------------------------------------------------------
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


// -------------------------------------------------------------------------------------------------
// obtention du tableau info model
// -------------------------------------------------------------------------------------------------

// traitement en fin de requette pour l'obtention des info du model
function init_info_model(Tableau_model_temp)
// function init_Tableau_model(response)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_model_temp)
    {   
        Tableau_model = Tableau_model_temp ;
	//alert(array2json(Tableau_model))
	var taille_Tableau=Tableau_model_temp.length;
    	for(i=0; i<taille_Tableau; i++) {
	    //alert(Object.prototype.toString.apply(Tableau_model_temp[i]));
	    for (var key in Tableau_model_temp[i]) {
		if(key == 'mesh'){
		    Tableau_id_model = Tableau_model[i][key];
		    //alert(Tableau_id_model);
		    //strtemp = $.toJSON(Tableau_pieces);
		    //alert(strtemp);
		}
		else if(key == 'groups_elem'){
		    Tableau_pieces = Tableau_model[i][key];
		    //alert($.toJSON(Tableau_pieces));
		    //strtemp = $.toJSON(Tableau_pieces);
		    //alert(strtemp);
		}
		else if(key == 'groups_inter'){
		    Tableau_interfaces = Tableau_model[i][key];
		    //strtemp = $.toJSON(Tableau_interfaces);
		    //alert(strtemp);
		}
		else if(key == 'groups_bord'){
		    Tableau_bords = Tableau_model[i][key];
		    //strtemp = $.toJSON(Tableau_interfaces);
		    //alert(strtemp);
		}
	    }
    	}
    }
    else
    {
        Tableau_model[0]         =  new Array();
        Tableau_model[0]['name'] = 'nouveau calcul';
	Tableau_model[0]['type'] = 'statique';
	Tableau_model[0]['description'] = 'nouvelle description';
    }
    affiche_Tableau_piece();
    affiche_Tableau_interface();
    affiche_Tableau_bord();
    //object_temp = array2object(Tableau_model); 
    //strtemp = $.toJSON(Tableau_model);
    //alert(strtemp);
}


function get_info_model(num_model)
{
    var url_php = "/visualisation/info_model";
    $.getJSON(url_php,{ id_model: num_model },init_info_model);
}

//------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des pieces
//------------------------------------------------------------------------------------------------------

// affichage du tableau des pièces
function filtre_Tableau_pieces(){
	Tableau_pieces_filter = Tableau_pieces;
}

// affichage du tableau des pièces
function affiche_Tableau_piece(){
	//alert(array2json(Tableau_pieces));
	filtre_Tableau_pieces();
	var current_tableau = Tableau_pieces_filter;
	var strname = 'piece';
	var stridentificateur = ['name'];
	affiche_Tableau_NC(current_tableau,strname,stridentificateur);
}

// affiche la page num pour la liste des pièces
function go_page_piece(num){
	if(num=='first'){
		content_tableau_current_page['piece'] = 0;
	}else if(num=='end'){
		content_tableau_current_page['piece'] = content_tableau_liste_page['piece'].length;
	}else{
		var num_page = num + content_tableau_curseur_page['piece'];
		content_tableau_current_page['piece']=content_tableau_liste_page['piece'][num_page]-1;
	}
	affiche_Tableau_piece();
}

// selectionner (activer) un une piece
function active_piece_select(id){
        var num_select = -1; 
        var id_select = -1; 
        for(i=0;i<Tableau_pieces.length;i++){
                if(Tableau_pieces[i]['id'] == id) {
                      num_select = i;
                      id_select = id;
                      break;
                }
        }
        if(num_select != -1){
                num_page = Math.floor(num_select/taille_tableau_content_page['piece']);
                num_in_page = num_select - num_page * taille_tableau_content_page['piece'];
                go_page_piece(num_page);
                select_pieces(num_in_page)
        }
}

// afficher la piece actif dans la twin box left
function select_pieces(num_in_page){ 
        for(i=0;i<taille_tableau_content_page['piece'];i++){
                strContent_1 = new String();
                strContent_1 = 'piece_lign_' + i;
                var id_active = document.getElementById(strContent_1);
                if(id_active.className != "tableNC_box_lign off"){
                        if(i==num_in_page){
                                id_active.className = "tableNC_box_lign_active on";
                        }else{
                                id_active.className = "tableNC_box_lign on";
                        }
                }
        }
}


//------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des interfaces
//------------------------------------------------------------------------------------------------------

// affichage du tableau des pièces
function filtre_Tableau_interfaces(){
	Tableau_interfaces_filter = Tableau_interfaces;
}

// affichage du tableau des pièces
function affiche_Tableau_interface(){
	//alert(array2json(Tableau_interfaces));
	filtre_Tableau_interfaces();
	var current_tableau = Tableau_interfaces_filter;
	var strname = 'interface';
	var stridentificateur = ['name'];
	affiche_Tableau_NC(current_tableau,strname,stridentificateur);
}

// affiche la page num pour la liste des pièces
function go_page_interface(num){
	if(num=='first'){
		content_tableau_current_page['interface'] = 0;
	}else if(num=='end'){
		content_tableau_current_page['interface'] = content_tableau_liste_page['interface'].length;
	}else{
		var num_page = num + content_tableau_curseur_page['interface'];
		content_tableau_current_page['interface']=content_tableau_liste_page['interface'][num_page]-1;
	}
	affiche_Tableau_piece();
}


//------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des bords
//------------------------------------------------------------------------------------------------------

// affichage du tableau des pièces
function filtre_Tableau_bords(){
	Tableau_bords_filter = Tableau_bords;
}

// affichage du tableau des pièces
function affiche_Tableau_bord(){
	//alert(array2json(Tableau_bords));
	filtre_Tableau_bords();
	var current_tableau = Tableau_bords_filter;
	var strname = 'bord';
	var stridentificateur = ['name'];
	affiche_Tableau_NC(current_tableau,strname,stridentificateur);
}

// affiche la page num pour la liste des pièces
function go_page_bord(num){
	if(num=='first'){
		content_tableau_current_page['bord'] = 0;
	}else if(num=='end'){
		content_tableau_current_page['bord'] = content_tableau_liste_page['bord'].length;
	}else{
		var num_page = num + content_tableau_curseur_page['bord'];
		content_tableau_current_page['bord']=content_tableau_liste_page['bord'][num_page]-1;
	}
	affiche_Tableau_piece();
}

//------------------------------------------------------------------------------------------------------
// fonctions utiles pour l'affichage des tableaux
//------------------------------------------------------------------------------------------------------


// affichage des tableau content ('Resultat')
function affiche_Tableau_NC(current_tableau, strname, stridentificateur){
    var taille_Tableau=current_tableau.length;
    for(i=0; i<taille_tableau_content; i++) {
        i_page = i + content_tableau_current_page[strname] * taille_tableau_content;
        content_tableau_connect[strname][i]=i_page;
        
        strContent_lign = strname + '_lign_' + i;
	strContent_pair = strname + '_pair_' + i;
	strContent_picto = strname + '_picto_' + i;
	//alert(strContent_lign);
	var id_lign  = document.getElementById(strContent_lign);
	var id_pair  = document.getElementById(strContent_pair);
	var id_picto  = document.getElementById(strContent_picto);
	strContent =  new Array();
	idContent =  new Array();
	for(j=0; j<stridentificateur.length; j++) {
	      strContent[j] = strname + '_' + j + '_' + i;
	      idContent[j] = document.getElementById(strContent[j]);
	}
        
        if(i_page<taille_Tableau){
            id_lign.className = "tableNC_box_lign on";
	    if(pair(i)){
		id_pair.className = "tableNC_pair";
	    }else{
		id_pair.className = "tableNC_impair";
	    }
	    id_picto.className = "tableNC_box_picto "+strname;
	    strtemp =  new Array();
	    for(j=0; j<stridentificateur.length; j++) {
		  strtemp[j] = current_tableau[i_page][stridentificateur[j]];
		  remplacerTexte(idContent[j], strtemp[j]);
	    }
        }else{
            id_lign.className = "tableNC_box_lign off";
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



// affiche la page num pour la liste des forfait
function go_page_new_forfait(num){
    if(num=='first'){
        content_tableau_current_page['new_forfait'] = 0;
    }else if(num=='end'){
        content_tableau_current_page['new_forfait'] = content_tableau_liste_page['new_forfait'].length-1;
    }else{
        var num_page = num + content_tableau_curseur_page['new_forfait'];
        content_tableau_current_page['new_forfait'] = content_tableau_liste_page['new_forfait'][num_page]-1;    
    }
    affiche_Tableau_forfait();
}


//------------------------------------------------------------------------------------------------------
// initialisation du serveur d'image en relation aves ImgServer.js
//------------------------------------------------------------------------------------------------------

function init_all() {
    image_3d = new ImgServer( "my_canvas", "00" );
    strgeom = new String();
    strgeom = '/share/sc2/Developpement/MODEL/model_' + model_id + '/MESH/geometrie_all_0_0.vtu';
    //strgeom = '/share/sc2/Developpement/MODEL/model_' + model_id + '/MESH/geom_inter_0_0.vtu';
    
    //image_3d.load_vtu( strgeom );
    image_3d.load_vtu( "/var/www/Visu/data/geometry_all_0_0.vtu" );
    //image_3d.load_vtu( "/var/www/Visu/data/manchon.vtu" );
    //     alert(s);
    //image_3d.load_vtu( "/home/jbellec/Dropbox/SC/Inbox/fibres_mat/calcul_97/resultat_0_0.vtu" );
    //image_3d.load_vtu("/var/www/Visu/data/croix.vtu" );
    //image_3d.color_by_field( "epsilon", 1 );
    //image_3d.shrink( 0.05 );
    image_3d.fit();
    image_3d.render();
}




-->
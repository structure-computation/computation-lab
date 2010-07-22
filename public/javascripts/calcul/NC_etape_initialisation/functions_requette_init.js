<!--
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
    var url_php = "/calcul/info_model";
    $.getJSON(url_php,{ id_model: num_model },init_info_model);
}


// -------------------------------------------------------------------------------------------------
// obtention du tableau des calculs et brouillons
// -------------------------------------------------------------------------------------------------

// traitement en fin de requette pour l'obtention du tableau des calcul
function init_Tableau_calcul(Tableau_calcul_temp)
// function init_Tableau_model(response)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_calcul_temp){   
        var taille_Tableau=Tableau_calcul_temp.length;
    	for(i=0; i<taille_Tableau; i++) {
    		Tableau_calcul[i]=Tableau_calcul_temp[i]['calcul_result'];
    	}
    }else{
	Tableau_calcul[0]         =  new Array();
    }
    //strtemp = array2json(Tableau_calcul); 
    //strtemp = Tableau_calcul[0]['name']; 
    //var id_test = document.getElementById("textetest"); 
    //remplacerTexte(id_test, strtemp);
    affiche_Tableau_calcul();
    Tableau_init_select=clone(new_Tableau_init_select);
    Tableau_init_time_step[0]=clone(Tableau_init_time_step_temp);
    affiche_Tableau_init_select();
}


function get_Tableau_calcul(num_model)
{
    var url_php = "/calcul/calculs";
    $.getJSON(url_php,{ id_model: num_model },init_Tableau_calcul);
}

// -------------------------------------------------------------------------------------------------
// initialisation d'un nouveau calculresult dans la bdd après l'étape d'initialisation
// -------------------------------------------------------------------------------------------------


// traitement en fin de requette pour l'obtention de l'identité du calcul
function init_new_calculresult(new_calculresult_temp)
// function init_Tableau_model(response)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (new_calculresult_temp)
    {   
	new_calculresult = new Array();
	new_calculresult = new_calculresult_temp;
	//alert(array2json(new_calculresult['calcul_result']));
	Tableau_init_select = new_calculresult_temp['calcul_result'];
	
    }
    else
    {
        Tableau_init_select['id'] = 'nouveau calcul';
    }
    //alert(Tableau_init_select['id']);
    affiche_Tableau_init_select();
}

// traitement en fin de requette pour l'obtention de l'identité du calcul
function load_brouillon(brouillon_temp)
// function init_Tableau_model(response)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (brouillon_temp)
    {   
	Tableau_model = brouillon_temp ;
	//alert(array2json(Tableau_model['mesh']))
	var taille_Tableau=Tableau_model.length;
	//alert(taille_Tableau)
	for (var key in Tableau_model) {
	    if(key == 'state'){
		    NC_current_step = Tableau_model[key]['NC_current_step'];
		    compteur_mat_select = Tableau_model[key]['compteur_mat_select'];
		    compteur_liaison_select = Tableau_model[key]['compteur_liaison_select'];
		    compteur_CL_select = Tableau_model[key]['compteur_CL_select'];
		    compteur_bords_test = Tableau_model[key]['compteur_bords_test'];
	    }
	    else if(key == 'mesh'){
		Tableau_id_model = object2array(Tableau_model[key]);
		//alert('mesh');
	    }
	    else if(key == 'groups_elem'){
		Tableau_pieces = object2array(Tableau_model[key]);
		//alert('groups_elem');
	    }
	    else if(key == 'groups_inter'){
		Tableau_interfaces = object2array(Tableau_model[key]);
		//alert('groups_inter');
	    }
	    else if(key == 'groups_edge'){
		Tableau_bords = object2array(Tableau_model[key]);
		//alert(Tableau_bords);
		//alert(Object.prototype.toString.apply(Tableau_bords));
	    }
	    else if(key == 'materials'){
		Tableau_mat_select = object2array(Tableau_model[key]);
		//alert(array2json(Tableau_model[key]));
		//objet_temp = array2object(Tableau_model[key]);
		//alert($.toJSON(Tableau_model[key]));
	    }
	    else if(key == 'links'){
		Tableau_liaison_select = object2array(Tableau_model[key]);
		//alert('links');
	    }
	    else if(key == 'CL'){
		Tableau_CL_select = object2array(Tableau_model[key]);
		//alert('CL');
	    }
	    else if(key == 'CL_volume'){
		Tableau_CL_select_volume = object2array(Tableau_model[key]);
		//alert('CL_volume');
	    }
	    else if(key == 'time_step'){
		Tableau_init_time_step = object2array(Tableau_model[key]);
		//alert('CL_volume');
	    }
	    else if(key == 'options'){
		Tableau_option_select = object2array(Tableau_model[key]);
		//alert('CL_volume');
	    }
	    else if(key == 'groupe_pieces'){
		groupe_pieces = object2array(Tableau_model[key]);
		//alert('CL_volume');
	    }
	    else if(key == 'groupe_interfaces'){
		groupe_interfaces = object2array(Tableau_model[key]);
		//alert('CL_volume');
	    }
	    else if(key == 'groupe_bords'){
		groupe_bords = object2array(Tableau_model[key]);
		//alert('CL_volume');
	    }
	}
    }
    else
    {
        alert('pas de brouillon');
    }
    refresh_NC_page_materiaux();
    refresh_NC_page_liaisons();
    refresh_NC_page_CLs();
    affiche_NC_page_materiaux();
    
    //alert(Tableau_init_select['id']);
}

function get_new_calculresult(num_model)
{  
    data = new Object();
    data['id_model'] = num_model;
    data['name'] = Tableau_init_select['name'];
    data['description'] = Tableau_init_select['description'];
    data['id_calcul'] = Tableau_init_select['id'];
    data['ctype'] = Tableau_init_select['ctype'];
    data['D2type'] = Tableau_init_select['D2type'];
    
    if(Tableau_init_select['id'] == -1){
	var url_php = "/calcul/new";
	$.getJSON(url_php,data,init_new_calculresult);
    }else{
	var url_php = "/calcul/get_brouillon";
	$.getJSON(url_php,data,load_brouillon);
    }
}

-->
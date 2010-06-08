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
	var taille_Tableau=Tableau_model_temp.length;
    	for(i=0; i<taille_Tableau; i++) {
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
    if (Tableau_calcul_temp)
    {   
        var taille_Tableau=Tableau_calcul_temp.length;
    	for(i=0; i<taille_Tableau; i++) {
    		Tableau_calcul[i]=Tableau_calcul_temp[i]['calcul_result'];
    	}
    }
    else
    {
	Tableau_calcul[0]         =  new Array();
        Tableau_calcul[0]['calcul_result']         =  new Array();
        Tableau_calcul[0]['calcul_result']['name'] = 'nouveau calcul';
	Tableau_calcul[0]['calcul_result']['ctype'] = 'statique';
	Tableau_calcul[0]['calcul_result']['description'] = 'nouvelle description';
	Tableau_calcul[0]['calcul_result']['id'] = 'à définir';
    }
    //strtemp = array2json(Tableau_calcul); 
    //strtemp = Tableau_calcul[0]['name']; 
    //var id_test = document.getElementById("textetest"); 
    //remplacerTexte(id_test, strtemp);
    affiche_Tableau_calcul();
    Tableau_init_select['name'] = 'nouveau calcul';
    Tableau_init_select['description'] = 'première description';
    Tableau_init_select['id'] = 'à définir';
    Tableau_init_time_step[0]=Tableau_init_time_step_temp;
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

function get_new_calculresult(num_model)
{
    var url_php = "/calcul/new";
    data = new Object();
    data['id_model'] = num_model;
    data['name'] = Tableau_init_select['name'];
    data['description'] = Tableau_init_select['description'];
    $.getJSON(url_php,data,init_new_calculresult);
}

-->
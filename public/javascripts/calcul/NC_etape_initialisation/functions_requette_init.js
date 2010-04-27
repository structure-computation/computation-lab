<!--

Tableau_model        =  new Object();
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
		if(key == 'groups_elem'){
		    Tableau_pieces = Tableau_model_temp[i][key];
		    //strtemp = $.toJSON(Tableau_pieces);
		    //alert(strtemp);
		}
		else if(key == 'groups_inter'){
		    Tableau_interfaces = Tableau_model_temp[i][key];
		    strtemp = $.toJSON(Tableau_interfaces);
		    alert(strtemp);
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
    //object_temp = array2object(Tableau_model); 
    //strtemp = $.toJSON(Tableau_model);
    //alert(strtemp);
}


function get_info_model(num_model)
{
    var url_php = "/calcul/info_model";
    $.getJSON(url_php,{ id_model: num_model },init_info_model);
}




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
        Tableau_calcul[0]['name'] = 'nouveau calcul';
	Tableau_calcul[0]['type'] = 'statique';
	Tableau_calcul[0]['description'] = 'nouvelle description';
    }
    //strtemp = array2json(Tableau_calcul); 
    //strtemp = Tableau_calcul[0]['name']; 
    //var id_test = document.getElementById("textetest"); 
    //remplacerTexte(id_test, strtemp);
    affiche_Tableau_calcul();
    Tableau_init_select = Tableau_calcul[0];
    Tableau_init_time_step[0]=Tableau_init_time_step_temp;
    affiche_Tableau_init_select();
}


function get_Tableau_calcul()
{	
	var url_php = "/calcul/calculs";
    $.getJSON(url_php,init_Tableau_calcul);
}


-->
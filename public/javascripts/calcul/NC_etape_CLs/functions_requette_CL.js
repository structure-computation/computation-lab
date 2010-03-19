<!--
// traitement en fin de requette pour l affichage du tableau des CLs
function init_Tableau_CL(Tableau_CL_temp)
{
	//var Tableau_calcul_temp = eval('(' + response + ')');
    if (Tableau_CL_temp)
    {	
    	Tableau_CL_select_volume = new Array();
    	Tableau_CL = new Array();
    	for(j=0; j<3 ;j++){
    		var taille_Tableau_CL_select_volume = Tableau_CL_select_volume.length;
		Tableau_CL_select_volume[taille_Tableau_CL_select_volume]=new Array();
		Tableau_CL_select_volume[taille_Tableau_CL_select_volume]=clone(Tableau_CL_temp[j]['boundary_condition']);
		Tableau_CL_select_volume[taille_Tableau_CL_select_volume]['select'] = false;
		Tableau_CL_select_volume[taille_Tableau_CL_select_volume]['step'] = Tableau_init_time_step_temp ;
    	}
    	for(j=3; j<Tableau_CL_temp.length ;j++){
		var taille_Tableau_CL = Tableau_CL.length;
		Tableau_CL[taille_Tableau_CL]=new Array();
		Tableau_CL[taille_Tableau_CL]=clone(Tableau_CL_temp[j]['boundary_condition']);
		Tableau_CL[taille_Tableau_CL]['id_select'] = '';
		Tableau_CL[taille_Tableau_CL]['step'] = Tableau_init_time_step_temp;
	}
    }
    else
    {
    	Tableau_CL[0]= new Array();
        Tableau_CL[0]['name']='aucun calcul';
    }
    affiche_Tableau_CL();
}

// requette pour l'obtention du tableau des CL
function get_Tableau_CL()
{
	var url_php = "/calcul/CLs";
	$.getJSON(url_php,init_Tableau_CL);
}

-->

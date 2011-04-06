<!--
// traitement en fin de requette pour l affichage du tableau des CLs
function init_Tableau_CL(Tableau_CL_temp)
{
	//var Tableau_calcul_temp = eval('(' + response + ')');
    if (Tableau_CL_temp)
    {	
    	Tableau_CL_select_volume = new Array();
    	Tableau_CL = new Array();
	
	// pour les efforts volumiques
	// le poids
	Tableau_CL_select_volume[0]=new Array();
	Tableau_CL_select_volume[0]=clone(Tableau_CL_temp[0]['boundary_condition']);
	Tableau_CL_select_volume[0]['select'] = false;
	Tableau_CL_select_volume[0]['step'] = new Array();
	Tableau_CL_select_volume[0]['step'][0] = new Array();
	Tableau_CL_select_volume[0]['step'][0]['gravity'] = 9.8;
	Tableau_CL_select_volume[0]['step'][0]['pdirection_x'] = 0;
	Tableau_CL_select_volume[0]['step'][0]['pdirection_y'] = 0;
	Tableau_CL_select_volume[0]['step'][0]['pdirection_z'] = 1;
	
	// les efforts d'accélération
	Tableau_CL_select_volume[1]=new Array();
	Tableau_CL_select_volume[1]=clone(Tableau_CL_temp[1]['boundary_condition']);
	Tableau_CL_select_volume[1]['select'] = false;
	Tableau_CL_select_volume[1]['step'] = new Array();
	Tableau_CL_select_volume[1]['step'][0] = new Array();
	Tableau_CL_select_volume[1]['step'][0]['gravity'] = 1;
	Tableau_CL_select_volume[1]['step'][0]['pdirection_x'] = 0;
	Tableau_CL_select_volume[1]['step'][0]['pdirection_y'] = 0;
	Tableau_CL_select_volume[1]['step'][0]['pdirection_z'] = 1;
	
	// les efforts centrifuges
	Tableau_CL_select_volume[2]=new Array();
	Tableau_CL_select_volume[2]=clone(Tableau_CL_temp[2]['boundary_condition']);
	Tableau_CL_select_volume[2]['select'] = false;
	Tableau_CL_select_volume[2]['step'] = new Array();
	Tableau_CL_select_volume[2]['step'][0] = new Array();
	Tableau_CL_select_volume[2]['step'][0]['wrotation'] = 1;
	Tableau_CL_select_volume[2]['step'][0]['pdirection_x'] = 0;
	Tableau_CL_select_volume[2]['step'][0]['pdirection_y'] = 0;
	Tableau_CL_select_volume[2]['step'][0]['pdirection_z'] = 1;
	Tableau_CL_select_volume[2]['step'][0]['point_1_x'] = 0;
	Tableau_CL_select_volume[2]['step'][0]['point_1_y'] = 0;
	Tableau_CL_select_volume[2]['step'][0]['point_1_z'] = 0;

//     	for(j=0; j<3 ;j++){
//     		var taille_Tableau_CL_select_volume = Tableau_CL_select_volume.length;
// 		Tableau_CL_select_volume[taille_Tableau_CL_select_volume]=new Array();
// 		Tableau_CL_select_volume[taille_Tableau_CL_select_volume]=clone(Tableau_CL_temp[j]['boundary_condition']);
// 		Tableau_CL_select_volume[taille_Tableau_CL_select_volume]['select'] = false;
// 		//Tableau_CL_select_volume[taille_Tableau_CL_select_volume]['step'] = clone(Tableau_init_time_step_temp) ;
// 		Tableau_CL_select_volume[taille_Tableau_CL_select_volume]['step'] = new Array();
// 		Tableau_CL_select_volume[taille_Tableau_CL_select_volume]['step'][0]=clone(Tableau_CL_step);
//     	}
    	for(j=3; j<Tableau_CL_temp.length ;j++){
		var taille_Tableau_CL = Tableau_CL.length;
		Tableau_CL[taille_Tableau_CL]=new Array();
		Tableau_CL[taille_Tableau_CL]=clone(Tableau_CL_temp[j]['boundary_condition']);
		Tableau_CL[taille_Tableau_CL]['id_select'] = '';
		//Tableau_CL[taille_Tableau_CL]['step'] = clone(Tableau_init_time_step_temp);
		Tableau_CL[taille_Tableau_CL]['step'] = new Array();
		Tableau_CL[taille_Tableau_CL]['step'][0]=clone(Tableau_CL_step);
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

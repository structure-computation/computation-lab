<!--
// traitement en fin de requette pour l affichage du tableau des CLs
//function init_Tableau_CL(Tableau_CL_temp)
function init_Tableau_CL()
{
	//var Tableau_calcul_temp = eval('(' + response + ')');
    /*if (Tableau_CL_temp)
    {*/	
    	Tableau_CL_select_volume = new Array();
        Tableau_CL = new Array();
    	Tableau_CLe = new Array();
        Tableau_CLd = new Array();
        
	// pour les efforts volumiques
	// le poids
	Tableau_CL_select_volume[0]=new Array();
// 	Tableau_CL_select_volume[0]=clone(Tableau_CL_temp[0]['boundary_condition']);
        
        Tableau_CL_select_volume[0]['ref'] = 0;
        Tableau_CL_select_volume[0]['type_picto'] = "poids";
        Tableau_CL_select_volume[0]['bctype'] = "volume";
        Tableau_CL_select_volume[0]['name'] = "effort volumique 0";
        
	Tableau_CL_select_volume[0]['select'] = false;
	Tableau_CL_select_volume[0]['step'] = new Array();
	Tableau_CL_select_volume[0]['step'][0] = new Array();
	Tableau_CL_select_volume[0]['step'][0]['gravity'] = 1;
	Tableau_CL_select_volume[0]['step'][0]['pdirection_x'] = 0;
	Tableau_CL_select_volume[0]['step'][0]['pdirection_y'] = 0;
	Tableau_CL_select_volume[0]['step'][0]['pdirection_z'] = 0;
        
        Tableau_CL_select_volume[0]['step'][0]['wrotation'] = 0;
        Tableau_CL_select_volume[0]['step'][0]['point_1_x'] = 0;
        Tableau_CL_select_volume[0]['step'][0]['point_1_y'] = 0;
        Tableau_CL_select_volume[0]['step'][0]['point_1_z'] = 0;
	
	// les efforts d'accélération
	Tableau_CL_select_volume[1]=new Array();
// 	Tableau_CL_select_volume[1]=clone(Tableau_CL_temp[1]['boundary_condition']);
        
        Tableau_CL_select_volume[1]['ref'] = 1;
        Tableau_CL_select_volume[1]['type_picto'] = "poids";
        Tableau_CL_select_volume[1]['bctype'] = "volume";
        Tableau_CL_select_volume[1]['name'] = "effort volumique 1";
        
	Tableau_CL_select_volume[1]['select'] = false;
	Tableau_CL_select_volume[1]['step'] = new Array();
	Tableau_CL_select_volume[1]['step'][0] = new Array();
	Tableau_CL_select_volume[1]['step'][0]['gravity'] = 1;
	Tableau_CL_select_volume[1]['step'][0]['pdirection_x'] = 0;
	Tableau_CL_select_volume[1]['step'][0]['pdirection_y'] = 0;
	Tableau_CL_select_volume[1]['step'][0]['pdirection_z'] = 0;
        
        Tableau_CL_select_volume[1]['step'][0]['wrotation'] = 0;
        Tableau_CL_select_volume[1]['step'][0]['point_1_x'] = 0;
        Tableau_CL_select_volume[1]['step'][0]['point_1_y'] = 0;
        Tableau_CL_select_volume[1]['step'][0]['point_1_z'] = 0;
	
	// les efforts centrifuges
	Tableau_CL_select_volume[2]=new Array();
// 	Tableau_CL_select_volume[2]=clone(Tableau_CL_temp[2]['boundary_condition']);
        
        Tableau_CL_select_volume[2]['ref'] = 2;
        Tableau_CL_select_volume[2]['type_picto'] = "poids";
        Tableau_CL_select_volume[2]['bctype'] = "volume";
        Tableau_CL_select_volume[2]['name'] = "effort volumique 2";
        
	Tableau_CL_select_volume[2]['select'] = false;
	Tableau_CL_select_volume[2]['step'] = new Array();
	Tableau_CL_select_volume[2]['step'][0] = new Array();
        Tableau_CL_select_volume[2]['step'][0]['gravity'] = 1;
        Tableau_CL_select_volume[2]['step'][0]['pdirection_x'] = 0;
        Tableau_CL_select_volume[2]['step'][0]['pdirection_y'] = 0;
        Tableau_CL_select_volume[2]['step'][0]['pdirection_z'] = 0;
        
	Tableau_CL_select_volume[2]['step'][0]['wrotation'] = 0;
	Tableau_CL_select_volume[2]['step'][0]['point_1_x'] = 0;
	Tableau_CL_select_volume[2]['step'][0]['point_1_y'] = 0;
	Tableau_CL_select_volume[2]['step'][0]['point_1_z'] = 0;

        
        for(j=0; j<1 ;j++){
                Tableau_CLe[j]=new Array();      
                Tableau_CLe[j]['type_picto'] = "effort";
                Tableau_CLe[j]['bctype'] = "effort";
                Tableau_CLe[j]['ref'] = -1;
                Tableau_CLe[j]['id_select'] = '';
                Tableau_CLe[j]['name_select'] = '';
                Tableau_CLe[j]['description'] = '';
                Tableau_CLe[j]['step'] = new Array();
                Tableau_CLe[j]['step'][0]=clone(Tableau_CL_step);
        }
        Tableau_CLe[0]['ref'] = "e0";
        Tableau_CLe[0]['name'] = "densité d'effort";
        
        for(j=0; j<3 ;j++){
                Tableau_CLd[j]=new Array();      
                Tableau_CLd[j]['type_picto'] = "depl";
                Tableau_CLd[j]['bctype'] = "depl";
                Tableau_CLd[j]['ref'] = -1;
                Tableau_CLd[j]['id_select'] = '';
                Tableau_CLd[j]['name_select'] = '';
                Tableau_CLd[j]['description'] = '';
                Tableau_CLd[j]['step'] = new Array();
                Tableau_CLd[j]['step'][0]=clone(Tableau_CL_step);
        }
        Tableau_CLd[0]['ref'] = "d0";
        Tableau_CLd[0]['name'] = "déplacement imposé";
        Tableau_CLd[0]['bctype'] = "depl";
        Tableau_CLd[1]['ref'] = "d1";
        Tableau_CLd[1]['name'] = "déplacement normal imposé";
        Tableau_CLd[1]['bctype'] = "depl_normal";
        Tableau_CLd[2]['ref'] = "d2";
        Tableau_CLd[2]['name'] = "symétrie";
        Tableau_CLd[2]['bctype'] = "sym";

//     }
//     else
//     {
//     	Tableau_CL[0]= new Array();
//         Tableau_CL[0]['name']='aucun calcul';
//     }
    affiche_Tableau_CL();
}

// requette pour l'obtention du tableau des CL
function get_Tableau_CL()
{
        init_Tableau_CL();
	var url_php = "/calcul/CLs";
	$.getJSON(url_php,init_Tableau_CL);
}

-->

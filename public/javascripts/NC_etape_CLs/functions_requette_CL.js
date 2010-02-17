<!--
// traitement en fin de requette pour l affichage du tableau des CLs
function init_Tableau_CL(Tableau_CL_temp)
{
	//var Tableau_calcul_temp = eval('(' + response + ')');
    if (Tableau_CL_temp)
    {	
    	Tableau_CL_select_volume = new Array();
    	Tableau_CL = new Array();
    	for(j=0; j<Tableau_CL_temp.length ;j++){
			if(Tableau_CL_temp[j]['type']=='volume'){
				var taille_Tableau_CL_select_volume = Tableau_CL_select_volume.length;
				Tableau_CL_select_volume[taille_Tableau_CL_select_volume]=new Array();
				Tableau_CL_select_volume[taille_Tableau_CL_select_volume]=clone(Tableau_CL_temp[j]);
				Tableau_CL_select_volume[taille_Tableau_CL_select_volume]['select'] = false;
			}else{
				var taille_Tableau_CL = Tableau_CL.length;
				Tableau_CL[taille_Tableau_CL]=new Array();
				Tableau_CL[taille_Tableau_CL]=clone(Tableau_CL_temp[j]);
				Tableau_CL[taille_Tableau_CL]['id_select'] = '';
			}
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
	url_php = "./php/NC_etape_CLs/CLs.php";
	$.getJSON(url_php,init_Tableau_CL);
}


// traitement en fin de requette pour laffichage du tableau des bords
function init_Tableau_bords(Tableau_bords_temp)
{
	//var Tableau_calcul_temp = eval('(' + response + ')');
    if (Tableau_bords_temp)
    {	
    	Tableau_bords = clone(Tableau_bords_temp);
    }
    else
    {
    	Tableau_bords[0]= new Array();
        Tableau_bords[0]['name']='aucun calcul';
    }
    affiche_Tableau_bord();
}

// requette pour l'obtention du tableau des bords
function get_Tableau_bord()
{
	url_php = "./php/NC_model/bords.php";
	$.getJSON(url_php,init_Tableau_bords);
}


-->

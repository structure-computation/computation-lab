<!--
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
        Tableau_calcul[0]['name'] = 'aucun model';
    }
    //strtemp = array2json(Tableau_calcul); 
    //strtemp = Tableau_calcul[0]['name']; 
    //var id_test = document.getElementById("textetest"); 
    //remplacerTexte(id_test, strtemp);
    affiche_Tableau_calcul();
}


function get_Tableau_calcul()
{	
	var url_php = "/calcul/initialisation";
    $.getJSON(url_php,init_Tableau_calcul);
}


// traitement en fin de requette pour l'obtention du tableau des calcul
function init_Tableau_init(Tableau_init) 
{
	//var Tableau_calcul_temp = eval('(' + response + ')');
    if (Tableau_init)
    {	
    	Tableau_init_select = clone(Tableau_init);
    	Tableau_init_time_step = clone(Tableau_init['step']);
    }
    else
    {
    	Tableau_init_time_step[0]= new Array();
		Tableau_init_time_step[0]['name'] = 'step_0';
		Tableau_init_time_step[0]['t_step'] = '1';
		Tableau_init_time_step[0]['tf'] = '1';
		Tableau_init_time_step[0]['nb_t_step'] = '1';
    }
    affiche_Tableau_init_select();
}


function get_Tableau_init()
{
	url_php = "./php/NC_etape_initialisation/init.php";
	$.getJSON(url_php,init_Tableau_init);
}


-->
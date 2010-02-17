<!--
// traitement en fin de requette pour l affichage du tableau des liaisons
function init_Tableau_liaison(Tableau_liaison_temp)
{
	//var Tableau_calcul_temp = eval('(' + response + ')');
    if (Tableau_liaison_temp)
    {	
    	var taille_Tableau=Tableau_liaison_temp.length;
    	for(i=0; i<taille_Tableau; i++) {
    		Tableau_liaison[i]=Tableau_liaison_temp[i]['calcul_result'];
    	}
    }
    else
    {
    	Tableau_liaison[0]= new Array();
        Tableau_liaison[0]['name']='aucun calcul';
    }
    strtemp = Tableau_liaison[0]['name']; 
    var id_test = document.getElementById("textetest"); 
    remplacerTexte(id_test, strtemp);
    affiche_Tableau_liaison();
}

// requette pour l'obtention du tableau des liaison
function get_Tableau_liaison()
{
	var url_php = "/calcul/liaisons";
	$.getJSON(url_php,init_Tableau_liaison);
}

// traitement en fin de requette pour laffichage du tableau des interfaces
function init_Tableau_interfaces(Tableau_interfaces_temp)
{
	//var Tableau_calcul_temp = eval('(' + response + ')');
    if (Tableau_interfaces_temp)
    {	
    	Tableau_interfaces = clone(Tableau_interfaces_temp);
    }
    else
    {
    	Tableau_interfaces[0]= new Array();
        Tableau_interfaces[0]['name']='aucun calcul';
    }
    affiche_Tableau_interface();
}

// requette pour l'obtention du tableau des interfaces
function get_Tableau_interface()
{
	url_php = "./php/NC_model/interfaces.php";
	$.getJSON(url_php,init_Tableau_interfaces);
}


-->

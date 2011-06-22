<!--
// traitement en fin de requette pour laffichage du tableau des matériaux
function init_Tableau_mat(Tableau_mat_temp)
{
	//var Tableau_calcul_temp = eval('(' + response + ')');
    if (Tableau_mat_temp)
    {	
    	var taille_Tableau=Tableau_mat_temp.length;
    	for(i=0; i<taille_Tableau; i++) {
    		Tableau_mat[i]=Tableau_mat_temp[i]['material'];
    	}
    }
    else
    {
    	Tableau_mat[0]= new Array();
        Tableau_mat[0]['name']='aucun calcul';
    }
//    strtemp = Tableau_mat[0]['name']; 
//    var id_test = document.getElementById("textetest"); 
//    remplacerTexte(id_test, strtemp);
    affiche_Tableau_mat();
}

// requette pour l'obtention du tableau des matériaux
function get_Tableau_mat()
{
	var url_php = "/calcul/materiaux";
	$.getJSON(url_php,init_Tableau_mat);
}


// traitement en fin de requette pour laffichage du tableau des pieces
function init_Tableau_pieces(Tableau_pieces_temp)
{
	//var Tableau_calcul_temp = eval('(' + response + ')');
    if (Tableau_pieces_temp)
    {	
    	Tableau_pieces = clone(Tableau_pieces_temp);
    }
    else
    {
    	Tableau_pieces[0]= new Array();
        Tableau_pieces[0]['name']='aucun calcul';
    }
    affiche_Tableau_piece();
}

// requette pour l'obtention du tableau des pieces
function get_Tableau_piece()
{
	url_php = "./php/NC_model/pieces.php";
	$.getJSON(url_php,init_Tableau_pieces);
}

-->

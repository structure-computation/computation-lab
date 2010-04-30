// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la page entière 
// -------------------------------------------------------------------------------------------------------------------------------------------

// affichage de la page matériaux
function affiche_NC_page_previsions(){
	affich_prop_visu('visu');
	NC_current_page = 'page_previsions';
	affiche_NC_page('off','off');
	if(NC_current_scroll=='right'){
		NC_scroll(NC_current_scroll);
	}
	document.getElementById('NC_footer_top_init').className = 'off';
	document.getElementById('NC_footer_top_suiv').className = 'off';
	document.getElementById('NC_footer_top_valid').className = 'on';
}




// -------------------------------------------------------------------------------------------------------------------------------------------
// fonction util pour la validation et la génération du fichier json de calcul
// -------------------------------------------------------------------------------------------------------------------------------------------

function complete_calcul(){
	// id du model
	Tableau_calcul_complet['mesh'] = Tableau_id_model;
	// geometrie du model
	Tableau_calcul_complet['groups_elem'] = Tableau_pieces;
	Tableau_calcul_complet['groups_inter'] = Tableau_interfaces;
	Tableau_calcul_complet['groups_bords'] = Tableau_bords;
	// caractéristique matériaux, liaisons et CLs
	Tableau_calcul_complet['material'] = Tableau_mat_select;
	Tableau_calcul_complet['link'] = Tableau_liaison_select;
	Tableau_calcul_complet['CL'] = Tableau_CL_select;
	Tableau_calcul_complet['CL_volume'] = Tableau_CL_select_volume;
	// options du calcul
	Tableau_calcul_complet['options'] = Tableau_option_select;
	
	// génértion du json calcul complet
	Object_calcul_complet = new Object();
	Object_calcul_complet = array2object(Tableau_calcul_complet);
	fichier_calcul = $.toJSON(Object_calcul_complet);
	var send_calcul = new Object();
	send_calcul['file']=fichier_calcul;
	
	$.ajax({
	    url: "/calcul/create",
	    type: 'POST',
	    data: send_calcul,
	    success: function(json) {
		alert(json);
// 		$("#new_model_pic_wait").hide();
// 		$("#new_model_pic_ok").show();
	    }
	});
}







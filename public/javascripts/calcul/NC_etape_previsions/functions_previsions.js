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

	// traitement des tableaux pour les mettre au bon format
	// Tableau groups_elem
	var groups_elem = new Array();
	for(i in Tableau_pieces){
		groups_elem[i] = new Array();
		table_param = ["id","origine","identificateur","name","id_material"];
		for(j in table_param){
			if(table_param[j]=="id_material"){
				groups_elem[i]["id_material"]=Tableau_pieces[i]["assigned"]
			}else{
				groups_elem[i][table_param[j]]=Tableau_pieces[i][table_param[j]]
			}
		}
	}
	//alert(array2json(groups_elem));

	// Tableau groups_inter
	var groups_inter = new Array();
	for(i in Tableau_interfaces){
		groups_inter[i] = new Array();
		table_param = ["id","origine","identificateur","name","type","adj_num_group","id_link"];
		for(j in table_param){
			if(table_param[j]=="id_link"){
				groups_inter[i]["id_link"]=Tableau_interfaces[i]["assigned"]
			}else{
				groups_inter[i][table_param[j]]=Tableau_interfaces[i][table_param[j]]
			}
		}
	}
	//alert(array2json(groups_inter));

	// Tableau groups_edge
	var groups_edge = new Array();
	for(i in Tableau_bords){
		groups_edge[i] = new Array();
		table_param = ["id","origine","name","type","geometry","point_1","point_2","id_CL"];
		for(j in table_param){
			if(table_param[j]=="id_CL"){
				groups_edge[i]["id_CL"]=Tableau_bords[i]["assigned"]
			}else if(table_param[j]=="point_1"){
				groups_edge[i]["point_1"] = Tableau_bords[i]["point_1_x"] + ' ' + Tableau_bords[i]["point_1_y"]
			}else if(table_param[j]=="point_2"){
				groups_edge[i]["point_2"] = Tableau_bords[i]["point_2_x"] + ' ' + Tableau_bords[i]["point_2_y"]
			}else{
				groups_edge[i][table_param[j]]=Tableau_bords[i][table_param[j]]
			}
		}
	}
	//alert(array2json(groups_edge));

	Tableau_calcul_complet = new Array();
	// id du model
	Tableau_calcul_complet['mesh'] = Tableau_id_model;
	// geometrie du model
	Tableau_calcul_complet['groups_elem'] = groups_elem;
	Tableau_calcul_complet['groups_inter'] = groups_inter;
	Tableau_calcul_complet['groups_edge'] = groups_edge;
	// caractéristique matériaux, liaisons et CLs
	//Tableau_calcul_complet['materials'] = Tableau_mat_select;
	//Tableau_calcul_complet['link'] = Tableau_liaison_select;
	//Tableau_calcul_complet['CL'] = Tableau_CL_select;
	//Tableau_calcul_complet['CL_volume'] = Tableau_CL_select_volume;
	// options du calcul
	//Tableau_calcul_complet['options'] = Tableau_option_select;
	
	// génértion du json calcul complet
	Object_calcul_complet = new Object();
	Object_calcul_complet = array2object(Tableau_calcul_complet);
	fichier_calcul = $.toJSON(Object_calcul_complet);
	var send_calcul = new Object();
	send_calcul['file']=fichier_calcul;
	send_calcul['id_model']=model_id;
	
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







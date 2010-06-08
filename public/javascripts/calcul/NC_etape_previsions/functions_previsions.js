// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la page entière 
// -------------------------------------------------------------------------------------------------------------------------------------------

// affichage de la page matériaux
function affiche_NC_page_previsions(){
     if(NC_current_step >= 6){
	affich_prop_visu('visu');
	NC_current_page = 'page_previsions';
	affiche_NC_page('off','off');
	if(NC_current_scroll=='right'){
		NC_scroll(NC_current_scroll);
	}
	document.getElementById('NC_footer_top_init').className = 'off';
	document.getElementById('NC_footer_top_suiv').className = 'off';
	document.getElementById('NC_footer_top_valid').className = 'on';
    }else{
	alert('vous devez valider les étapes précédentes pour accéder à cette page');
    }
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
		table_param = ["id","origine","identificateur","name","id_material","assigned","group"];
		for(j in table_param){
			if(table_param[j]=="id_material"){
				groups_elem[i]["id_material"]=Tableau_pieces[i]["assigned"];
			}else{
				groups_elem[i][table_param[j]]=Tableau_pieces[i][table_param[j]];
			}
		}
	}
	//alert(array2json(groups_elem));

	// Tableau groups_inter
	var groups_inter = new Array();
	for(i in Tableau_interfaces){
		groups_inter[i] = new Array();
		table_param = ["id","origine","identificateur","name","type","adj_num_group","id_link","assigned","group"];
		for(j in table_param){
			if(table_param[j]=="id_link"){
				if(Tableau_interfaces[i]["assigned"]=='-1'){
					groups_inter[i]["id_link"]=parseFloat(Tableau_interfaces[i]["assigned"]);
				}else{
					groups_inter[i]["id_link"]=Tableau_interfaces[i]["assigned"];
				}
			}else if(table_param[j]=="assigned"){
				groups_inter[i][table_param[j]] = parseFloat(Tableau_interfaces[i][table_param[j]]);
			}else{
				groups_inter[i][table_param[j]]=Tableau_interfaces[i][table_param[j]];
			}
		}
	}
	//alert(array2json(groups_inter));

	// Tableau groups_edge
	var groups_edge = new Array();
	for(i in Tableau_bords){
		groups_edge[i] = new Array();
		table_param = ["id","origine","name","type","geometry","point_1_x","point_1_y","point_2_x","point_2_y","id_CL","assigned","group"];
		for(j in table_param){
			if(table_param[j]=="id_CL"){
				if(Tableau_bords[i]["assigned"]=='-1'){
					groups_edge[i]["id_CL"]=parseFloat(Tableau_bords[i]["assigned"]);
				}else{
					groups_edge[i]["id_CL"]=Tableau_bords[i]["assigned"];
				}
			}else if(table_param[j].match("point")){
				groups_edge[i][table_param[j]] = parseFloat(Tableau_bords[i][table_param[j]]);
			}else if(table_param[j]=="assigned"){
				groups_edge[i][table_param[j]] = parseFloat(Tableau_bords[i][table_param[j]]);
			}else{
				groups_edge[i][table_param[j]]=Tableau_bords[i][table_param[j]];
			}
		}
	}
	//alert(array2json(groups_edge));


	// Tableau materials
	var materials = new Array();
	for(i in Tableau_mat_select){
		materials[i] = new Array();
		table_param = ["id","groups_elem","mtype","comp","resolution","name","elastic_modulus","poisson_ratio","alpha","rho"];
		for(j in table_param){
			if(table_param[j]=="resolution"){
				materials[i]["resolution"]="CP"
			}else if(table_param[j]=="mtype"){
				materials[i]["mtype"] = Tableau_mat_select[i]["mtype"] ;
			}else if(table_param[j]=="comp"){
				materials[i]["comp"] = "elastique" ;
			}else if(table_param[j]=="elastic_modulus"){
				materials[i]["elastic_modulus"] = parseFloat(Tableau_mat_select[i]["E_1"]) ;
			}else if(table_param[j]=="poisson_ratio"){
				materials[i]["poisson_ratio"] = parseFloat(Tableau_mat_select[i]["mu_12"]) ;
			}else if(table_param[j]=="rho"){
				materials[i]["rho"] = parseFloat(Tableau_mat_select[i]["rho"]) ;
			}else if(table_param[j]=="alpha"){
				materials[i]["alpha"] = parseFloat(Tableau_mat_select[i]["alpha_1"]) ;
			}else if(table_param[j]=="groups_elem"){
				materials[i]["groups_elem"] = '';
				for(k in Tableau_mat_select[i]["pieces"]){
					materials[i]["groups_elem"] = materials[i]["groups_elem"] + Tableau_mat_select[i]["pieces"][k]['id'] + ' ';
				}
			}else if(table_param[j]=="id"){
				materials[i]["id"] = parseFloat(Tableau_mat_select[i]["id_select"]) ;
			}else{
				materials[i][table_param[j]]=Tableau_mat_select[i][table_param[j]]
			}
		}
	}
	//alert(array2json(materials));


	// Tableau proprietes_interfaces
	var liaisons = new Array();
	for(i in Tableau_liaison_select){
		proprietes_interfaces[i] = new Array();
		table_param = ["id","name","type","coef_frottement"];
		for(j in table_param){
			if(table_param[j]=="type"){
				if(Tableau_liaison_select[i]["comp_generique"] == 'Pa'){
					proprietes_interfaces[i]["type"] = 'parfait';
				}else if(Tableau_liaison_select[i]["comp_generique"] == 'Co'){
					proprietes_interfaces[i]["type"] = 'contact';
				}
			}else if(table_param[j]=="id"){
				proprietes_interfaces[i]["id"] = Tableau_liaison_select[i]["id_select"] ;
			}else if(table_param[j]=="coef_frottement"){
				proprietes_interfaces[i]["coef_frottement"] = parseFloat(Tableau_liaison_select[i]["f"]) ;
			}else{
				proprietes_interfaces[i][table_param[j]]=Tableau_liaison_select[i][table_param[j]];
			}
		}
	}
	//alert(array2json(proprietes_interfaces));
	
	// Tableau CL
	var CL = new Array();
	for(i in Tableau_CL_select){
		CL[i] = new Array();
		table_param = ["id","name","type","fct_spatiale_x","fct_spatiale_y","fct_temporelle_x","fct_temporelle_y"];
		for(j in table_param){
			if(table_param[j]=="type"){
				CL[i]["type"] = Tableau_CL_select[i]["bctype"] ;
			}else if(table_param[j]=="id"){
				CL[i]["id"] = Tableau_CL_select[i]["id_select"] ;
			}else if(table_param[j]=="fct_spatiale_x"){
				CL[i]["fct_spatiale_x"] = Tableau_CL_select[i]["step"][0]['Fx'] ;
			}else if(table_param[j]=="fct_spatiale_y"){
				CL[i]["fct_spatiale_y"] = Tableau_CL_select[i]["step"][0]['Fy'] ;
			}else if(table_param[j]=="fct_temporelle_x"){
				CL[i]["fct_temporelle_x"] = parseFloat(Tableau_CL_select[i]["step"][0]['ft']) ;
			}else if(table_param[j]=="fct_temporelle_y"){
				CL[i]["fct_temporelle_y"] = parseFloat(Tableau_CL_select[i]["step"][0]['ft']) ;
			}else{
				CL[i][table_param[j]]=Tableau_CL_select[i][table_param[j]];
			}
		}
	}
	//alert(array2json(CL));
	
	Tableau_calcul_complet = new Object();
	// id du model
	Tableau_calcul_complet['mesh'] = Tableau_id_model;
	// geometrie du model
	Tableau_calcul_complet['groups_elem'] = groups_elem;
	Tableau_calcul_complet['groups_inter'] = groups_inter;
	Tableau_calcul_complet['groups_edge'] = groups_edge;
	// caractéristique matériaux, liaisons et CLs
	Tableau_calcul_complet['materials'] = materials;
	Tableau_calcul_complet['links'] = liaisons;
	Tableau_calcul_complet['CL'] = CL;
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
	send_calcul['id_calcul']=Tableau_init_select['id'];
	//alert(Tableau_init_select['id']);
	
	$.ajax({
	    url: "/calcul/send_calcul",
	    type: 'POST',
	    data: send_calcul,
	    success: function(json) {
		alert(json);
	    }
	});
}







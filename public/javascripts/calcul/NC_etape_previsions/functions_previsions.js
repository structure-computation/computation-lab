// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la page entière 
// -------------------------------------------------------------------------------------------------------------------------------------------

// affichage de la page matériaux
function affiche_NC_page_previsions(){
     if(NC_current_step >= 6){
	complete_brouillon(false,true);
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

function lance_calcul(){
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
		table_param = ["id","origine","name","type","id_CL","assigned","group","pdirection_x","pdirection_y","pdirection_z","geometry","radius","equation","point_1_x","point_1_y","point_1_z","point_2_x","point_2_y","point_2_z"];
		for(j in table_param){
			if(table_param[j]=="id"){
				groups_edge[i][table_param[j]] = parseFloat(Tableau_bords[i][table_param[j]]);
			}else if(table_param[j]=="id_CL"){
				if(Tableau_bords[i]["assigned"]=='-1'){
					groups_edge[i]["id_CL"]=parseFloat(Tableau_bords[i]["assigned"]);
				}else{
					groups_edge[i]["id_CL"]=parseFloat(Tableau_bords[i]["assigned"]);
				}
			}else if(table_param[j].match("point")){
				groups_edge[i][table_param[j]] = Tableau_bords[i][table_param[j]].toString();
			}else if(table_param[j].match("pdirection")){
				groups_edge[i][table_param[j]] = Tableau_bords[i][table_param[j]].toString();
			}else if(table_param[j]=="assigned"){
				groups_edge[i][table_param[j]] = parseFloat(Tableau_bords[i][table_param[j]]);
			}else{
				groups_edge[i][table_param[j]]=Tableau_bords[i][table_param[j]].toString();
			}
		}
	}
	//alert(array2json(groups_edge));


	// Tableau materials
	var materials = new Array();
	for(i in Tableau_mat_select){
		materials[i] = new Array();
		table_param = ["id","type_num","mtype","comp","resolution","name","elastic_modulus","poisson_ratio","alpha","rho","viscosite","E1","E2","E3","G12","G13","G23","nu12","nu13","nu23","alpha_1","alpha_2","alpha_3","dir_1_x","dir_1_y","dir_1_z","dir_2_x","dir_2_y","dir_2_z","dir_3_x","dir_3_y","dir_3_z","Yo","Ysp","Yop","Yc","Ycp","b"];
		for(j in table_param){
			if(table_param[j]=="id"){
				materials[i]["id"] = parseFloat(Tableau_mat_select[i]["id_select"]) ;
			}else if(table_param[j]=="resolution"){
				materials[i]["resolution"]=Tableau_init_select['D2type'].toString() ;
			}else if(table_param[j]=="type_num"){
				materials[i]["type_num"] = parseFloat(Tableau_mat_select[i]["type_num"]) ;
			}else if(table_param[j]=="mtype"){
				materials[i]["mtype"] = Tableau_mat_select[i]["mtype"] ;
			}else if(table_param[j]=="comp"){
					materials[i]["comp"] = "";
				if (Tableau_mat_select[i]["comp"].match('el')){
					materials[i]["comp"] += "elastique ";
				}if (Tableau_mat_select[i]["comp"].match('pl')){
					materials[i]["comp"] += "plastique ";
				}if (Tableau_mat_select[i]["comp"].match('en')){
					materials[i]["comp"] += "endommageable ";
				}
			}
			
			else if(table_param[j]=="elastic_modulus"){
				materials[i]["elastic_modulus"] = Tableau_mat_select[i]["E_1"].toString() ;
			}else if(table_param[j]=="poisson_ratio"){
				materials[i]["poisson_ratio"] = Tableau_mat_select[i]["nu_12"].toString() ;
			}else if(table_param[j]=="rho"){
				materials[i]["rho"] = Tableau_mat_select[i]["rho"].toString() ;
			}else if(table_param[j]=="alpha"){
				materials[i]["alpha"] = Tableau_mat_select[i]["alpha_1"].toString() ;
			}
			
			else if(table_param[j]=="E1"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["E_1"].toString();
			}else if(table_param[j]=="E2"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["E_2"].toString();
			}else if(table_param[j]=="E3"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["E_3"].toString();
			}
			
			else if(table_param[j]=="G12"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["cis_1"].toString();
			}else if(table_param[j]=="G13"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["cis_2"].toString();
			}else if(table_param[j]=="G23"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["cis_3"].toString();
			}
			
			else if(table_param[j]=="nu12"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["nu_12"].toString();
			}else if(table_param[j]=="nu13"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["nu_23"].toString();
			}else if(table_param[j]=="nu23"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["nu_13"].toString();
			}
			
			else if(table_param[j]=="alpha_1"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["alpha_1"].toString();
			}else if(table_param[j]=="alpha_2"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["alpha_2"].toString();
			}else if(table_param[j]=="alpha_3"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["alpha_3"].toString();
			}
			
			else if(table_param[j]=="dir_1_x"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["dir_1_x"].toString();
			}else if(table_param[j]=="dir_1_y"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["dir_1_y"].toString();
			}else if(table_param[j]=="dir_1_z"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["dir_1_z"].toString();
			}else if(table_param[j]=="dir_2_x"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["dir_2_x"].toString();
			}else if(table_param[j]=="dir_2_y"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["dir_2_y"].toString();
			}else if(table_param[j]=="dir_2_z"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["dir_2_z"].toString();
			}else if(table_param[j]=="dir_3_x"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["dir_3_x"].toString();
			}else if(table_param[j]=="dir_3_y"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["dir_3_y"].toString();
			}else if(table_param[j]=="dir_3_z"){
				materials[i][table_param[j]] = Tableau_mat_select[i]["dir_3_z"].toString();
			}
			
			else if(table_param[j]=="Yo"){
				materials[i][table_param[j]] = "";
			}else if(table_param[j]=="Ysp"){
				materials[i][table_param[j]] = "";
			}else if(table_param[j]=="Yop"){
				materials[i][table_param[j]] = "";
			}else if(table_param[j]=="Yc"){
				materials[i][table_param[j]] = "";
			}else if(table_param[j]=="Ycp"){
				materials[i][table_param[j]] = "";
			}else if(table_param[j]=="b"){
				materials[i][table_param[j]] = "";
			}
			
			else if(table_param[j]=="groups_elem"){
				materials[i]["groups_elem"] = '';
				for(k in Tableau_mat_select[i]["pieces"]){
					materials[i]["groups_elem"] = materials[i]["groups_elem"] + Tableau_mat_select[i]["pieces"][k]['id'] + ' ';
				}
			}
			
			else{
				materials[i][table_param[j]]=Tableau_mat_select[i][table_param[j]];
			}
		}
	}
	//alert(array2json(materials));


	// Tableau proprietes_interfaces
	var liaisons = new Array();
	for(i in Tableau_liaison_select){
		liaisons[i] = new Array();
		table_param = ["id","type_num","name","type","comp_complexe","coef_frottement","Ep","jeux","R","Lp","Dp","p","Lr",];
		for(j in table_param){
			if(table_param[j]=="type"){
				if(Tableau_liaison_select[i]["comp_generique"] == 'Pa'){
					liaisons[i]["type"] = 'parfait';
				}else if(Tableau_liaison_select[i]["comp_generique"] == 'Co'){
					liaisons[i]["type"] = 'contact';
				}
			}else if(table_param[j]=="id"){
				liaisons[i]["id"] = parseFloat(Tableau_liaison_select[i]["id_select"]) ;
			}else if(table_param[j]=="type_num"){
				liaisons[i]["type_num"] = parseFloat(Tableau_liaison_select[i]["type_num"]) ;
			}else if(table_param[j]=="coef_frottement"){
				liaisons[i]["coef_frottement"] = Tableau_liaison_select[i]["f"].toString() ;
			}else{
				liaisons[i][table_param[j]]=Tableau_liaison_select[i][table_param[j]].toString();
			}
		}
	}
	//alert(array2json(proprietes_interfaces));
	
	// Tableau CL
	var CL = new Array();
	for(i in Tableau_CL_select){
		CL[i] = new Array();
		table_param = ["id","name","type","step","fct_spatiale_x","fct_spatiale_y","fct_spatiale_z","fct_temporelle_x","fct_temporelle_y","fct_temporelle_z",];
		for(j in table_param){
			if(table_param[j]=="type"){
				CL[i]["type"] = Tableau_CL_select[i]["bctype"] ;
			}else if(table_param[j]=="id"){
				CL[i]["id"] = Tableau_CL_select[i]["id_select"] ;
			}else if(table_param[j]=="step"){
				CL[i]["step"] = new Array();
				CL[i]["step"] = Tableau_CL_select[i]["step"] ;
				for(num_step in CL[i]["step"]){
					for(key1 in CL[i]["step"][num_step]){
						CL[i]["step"][num_step][key1] = CL[i]["step"][num_step][key1].toString() ;
					}
				}
			}else if(table_param[j]=="fct_spatiale_x"){
				CL[i]["fct_spatiale_x"] = Tableau_CL_select[i]["step"][0]['fct_spatiale_x'].toString();
			}else if(table_param[j]=="fct_spatiale_y"){
				CL[i]["fct_spatiale_y"] = Tableau_CL_select[i]["step"][0]['fct_spatiale_y'].toString();
			}else if(table_param[j]=="fct_spatiale_z"){
				CL[i]["fct_spatiale_z"] = Tableau_CL_select[i]["step"][0]['fct_spatiale_z'].toString();
			}else if(table_param[j]=="fct_temporelle_x"){
				CL[i]["fct_temporelle_x"] = Tableau_CL_select[i]["step"][0]['fct_temporelle_x'].toString() ;
			}else if(table_param[j]=="fct_temporelle_y"){
				CL[i]["fct_temporelle_y"] = Tableau_CL_select[i]["step"][0]['fct_temporelle_x'].toString() ;
			}else if(table_param[j]=="fct_temporelle_z"){
				CL[i]["fct_temporelle_z"] = Tableau_CL_select[i]["step"][0]['fct_temporelle_x'].toString() ;
			}else{
				CL[i][table_param[j]]=Tableau_CL_select[i][table_param[j]];
			}
		}
	}
	//alert(array2json(CL));
	
	
	// Tableau CLvolume
	var CLvolume = new Array();
	for(i in Tableau_CL_select_volume){
		CLvolume[i] = new Array();
		table_param = ["ref","name","type","step","select"];
		for(j in table_param){
			if(table_param[j]=="type"){
				CLvolume[i]["type"] = Tableau_CL_select_volume[i]["bctype"] ;
			}else if(table_param[j]=="ref"){
				CLvolume[i]["ref"] = Tableau_CL_select_volume[i]["ref"] ;
			}else if(table_param[j]=="select"){
				CLvolume[i]["select"] = Tableau_CL_select_volume[i]["select"].toString() ;
			}else if(table_param[j]=="step"){
				CLvolume[i]["step"] = new Array();
				CLvolume[i]["step"] = Tableau_CL_select_volume[i]["step"] ;
				for(num_step in CLvolume[i]["step"]){
					for(key1 in CLvolume[i]["step"][num_step]){
						CLvolume[i]["step"][num_step][key1] = CLvolume[i]["step"][num_step][key1].toString() ;
					}
				}
			}else{
				CLvolume[i][table_param[j]]=Tableau_CL_select_volume[i][table_param[j]];
			}
		}
	}
	//alert(array2json(CL));
	
	// Tableau Time_step
	var Time_step = new Array();
    for(i in Tableau_init_time_step ){
        Time_step[i] = new Array();
        table_param = ["id","PdT","name","nb_PdT","Tf","Ti"];
        for(j in table_param){
            if(table_param[j]=="name"){
                Time_step[i][table_param[j]] = Tableau_init_time_step[i][table_param[j]].toString();
            }else if(table_param[j]=="id"){
                Time_step[i][table_param[j]] = parseFloat(i);
            }else if(table_param[j]=="nb_PdT"){
                Time_step[i][table_param[j]] = Tableau_init_time_step[i][table_param[j]].toString();
            }else if(table_param[j]=="PdT"){
                Time_step[i][table_param[j]] = Tableau_init_time_step[i][table_param[j]].toString();
            }else{
                Time_step[i][table_param[j]] = parseFloat(Tableau_init_time_step[i][table_param[j]]);
            }
        }
    }
	
	// Tableau Option
	var Options = new Array();
	table_param = ["mode","nb_option","LATIN_conv","LATIN_nb_iter","PREC_nb_niveaux","PREC_erreur","PREC_boite","Crack","Dissipation","Temp_statique","2D_resolution"];
	for(j in table_param){
		if(table_param[j]=="LATIN_conv"){
			Options[table_param[j]] = Tableau_option_select[table_param[j]].toString();
		}else if(table_param[j]=="LATIN_nb_iter"){
			Options[table_param[j]] = Tableau_option_select[table_param[j]].toString();
		}else if(table_param[j]=="PREC_nb_niveaux"){
			Options[table_param[j]] = Tableau_option_select[table_param[j]].toString();
		}else if(table_param[j]=="PREC_erreur"){
			Options[table_param[j]] = Tableau_option_select[table_param[j]].toString();
		}else if(table_param[j]=="Dissipation"){
			Options[table_param[j]] = Tableau_option_select[table_param[j]].toString();
		}else if(table_param[j]=="2D_resolution"){
			Options["2D_resolution"] = Tableau_init_select['D2type'].toString() ;
		}else if(table_param[j]=="Temp_statique"){
			Options["Temp_statique"] = Tableau_init_select['ctype'].toString() ;
		}else{
			Options[table_param[j]] = Tableau_option_select[table_param[j]];
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
	Tableau_calcul_complet['CLvolume'] = CLvolume;
    // paramètres temporels et multirésolution
    Tableau_calcul_complet['time_step'] = Time_step;
	// options du calcul
	Tableau_calcul_complet['options'] = Options;
	
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
            alert("Demande de calcul envoyée. Vous allez être redirigé vers la page du modèle");
            var url_php = "/detail_model/index?id_model=" + model_id ;
            $(location).attr('href',url_php);
            
	    }
	});
}

// afficher le détail d'un modele
function go_detail_model(num){
    var num_select = content_tableau_connect['sc_model'][num];
    var id_model = Tableau_model_filter[num_select]['sc_model']['id'];
   
}


function complete_brouillon(interupteur, prevision){
	// tableau représentatn l'etat courant de l'interface
	var Tableau_current_stape_interface = new Array();
	Tableau_current_stape_interface['NC_current_step'] = NC_current_step;
	Tableau_current_stape_interface['compteur_mat_select'] = compteur_mat_select;
	Tableau_current_stape_interface['compteur_liaison_select'] = compteur_liaison_select;
	Tableau_current_stape_interface['compteur_CL_select'] = compteur_CL_select;
	Tableau_current_stape_interface['compteur_bords_test'] = compteur_bords_test;
	
	Tableau_calcul_complet = new Array();
	// etat de l'interface
	Tableau_calcul_complet['state'] = Tableau_current_stape_interface;
	
	// id du model
	Tableau_calcul_complet['mesh'] = Tableau_id_model;
	
	// geometrie du model
	Tableau_calcul_complet['groups_elem'] = Tableau_pieces;
	Tableau_calcul_complet['groups_inter'] = Tableau_interfaces;
	Tableau_calcul_complet['groups_edge'] =Tableau_bords;
	
	// caractéristique matériaux, liaisons et CLs
	Tableau_calcul_complet['materials'] = Tableau_mat_select;
	Tableau_calcul_complet['links'] = Tableau_liaison_select;
	Tableau_calcul_complet['CL'] = Tableau_CL_select;
	Tableau_calcul_complet['CL_volume'] = Tableau_CL_select_volume;
	Tableau_calcul_complet['time_step'] = Tableau_init_time_step;
    //alert(array2json(Tableau_init_time_step));
	Tableau_calcul_complet['options'] = Tableau_option_select;
	
	// pour l'affichage dans l'interface
	Tableau_calcul_complet['groupe_pieces'] = groupe_pieces;
	Tableau_calcul_complet['groupe_interfaces'] = groupe_interfaces;
	Tableau_calcul_complet['groupe_bords'] = groupe_bords;
	// options du calcul
	Tableau_calcul_complet['options'] = Tableau_option_select;
	
	// json
	fichier_calcul = array2json(Tableau_calcul_complet);

	var send_brouillon = new Object();
	send_brouillon['file']=fichier_calcul;
	send_brouillon['id_model']=model_id;
	send_brouillon['id_calcul']=Tableau_init_select['id'];
	//alert(Tableau_init_select['id']);
	
	$.ajax({
	    url: "/calcul/send_brouillon",
	    type: 'POST',
	    data: send_brouillon,
	    success: function(json) {
		if(interupteur){
			alert(json);
		}
		if(prevision){
			get_Tableau_previsions_calcul();
		}
	    }
	});
}


// -------------------------------------------------------------------------------------------------
// obtention des previsions de temps de calcul et de l'autorisation de calculer
// -------------------------------------------------------------------------------------------------

// traitement en fin de requette pour l'obtention du tableau des previsions et l'authorisation
function init_Tableau_previsions_calcul(Tableau_previsions_calcul_temp)
// function init_Tableau_model(response)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_previsions_calcul_temp){   
        Tableau_previsions_calcul = Tableau_previsions_calcul_temp;
    }
    //alert(array2json(Tableau_previsions_calcul_temp));
    affiche_Tableau_previsions_calcul();
}

function get_Tableau_previsions_calcul()
{
	//alert("dans get_Tableau_previsions_calcul");
	var send_data = new Object();
	send_data['id_model']=model_id;
	send_data['id_calcul']=Tableau_init_select['id'];
	
	$.ajax({
	    url: "/calcul/compute_previsions",
	    dataType: 'json',
	    type: 'POST',
	    data: send_data,
	    success: function(json) {
		init_Tableau_previsions_calcul(json);
	    }
	});
}

// afficher lee prévisions de calcul
function affiche_Tableau_previsions_calcul(){
	for(key in Tableau_previsions_calcul){
		if(key == 'launch_autorisation'){
			str_prevision = new String();
			str_prevision = 'NC_footer_bouton_lancer';
			var id_prevision = document.getElementById(str_prevision);
			if(Tableau_previsions_calcul[key]){
				remplacerTexte(id_prevision, "valider et envoyer");
			}else{
				remplacerTexte(id_prevision, "lancement non autorisé");
			}
		}else{
			str_prevision = new String();
			str_prevision = 'prevision_' + key;
			var id_prevision = document.getElementById(str_prevision);
			if(id_prevision != null){
				remplacerTexte(id_prevision, Tableau_previsions_calcul[key]);
			}
		}
	}
}

// -------------------------------------------------------------------------------------------------------------------------------------------
// fonction util pour la validation du calcul
// -------------------------------------------------------------------------------------------------------------------------------------------
function complete_calcul(){
    lance_calcul();
// 	if(Tableau_previsions_calcul['launch_autorisation']){
// 		lance_calcul();
// 	}else{
// 		alert("vous n'avez pas assez de jetons sur votre compte pour lancer ce calcul")
// 	}
}
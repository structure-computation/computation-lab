// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la page entière 
// -------------------------------------------------------------------------------------------------------------------------------------------

// affichage de la page matériaux
function affiche_NC_page_temporelle(){
    if(NC_current_step >= 2){
        NC_current_page = 'page_temporelle';
        affiche_NC_page('off','off');
        if(NC_current_scroll=='right'){
            NC_scroll(NC_current_scroll);
        }
        affich_prop_visu('prop');
        document.getElementById('NC_footer_top_init').className = 'off';
        document.getElementById('NC_footer_top_suiv').className = 'on';
        document.getElementById('NC_footer_top_valid').className = 'off';
        affiche_Tableau_init_time_step();
        //NC_scroll(NC_current_scroll);
        //setTimeout("NC_scroll(NC_current_scroll);",1000)
        //NC_scroll(NC_current_scroll);
    }else{
        alert('vous devez valider les étapes précédentes pour accéder à cette page');
    }
}

// rafraichiassement de la page matériaux
function refresh_NC_page_temporelle(){
    affiche_Tableau_init_time_step()
}

// affichage des boites d'option
function affich_box_temporelle(){
    str_id = "#NC_temporelle_active_box";
    str_id_triangle = "NC_top_box_temporelle";
    if(current_state_active_box_init=='off'){
        $(str_id).slideDown("slow",equal_height_NC_fake);
        id_triangle = document.getElementById(str_id_triangle); 
        id_triangle.className = 'NC_triangle_bas';
        current_state_active_box_init='on';
    }else if(current_state_active_box_init=='on'){
        $(str_id).slideUp("slow",equal_height_NC_fake);
        id_triangle = document.getElementById(str_id_triangle); 
        id_triangle.className = 'NC_triangle_cote';
        current_state_active_box_init='off';
    }
}

// -------------------------------------------------------------------------------------------------------------------------------------------
// fonctions utiles pour la box active, initialisation de time_step en rapport avec les conditions limites
// -------------------------------------------------------------------------------------------------------------------------------------------

// affichage des boites d'option
function affich_box_schema_temp(){
    str_id = "#NC_page_CLs_non_statique";
    str_id_triangle = "NC_page_CLs_non_statique_triangle" ;
    if(current_state_box_schema_temp=='off'){
        $(str_id).slideDown("slow",equal_height_NC_fake);
        id_triangle = document.getElementById(str_id_triangle); 
        id_triangle.className = 'NC_triangle_bas';
        current_state_box_schema_temp='on';
    }else if(current_state_box_schema_temp=='on'){
        $(str_id).slideUp("slow",equal_height_NC_fake);
        id_triangle = document.getElementById(str_id_triangle); 
        id_triangle.className = 'NC_triangle_cote';
        current_state_box_schema_temp='off';
    }
}

// mise a jour des valeur du tableau par l'utilisateur
function Tableau_schema_temp_change_value(){
    key = 'ctype' ;
    var strContent_init_key = 'init_' + key ;
    var id_init_key = document.getElementById(strContent_init_key);
    Tableau_init_select[key] = id_init_key.value  ;
//           id_schema_temp_key = document.getElementById('schema_temp_ctype');
//           remplacerTexte(id_schema_temp_key, Tableau_init_select[key]);
    for(i=0;i<Tableau_init_time_step.length;i++){
        for(key in Tableau_init_time_step[i]){
            var strContent_init_step_key = 'init_step_' + key + '_' + i ;
            var id_init_step_key = document.getElementById(strContent_init_step_key);
            if(id_init_step_key != null){
                Tableau_init_time_step[i][key] = id_init_step_key.value ;
            }
        }
    }
 affiche_Tableau_init_time_step();
}


// ajout d'un step par l'utilisateur
function Tableau_init_add_step(){
    taille_Tableau_init_time_step = Tableau_init_time_step.length ;
    Tableau_init_time_step[taille_Tableau_init_time_step] = new Array();
    if(taille_Tableau_init_time_step>0){
        Tableau_init_time_step[taille_Tableau_init_time_step] = clone(Tableau_init_time_step[taille_Tableau_init_time_step-1]);
    }else{
        Tableau_init_time_step[taille_Tableau_init_time_step] = clone(Tableau_init_time_step_temp);
    }
    
    // ajout du step de chargement à touts les CL
    for(i=0;i<Tableau_CL_select_volume.length;i++){
        Tableau_CL_select_volume[i]['step'][taille_Tableau_init_time_step] = clone(Tableau_CL_select_volume[i]['step'][taille_Tableau_init_time_step-1]);
    }
    for(i=0;i<Tableau_CL_select.length;i++){
        Tableau_CL_select[i]['step'][taille_Tableau_init_time_step] = clone(Tableau_CL_select[i]['step'][taille_Tableau_init_time_step-1]);//clone(Tableau_CL_step)
    }
    affiche_Tableau_init_time_step();
}


// suppression d'un step par l'utilisateur
function Tableau_init_suppr_step(step_select){
    if(step_select == 0){
        alert('vous ne pouvez pas supprimer le premier step de chargement');
    }else{
        Tableau_init_time_step.splice(step_select,1);
        
        // suppression du step de chargement à touts les CL
        for(i=0;i<Tableau_CL_select_volume.length;i++){
            Tableau_CL_select_volume[i]['step'].splice(step_select,1);
        }
        for(i=0;i<Tableau_CL_select.length;i++){
            Tableau_CL_select[i]['step'].splice(step_select,1);
        }
    }
    
    affiche_Tableau_init_time_step();
    //alert('affiche_Tableau_init_time_step 2');
}


// affichage du tableau des step de chargement de la boite active temporelle
function affiche_Tableau_init_time_step(){
    str_id_non_statique = "NC_init_non_statique";
    var id_non_statique = document.getElementById(str_id_non_statique);
    //alert(Tableau_init_select['ctype']);
    if(Tableau_init_select['ctype'] == 'statique'){
        id_non_statique.className = 'on' ;
        Tableau_init_time_step.length = 1 ;
        for(i=0;i<Tableau_CL_select_volume.length;i++){
            Tableau_CL_select_volume[i]['step'].length = 1 ;
        }
        for(i=0;i<Tableau_CL_select.length;i++){
            Tableau_CL_select[i]['step'].length = 1 ;
        }
    }else{
        id_non_statique.className = 'on' ;
    }
    for(i=0;i<20;i++){
        // on affiche la ligne line_step de la page init
        var strContent_init_step_line = 'init_line_step_' + i ;
        var id_init_step_line = document.getElementById(strContent_init_step_line);
        // on affiche le lignes prop_CL_step de la page prop_CL
        var strContent_prop_CL_step = 'prop_CL_step_' + i ;
        var id_prop_CL_step = document.getElementsByName(strContent_prop_CL_step);
        
        if(i<Tableau_init_time_step.length){
            for(nstep=0; nstep<id_prop_CL_step.length; nstep++){
                id_prop_CL_step[nstep].className = 'NC_prop_line_top on' ;
            }
            if(pair(i)){
                id_init_step_line.className = "NC_init_table_step_lign pair";
            }else{
                id_init_step_line.className = "NC_init_table_step_lign impair";
            }
            Tableau_init_time_step[i]['name'] = 'step_' + i ;
            if(i == 0){
                Tableau_init_time_step[i]['Ti'] = 0 ;
            }else{
                Tableau_init_time_step[i]['Ti'] = Tableau_init_time_step[i-1]['Tf'] ;
            }
            Tableau_init_time_step[i]['Tf'] = Tableau_init_time_step[i]['Ti'] + Tableau_init_time_step[i]['PdT'] *  Tableau_init_time_step[i]['nb_PdT'];
            
            
            for(key in Tableau_init_time_step[i]){
                var strContent_init_step_key = 'init_step_' + key + '_' + i ;
                var id_init_step_key = document.getElementById(strContent_init_step_key);
                if(id_init_step_key != null){
                    id_init_step_key.value = Tableau_init_time_step[i][key] ;
                }
            }
        }else{
            id_init_step_line.className = "NC_init_table_step_lign off";
            for(nstep=0; nstep<id_prop_CL_step.length; nstep++){
                id_prop_CL_step[nstep].className = 'NC_prop_line_top off' ;
            }
        }
    }
    equal_height_NC_fake(); 
}
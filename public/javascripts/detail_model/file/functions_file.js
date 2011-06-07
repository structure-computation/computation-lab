//-------------------------------------------------------------------------------------------------
// fonctions utiles pour l'obtention de la liste des files (tableau)
//-------------------------------------------------------------------------------------------------
// traitement en fin de requette pour laffichage du tableau des files
function init_Tableau_file(Tableau_file_temp)
{
    // var Tableau_calcul_temp = eval('[' + response + ']');
    if (Tableau_file_temp)
    {   
        Tableau_file = Tableau_file_temp;
    }
    else
    {
        Tableau_file[0]         =  new Array();
        Tableau_file[0]['name'] = 'aucun résultat disponnible';
    }
    //alert(array2json(Tableau_file));
    affiche_Tableau_file();
}
// requette pour l'obtention du tableau des files
function get_Tableau_file(id_model)
{ 
    var url_php = "/detail_model/get_list_file";
    $.getJSON(url_php,{"id_model": id_model},init_Tableau_file);
}

// filtre du tableau
function filtre_Tableau_file(){
    //Tableau_file_filter = Tableau_file;
    Tableau_file_filter = new Array();
    for(i=0; i<Tableau_file.length; i++) {
       if(Tableau_file[i]['files_sc_model']['state']=='temp' || Tableau_file[i]['files_sc_model']['state']=='deleted'){
          //Tableau_file_filter.push(Tableau_file[i]);
       }else{
          Tableau_file_filter.push(Tableau_file[i]);
       }
    }
}

// affichage du tableau decompte calcul
function affiche_Tableau_file(){
    filtre_Tableau_file();
    taille_tableau_content  =  taille_tableau_content_page['file'];
    var current_tableau     =  Tableau_file_filter;
    var strname             =  'file';
    var strnamebdd          =  'files_sc_model';
    var stridentificateur   =  new Array('created_at','name');
    affiche_Tableau_content(current_tableau, strname, strnamebdd, stridentificateur);
//     complete_affiche_Tableau_file(current_tableau, strname, strnamebdd);
}

// // complément pour l'affichage des résultats. changement de couleur en fonction du status... 
// function complete_affiche_Tableau_file(current_tableau, strname, strnamebdd){
//     var taille_Tableau=current_tableau.length;
//     for(i=0; i<taille_tableau_content; i++) {
//         i_page = i + content_tableau_current_page[strname] * taille_tableau_content;
//         content_tableau_connect[strname][i]=i_page;
//         
//         strContent_lign = strname + '_lign_' + i;
//         strContent_pair = strname + '_pair_' + i;
//         strContent = 'file_4_' + i;
//         //alert(strContent_lign);
//         var id_lign  = document.getElementById(strContent_lign);
//         var id_pair  = document.getElementById(strContent_pair);
//         var idContent = document.getElementById(strContent);
//         
//         if(i_page<taille_Tableau){
//             id_lign.className = "contentBoxTable_lign on";
//             if(current_tableau[i_page][strnamebdd]['state']=='in_process'){
//                 id_pair.className = "contentBoxTable_lign_in_process";
//                 strtemp = 'process' ;
//                 remplacerTexte(idContent, strtemp);
//             }else if(current_tableau[i_page][strnamebdd]['state']=='echec'){
//                 id_pair.className = "contentBoxTable_lign_echec";
//                 strtemp = 'echec' ;
//                 remplacerTexte(idContent, strtemp);
//             }else{
//                 strtemp = '' ;
//                 remplacerTexte(idContent, strtemp);
//             }
//         }else{
//             id_lign.className = "contentBoxTable_lign off";
//         }
//     }
// }

// telecharger le file
function download_file(num){
    var num_select = content_tableau_connect['file'][num];
    var id_file = Tableau_file_filter[num_select]['files_sc_model']['id'];
    if(Tableau_file_filter[num_select]['files_sc_model']['state']=='uploaded'){
        var url_php = "/detail_model/download_file?id_model=" + model_id + "&id_file=" + id_file ;
        $(location).attr('href',url_php);  
    }else{
        alert('aucun fichier à télécharger');
    }
}


//---------------------------------------------------------------------------------------------------------
// wizard de suppression du file ou calcul
//---------------------------------------------------------------------------------------------------------

// affichage du cache noir et du wizard suppression
function displayDeleteFile(interupteur) {
    displayBlack(interupteur);
    document.getElementById('Delete_wiz_layer_file').className = "Delete_wiz_layer " + interupteur;
    
    document.getElementById('Delete_model_pic').className    =  'on' ;
    document.getElementById('Delete_model_pic_wait').className    =  'off' ;
    document.getElementById('Delete_model_pic_ok').className    =  'off' ;
    document.getElementById('Delete_model_pic_failed').className    =  'off' ;
    
    document.getElementById('Delete_wiz_annul').className    =  'left on' ;
    document.getElementById('Delete_wiz_delete').className    =  'right on' ;
    document.getElementById('Delete_wiz_close').className    =  'right off' ;
}

// fonction appellé à partir du tableau des modèles
function delete_file(num){
    var num_select = content_tableau_connect['file'][num];
    num_delete_file = num_select;
    var id_file = Tableau_file_filter[num_select]['files_sc_model']['id'];
    displayDeleteFile('on');
    var table_detail = Tableau_file_filter[num_select]['files_sc_model'];
    for(key in table_detail){
        var strContent_detail_key = 'file_delete_' + key ;
        var id_detail_key = document.getElementById(strContent_detail_key);
        if(id_detail_key != null){
            strContent = new String();
            strContent = table_detail[key];
            //id_detail_key.value = Tableau_model_filter[num_select][key] ;
            remplacerTexte(id_detail_key, strContent);
        }
    }
}

// validation de la suppression
function valid_delete_file(){
    var id_file = Tableau_file_filter[num_delete_file]['files_sc_model']['id'];
    document.getElementById('Delete_model_pic').className    =  'off' ;
    document.getElementById('Delete_model_pic_wait').className    =  'on' ;
    
    document.getElementById('Delete_wiz_delete').className    =  'right off' ;
    document.getElementById('Delete_wiz_close').className    =  'right on' ;
    
    var url_php = "/detail_model/delete_file";
    $.get(url_php,{"id_model": model_id, "id_file": id_file},file_delete);
}

// résultat de la requette de suppression
function file_delete(file){
    document.getElementById('Delete_model_pic_wait').className    =  'off' ;
    if(file == "true"){
      document.getElementById('Delete_model_pic_ok').className    =  'on' ;
      document.getElementById('Delete_model_pic_failed').className    =  'off' ;  
      get_Tableau_file(model_id);
    }else if(file == "false"){
      document.getElementById('Delete_model_pic_ok').className    =  'off' ;
      document.getElementById('Delete_model_pic_failed').className    =  'on' ;
    }
}
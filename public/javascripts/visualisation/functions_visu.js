<!--

var image_3d;
var image_3d_shrink_on = false;
var num_group_info;
var select_num_group_info = new Array();
var id_piece_select_for_visu = new Array();
var id_interface_select_for_visu = new Array();

//------------------------------------------------------------------------------------------------------
// initialisation du serveur d'image en relation aves ImgServer.js
//------------------------------------------------------------------------------------------------------

function refresh_page(){
    var url_php = "visualisation/index?id_model=" + model_id ;
    $(location).attr('href',url_php);   
}

function launch_visu_server(){
    var url_php = "/visualisation/launch_visu_server";
    $.getJSON(url_php,function() {
            alert("serveur launch");
        });
    timer = setTimeout(refresh_page(),2000);    //Toute les 40 ms
}


// function init_visualisation() {
//     image_3d = new ImgServer( "my_canvas", "00" );
//     strgeom = new String();
//     strgeom = '/share/sc2/Developpement/MODEL/model_' + model_id + '/MESH/visu_geometry.h5';
//     //strgeom = '/share/sc2/Developpement/MODEL/model_14/MESH/visu_geometry.h5';
//     namegeom = new String();
//     namegeom = 'Level_0/Geometry';
//     
//     image_3d.load_hdf( strgeom, namegeom );
//     //image_3d.load_vtu( "/var/www/Visu/data/geometry_all_0_0.vtu" );
//     //image_3d.load_vtu( "/var/www/Visu/data/manchon.vtu" );
//     //     alert(s);
//     //image_3d.load_vtu( "/home/jbellec/Dropbox/SC/Inbox/fibres_mat/calcul_97/resultat_0_0.vtu" );
//     //image_3d.load_vtu("/var/www/Visu/data/croix.vtu" );
//     
//     //image_3d.color_by_field( "epsilon", 1 );
//     //image_3d.shrink( 0.05 );
//     image_3d.fit();
//     image_3d.get_num_group_info( "num_group_info" );
//     image_3d.render();
// }

function init_visualisation() {
    image_3d = new ScDisp( "my_canvas");
    strgeom = new String();
    strgeom = '/share/sc2/Developpement/MODEL/model_' + model_id + '/MESH/visu_geometry.h5';
    namegeom = new String();
    namegeom = 'Level_0/Geometry';
    image_3d.add_item(new ScItem_GradiendBackground([[0.0, "rgb( 0, 0,   0 )"], [0.5, "rgb( 0, 0,  40 )"], [1.0, "rgb( 0, 0, 200 )"]]));
    m = new ScItem_Model();
    item_id = m.item_id;
    
    m.load_hdf( strgeom, namegeom );
    
    m.get_info();
    m.get_num_group_info( "num_group_info" ); 
    m.fit();
    image_3d.add_item(m);
    image_3d.add_item(new ScItem_Axes("lb"));
    image_3d.click_fun.push( function( disp, evt ) {
        num_list = disp.get_num_group( evt.clientX, evt.clientY );
        select_on_table(num_list);
    } );
}

//------------------------------------------------------------------------------------------------------
// bouton de la fenetre de visualisation
//------------------------------------------------------------------------------------------------------

function fit_img( c ) {
    image_3d.fit();
}

function sx( c, x, y ) { 
    image_3d.set_XY(x,y);
}

function shrink( c, s ){
    if(image_3d_shrink_on){
      s = 0.;
      image_3d_shrink_on = false;
    }else{
      s = 0.05;
      image_3d_shrink_on = true;
    }
    image_3d.shrink(s);
}

function dec_alpha( c, v, d ) {
    //alert("dec_alpha");
    var s = document.getElementById(c).img_server;
    //if ( s.alpha_altc <= v ) return;
    s.alpha_altc -= d;
    s.draw_img_on_canvas();
    //setTimeout( function() { dec_alpha( c, v, d ) }, 15 );
}
function inc_alpha( c, v, d ) {
    var s = document.getElementById(c).img_server;
    if ( s.alpha_altc >= v ) return;
    s.alpha_altc += d;
    s.draw_img_on_canvas();
    setTimeout( function() { inc_alpha( c, v, d ) }, 15 );
}


//------------------------------------------------------------------------------------------------------
// interaction tableau, canvas
//------------------------------------------------------------------------------------------------------


function select_on_table(num_list){
    //alert(num_list);
//     alert("fin num_list")
    if(num_group_info[ num_list ]){
//         alert(num_group_info[ num_list ].type);
//         alert("fin type")
        // alert(array2json(num_group_info));
        // alert(array2json(Tableau_interfaces));
        if(num_group_info[ num_list ].type == 0){
            var id_entity = num_group_info[ num_list ].id_edge_of[0];
            //alert(id_entity);
            active_piece(id_entity);
            
        }else if(num_group_info[ num_list ].type == 2){
            var id_entity = num_group_info[ num_list ].id;
//             alert(id_entity);
//             alert("fin id_entity")
            active_interface(id_entity);
//             alert("fin active_interface")
        }
    }
//     alert("fin select")
}


//------------------------------------------------------------------------------------------------------
// affichage des pieces sur le canvas
//------------------------------------------------------------------------------------------------------

function find_id_in_id_piece_select_for_visu(id){
    id_find = false;
    for( var x = 0; x < Tableau_pieces.length; ++x ) {
        if(Tableau_pieces[ x ].id == id && id_piece_select_for_visu[ x ] == true){
            id_find = true;
            return id_find;
        }
    }
    return id_find;
}


function all_piece_select_for_visu() {
    for( var i_piece = 0; i_piece < Tableau_pieces.length; ++i_piece ) {
        id_piece_select_for_visu[ i_piece ] = true;
    }
    make_select_num_group_info_piece(); 
}

function add_remove_id_piece_select_for_visu(id) {
    for( var i_piece = 0; i_piece < Tableau_pieces.length; ++i_piece ) {
        if(Tableau_pieces[ i_piece ].id == id){
            if(id_piece_select_for_visu[ i_piece ]){
                id_piece_select_for_visu[ i_piece ] = false;
            }else{
                id_piece_select_for_visu[ i_piece ] = true;
            }
        }
    }
    make_select_num_group_info_piece(); 
}

function add_remove_only_id_piece_select_for_visu(id) {
    for( var i_piece = 0; i_piece < Tableau_pieces.length; ++i_piece ) {
        if(Tableau_pieces[ i_piece ].id == id){
            id_piece_select_for_visu[ i_piece ] = true;
        }else{
            id_piece_select_for_visu[ i_piece ] = false;
        }
    }
    make_select_num_group_info_piece(); 
}

function make_select_num_group_info_piece(){
    for( var x = 0; x < num_group_info.length; ++x ) {
        select_num_group_info[ x ] = false;
        for( var i_piece = 0; i_piece < Tableau_pieces.length; ++i_piece ) {
            id_piece_ = Tableau_pieces[ i_piece ].id;
            for(var id_piece in num_group_info[ x ].id_edge_of){
                if( num_group_info[ x ].id_edge_of[id_piece] == id_piece_ && num_group_info[ x ].type!= 1) { 
                    if(id_piece_select_for_visu[ i_piece ]){
                      select_num_group_info[ x ] = true;
                      break;
                    }
                }
            }
        }
    }
}

function filter_pieces() {
    all_piece_select_for_visu();
    make_filter();
    change_eyes_view_piece();
}

function filter_piece_id(id) {
    add_remove_id_piece_select_for_visu(id);
    make_filter();
}

function filter_piece_only_id(id) {
    add_remove_only_id_piece_select_for_visu(id);
    make_filter();
}

//------------------------------------------------------------------------------------------------------
// affichage des interfaces sur le canvas
//------------------------------------------------------------------------------------------------------

function find_id_in_id_interface_select_for_visu(id){
    id_find = false;
    for( var x = 0; x < Tableau_interfaces.length; ++x ) {
        if(Tableau_interfaces[ x ].id == id && id_interface_select_for_visu[ x ] == true){
            id_find = true;
            return id_find;
        }
    }
    return id_find;
}

function all_interface_select_for_visu() {
    for( var i_inter = 0; i_inter < Tableau_interfaces.length; ++i_inter ) {
        id_interface_select_for_visu[ i_inter ] = true;
    }
    make_select_num_group_info_interface();
}

function add_remove_id_interface_select_for_visu(id) {
    for( var i_inter = 0; i_inter < Tableau_interfaces.length; ++i_inter ) {
        if(Tableau_interfaces[ i_inter ].id == id){
            if(id_interface_select_for_visu[ i_inter ]){
                id_interface_select_for_visu[ i_inter ] = false;
            }else{
                id_interface_select_for_visu[ i_inter ] = true;
            }
        }
    }
    make_select_num_group_info_interface();
}

function add_remove_only_id_interface_select_for_visu(id) {
    for( var i_inter = 0; i_inter < Tableau_interfaces.length; ++i_inter ) {
        if(Tableau_interfaces[ i_inter ].id == id){
            id_interface_select_for_visu[ i_inter ] = true;
        }else{
            id_interface_select_for_visu[ i_inter ] = false;
        }
    }
    make_select_num_group_info_interface();
}

function make_select_num_group_info_interface(){
    for( var x = 0; x < num_group_info.length; ++x ) {
        select_num_group_info[ x ] = false;
        for( var i_inter = 0; i_inter < Tableau_interfaces.length; ++i_inter ) {
            id_interface_ = Tableau_interfaces[ i_inter ].id;
            if( num_group_info[ x ].id == id_interface_ && num_group_info[ x ].type == 2) { 
                if(id_interface_select_for_visu[ i_inter ]){
                  select_num_group_info[ x ] = true;
                  break;
                }
            }
        }
    }
}

function filter_interfaces() {
    all_interface_select_for_visu();
    make_filter();
    change_eyes_view_interface();  
}

function filter_interface_id(id) {
    add_remove_id_interface_select_for_visu(id);
    make_filter();
}

function filter_interface_only_id(id) {
    add_remove_only_id_interface_select_for_visu(id);
    make_filter();
}

function make_filter() {
    var filter = "";
    for( var x = 0; x < num_group_info.length; ++x ) {
        if ( !select_num_group_info[ x ] ) { 
            if ( filter.length )
                filter += " or ";
            filter += " num_group == " + x;
        }
    }
    image_3d.set_elem_filter( filter ) 
}

-->
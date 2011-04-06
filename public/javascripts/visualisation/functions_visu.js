<!--

//------------------------------------------------------------------------------------------------------
// initialisation du serveur d'image en relation aves ImgServer.js
//------------------------------------------------------------------------------------------------------

var num_group_info;

function init_visualisation() {
    image_3d = new ImgServer( "my_canvas", "00" );
    strgeom = new String();
    strgeom = '/share/sc2/Developpement/MODEL/model_' + model_id + '/MESH/visu_geometry.h5';
    //strgeom = '/share/sc2/Developpement/MODEL/model_14/MESH/visu_geometry.h5';
    namegeom = new String();
    namegeom = 'Level_0/Geometry';
    
    image_3d.load_hdf( strgeom, namegeom );
    //image_3d.load_vtu( "/var/www/Visu/data/geometry_all_0_0.vtu" );
    //image_3d.load_vtu( "/var/www/Visu/data/manchon.vtu" );
    //     alert(s);
    //image_3d.load_vtu( "/home/jbellec/Dropbox/SC/Inbox/fibres_mat/calcul_97/resultat_0_0.vtu" );
    //image_3d.load_vtu("/var/www/Visu/data/croix.vtu" );
    
    //image_3d.color_by_field( "epsilon", 1 );
    //image_3d.shrink( 0.05 );
    image_3d.fit();
    image_3d.get_num_group_info( "num_group_info" );
    image_3d.render();
}

function fit_img( c ) {
    var s = document.getElementById(c).img_server;
    s.fit();
    s.render();
}

function sx( c, x, y ) { 
    var s = document.getElementById(c).img_server; 
    s.set_XY(x,y); 
    s.render(); 
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

function filter_interfaces(c) {
    //alert(num_group_info[0].type);
    var filter = "";
    for( var x = 0; x < num_group_info.length; ++x ) {
        if ( num_group_info[ x ].type == 0 ) { 
            if ( filter.length )
                filter += " or ";
            filter += " num_group == " + x;
        }
    }
    
    //s.set_XY( [1,0,0], [0,1,0] );
    if ( filter.length ) {
        var s = document.getElementById(c).img_server;
        s.set_elem_filter( filter );
        s.fit();
        s.render();
        //alert(filter);
    }
}

function filter_pieces(c) {
    //alert(num_group_info[0].type);
    var filter = "";
    for( var x = 0; x < num_group_info.length; ++x ) {
        if ( num_group_info[ x ].type == 2 ) { 
            if ( filter.length )
                filter += " or ";
            filter += " num_group == " + x;
        }
    }
    
    //s.set_XY( [1,0,0], [0,1,0] );
    if ( filter.length ) {
        var s = document.getElementById(c).img_server;
        s.set_elem_filter( filter );
        s.fit();
        s.render();
        //alert(filter);
    }
}


-->
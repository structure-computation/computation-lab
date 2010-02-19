var old_x = 0, old_y = 0;
var button = "none";
var delay_send = 100;
var want_z_sorting = false;
var max_time_for_img_disp = 100;
var address_php = "/usr/lib/cgi-bin/imgserver.cgi";
// about:config -> middlemouse.contentLoadURL;false

function pos_part( x ) { if ( x >= 0 ) return x; return 0; }
function eqz( x ) { return x == 0; }
function pow( x, y ) { return Math.pow( x, y ); }
function sin( x ) { return Math.sin( x ); }
function cos( x ) { return Math.cos( x ); }
function abs( x ) { return Math.abs( x ); }


function my_xml_http_request() {
    if( window.XMLHttpRequest ) // Firefox
        return new XMLHttpRequest();
    if ( window.ActiveXObject ) // Internet Explorer
        return new ActiveXObject("Microsoft.XMLHTTP");
    alert("Votre navigateur ne supporte pas les objets XMLHTTPRequest...");
}

function send_async_xml_http_request( url, func ) {
    var xhr_object = my_xml_http_request();
    xhr_object.open( "GET", url, true );
    xhr_object.onreadystatechange = function() {
        if( this.readyState == 4 && this.status == 200 )
            func( this.responseText );
 	if( this.readyState == 4 && this.status != 200 )
            alert('pas de reponse');
    };
    xhr_object.send( null );
}

function get_eye_pos( cam_data ) {
    return [
        cam_data.C[0] - cam_data.Z[0] * cam_data.R * ( 1.0 + 1.0 / ( cam_data.perspective + 1e-6 ) ),
        cam_data.C[1] - cam_data.Z[1] * cam_data.R * ( 1.0 + 1.0 / ( cam_data.perspective + 1e-6 ) ),
        cam_data.C[2] - cam_data.Z[2] * cam_data.R * ( 1.0 + 1.0 / ( cam_data.perspective + 1e-6 ) )
    ];
}

function update_trans( cam_data, width, height ) {
    cam_data.width  = width;
    cam_data.height = height;

    var R0 = cam_data.X[0]; var R1 = cam_data.zoom; var R2 = cam_data.height; var R3 = cam_data.width; var R4 = R2-R3; var R5 = pos_part(R4);
    var R6 = R2-R5; var R7 = R1*R6; var R8 = R0*R7; var R9 = 1.0/R3; var R10 = R8*R9; var R11 = cam_data.offset_x;
    var R12 = cam_data.Z[0]; var R13 = cam_data.perspective; var R14 = R12*R13; var R15 = R11*R14; var R16 = R10+R15; var R17 = cam_data.R;
    var R18 = 1.0/R17; var R19 = R16*R18; var trans_0 = R19; var R20 = cam_data.Z[1]; var R21 = R11*R13; var R22 = R20*R21;
    var R23 = cam_data.X[1]; var R24 = R23*R7; var R25 = R24*R9; var R26 = R22+R25; var R27 = R26*R18; var trans_1 = R27;
    var R28 = cam_data.X[2]; var R29 = R28*R7; var R30 = R29*R9; var R31 = cam_data.Z[2]; var R32 = R31*R13; var R33 = R11*R32;
    var R34 = R30+R33; var R35 = R34*R18; var trans_2 = R35; var R36 = cam_data.C[1]; var R37 = R36*R26; var R38 = cam_data.C[0];
    var R39 = R38*R16; var R40 = cam_data.C[2]; var R41 = R40*R34; var R42 = R37+R39+R41; var R43 = -R42; var R44 = R43*R18;
    var R45 = 1; var R46 = R45+R13; var R47 = R11*R46; var R48 = R44+R47; var trans_3 = R48; var R49 = cam_data.offset_y;
    var R50 = R49*R13; var R51 = R12*R50; var R52 = cam_data.Y[0]; var R53 = R52*R7; var R54 = 1.0/R2; var R55 = R53*R54;
    var R56 = R51+R55; var R57 = R56*R18; var trans_4 = R57; var R58 = cam_data.Y[1]; var R59 = R58*R7; var R60 = R59*R54;
    var R61 = R20*R50; var R62 = R60+R61; var R63 = R62*R18; var trans_5 = R63; var R64 = cam_data.Y[2]; var R65 = R64*R7;
    var R66 = R65*R54; var R67 = R31*R50; var R68 = R66+R67; var R69 = R68*R18; var trans_6 = R69; var R70 = R49*R46;
    var R71 = R38*R56; var R72 = R40*R68; var R73 = R36*R62; var R74 = R71+R72+R73; var R75 = -R74; var R76 = R75*R18;
    var R77 = R70+R76; var trans_7 = R77; var R78 = R12*R18; var trans_8 = R78; var R79 = R20*R18; var trans_9 = R79;
    var R80 = R31*R18; var trans_10 = R80; var R81 = R12*R38; var R82 = R20*R36; var R83 = R31*R40; var R84 = R81+R82+R83;
    var R85 = -R84; var R86 = R85*R18; var trans_11 = R86; var R87 = R14*R18; var trans_12 = R87; var R88 = R20*R13;
    var R89 = R88*R18; var trans_13 = R89; var R90 = R32*R18; var trans_14 = R90; var R91 = R45+R86; var R92 = R13*R91;
    var R93 = R45+R92; var trans_15 = R93;  /* 77 instructions */

    cam_data.trans = [ trans_0, trans_1, trans_2, trans_3, trans_4, trans_5, trans_6, trans_7, trans_8, trans_9, trans_10, trans_11, trans_12, trans_13, trans_14, trans_15];
}

function rotate( cam_data, dx, dy, dz ) {
    var w2 = cam_data.width  / 2.0;
    var h2 = cam_data.height / 2.0;
    var offset_x_img = cam_data.offset_x_img - w2;
    var offset_y_img = cam_data.offset_y_img - h2;
    cam_data.offset_x_img = w2 + Math.cos( dz ) * offset_x_img - Math.sin( dz ) * offset_y_img;
    cam_data.offset_y_img = h2 + Math.sin( dz ) * offset_x_img + Math.cos( dz ) * offset_y_img;

    var offset_x = + Math.cos( dz ) * cam_data.offset_x * w2 + Math.sin( dz ) * cam_data.offset_y * h2;
    var offset_y = - Math.sin( dz ) * cam_data.offset_x * w2 + Math.cos( dz ) * cam_data.offset_y * h2;
    cam_data.offset_x = offset_x / w2;
    cam_data.offset_y = offset_y / h2;

    var R0 = cam_data.X[0]; var R1 = cam_data.Y[0]; var R2 = dy; var R3 = R1*R2; var R4 = dx; var R5 = R0*R4;
    var R6 = cam_data.Z[0]; var R7 = dz; var R8 = R6*R7; var R9 = R3+R5+R8; var R10 = R9*R9; var R11 = cam_data.X[1];
    var R12 = R11*R4; var R13 = cam_data.Y[1]; var R14 = R13*R2; var R15 = cam_data.Z[1]; var R16 = R15*R7; var R17 = R12+R14+R16;
    var R18 = R17*R17; var R19 = cam_data.Z[2]; var R20 = R19*R7; var R21 = cam_data.X[2]; var R22 = R21*R4; var R23 = cam_data.Y[2];
    var R24 = R23*R2; var R25 = R20+R22+R24; var R26 = R25*R25; var R27 = R10+R18+R26; var R28 = 0.5; var R29 = pow(R27,R28);
    var R30 = cos(R29); var R31 = 1; var R32 = R31-R30; var R33 = R32*R9; var R34 = R9*R33; var R35 = 1.0/R27;
    var R36 = R34*R35; var R37 = R30+R36; var R38 = R0*R37; var R39 = -0.5; var R40 = pow(R27,R39); var R41 = R32*R40;
    var R42 = R9*R41; var R43 = R17*R42; var R44 = sin(R29); var R45 = R25*R44; var R46 = R43-R45; var R47 = R11*R46;
    var R48 = R44*R17; var R49 = R25*R41; var R50 = R9*R49; var R51 = R48+R50; var R52 = R21*R51; var R53 = R47+R52;
    var R54 = R40*R53; var R55 = R38+R54; var R56 = R55*R55; var R57 = R45+R43; var R58 = R0*R57; var R59 = R17*R49;
    var R60 = R9*R44; var R61 = R59-R60; var R62 = R21*R61; var R63 = R58+R62; var R64 = R40*R63; var R65 = R32*R17;
    var R66 = R17*R65; var R67 = R66*R35; var R68 = R30+R67; var R69 = R11*R68; var R70 = R64+R69; var R71 = R70*R70;
    var R72 = R60+R59; var R73 = R11*R72; var R74 = R50-R48; var R75 = R0*R74; var R76 = R73+R75; var R77 = R40*R76;
    var R78 = R32*R25; var R79 = R25*R78; var R80 = R79*R35; var R81 = R30+R80; var R82 = R21*R81; var R83 = R77+R82;
    var R84 = R83*R83; var R85 = R56+R71+R84; var R86 = pow(R85,R39); var R87 = R55*R86; cam_data.X[0] = R87; var R88 = R70*R86;
    cam_data.X[1] = R88; var R89 = R83*R86; cam_data.X[2] = R89; var R90 = R1*R37; var R91 = R23*R51; var R92 = R13*R46;
    var R93 = R91+R92; var R94 = R40*R93; var R95 = R90+R94; var R96 = R83*R95; var R97 = R23*R81; var R98 = R13*R72;
    var R99 = R1*R74; var R100 = R98+R99; var R101 = R40*R100; var R102 = R97+R101; var R103 = R55*R102; var R104 = R96-R103;
    var R105 = R83*R104; var R106 = R13*R68; var R107 = R1*R57; var R108 = R23*R61; var R109 = R107+R108; var R110 = R40*R109;
    var R111 = R106+R110; var R112 = R55*R111; var R113 = R70*R95; var R114 = R112-R113; var R115 = R70*R114; var R116 = R105-R115;
    var R117 = R116*R116; var R118 = R55*R114; var R119 = R70*R102; var R120 = R83*R111; var R121 = R119-R120; var R122 = R121*R83;
    var R123 = R118-R122; var R124 = R123*R123; var R125 = R121*R70; var R126 = R55*R104; var R127 = R125-R126; var R128 = R127*R127;
    var R129 = R117+R124+R128; var R130 = pow(R129,R39); var R131 = R116*R130; cam_data.Y[0] = R131; var R132 = R123*R130; cam_data.Y[1] = R132;
    var R133 = R127*R130; cam_data.Y[2] = R133; var R134 = R121*R121; var R135 = R104*R104; var R136 = R114*R114; var R137 = R134+R135+R136;
    var R138 = pow(R137,R39); var R139 = R121*R138; cam_data.Z[0] = R139; var R140 = R104*R138; cam_data.Z[1] = R140; var R141 = R114*R138;
    cam_data.Z[2] = R141; var R142 = cam_data.X_img[0]; var R143 = R2*R2; var R144 = R4*R4; var R145 = R7*R7; var R146 = R143+R144+R145;
    var R147 = pow(R146,R28); var R148 = cos(R147); var R149 = R31-R148; var R150 = R149*R4; var R151 = R4*R150; var R152 = 1.0/R146;
    var R153 = R151*R152; var R154 = R148+R153; var R155 = R142*R154; var R156 = pow(R146,R39); var R157 = cam_data.X_img[1]; var R158 = sin(R147);
    var R159 = R7*R158; var R160 = R156*R150; var R161 = R2*R160; var R162 = R159+R161; var R163 = -R162; var R164 = R157*R163;
    var R165 = cam_data.X_img[2]; var R166 = R2*R158; var R167 = R7*R160; var R168 = R166-R167; var R169 = R165*R168; var R170 = R164+R169;
    var R171 = R156*R170; var R172 = R155+R171; cam_data.X_img[0] = R172; var R173 = R159-R161; var R174 = R142*R173; var R175 = R4*R158;
    var R176 = R149*R156; var R177 = R2*R7*R176; var R178 = R175+R177; var R179 = R165*R178; var R180 = R174+R179; var R181 = R156*R180;
    var R182 = R149*R2; var R183 = R2*R182; var R184 = R183*R152; var R185 = R148+R184; var R186 = R157*R185; var R187 = R181+R186;
    cam_data.X_img[1] = R187; var R188 = R177-R175; var R189 = R157*R188; var R190 = R166+R167; var R191 = -R190; var R192 = R142*R191;
    var R193 = R189+R192; var R194 = R156*R193; var R195 = R149*R7; var R196 = R7*R195; var R197 = R196*R152; var R198 = R148+R197;
    var R199 = R165*R198; var R200 = R194+R199; cam_data.X_img[2] = R200; var R201 = cam_data.Y_img[0]; var R202 = R201*R154; var R203 = cam_data.Y_img[2];
    var R204 = R203*R168; var R205 = cam_data.Y_img[1]; var R206 = R205*R163; var R207 = R204+R206; var R208 = R156*R207; var R209 = R202+R208;
    cam_data.Y_img[0] = R209; var R210 = R205*R185; var R211 = R201*R173; var R212 = R203*R178; var R213 = R211+R212; var R214 = R156*R213;
    var R215 = R210+R214; cam_data.Y_img[1] = R215; var R216 = R205*R188; var R217 = R201*R191; var R218 = R216+R217; var R219 = R156*R218;
    var R220 = R203*R198; var R221 = R219+R220; cam_data.Y_img[2] = R221; var R222 = cam_data.Z_img[0]; var R223 = R222*R154; var R224 = cam_data.Z_img[2];
    var R225 = R224*R168; var R226 = cam_data.Z_img[1]; var R227 = R226*R163; var R228 = R225+R227; var R229 = R156*R228; var R230 = R223+R229;
    cam_data.Z_img[0] = R230; var R231 = R226*R185; var R232 = R224*R178; var R233 = R222*R173; var R234 = R232+R233; var R235 = R156*R234;
    var R236 = R231+R235; cam_data.Z_img[1] = R236; var R237 = R226*R188; var R238 = R222*R191; var R239 = R237+R238; var R240 = R156*R239;
    var R241 = R224*R198; var R242 = R240+R241; cam_data.Z_img[2] = R242;  /* 228 instructions */
}

function draw_img_on_canvas( canvas ) {
    var w = canvas.cam_data.width;
    var h = canvas.cam_data.height;
    var w2 = w / 2;
    var h2 = h / 2;
    var mwh = 1.0 * Math.min( w, h );
    var ctx = canvas.getContext('2d');
    var hidden_src_canvas = canvas.cam_data.hidden_src_canvas;

    var d_X_img = ( canvas.cam_data.X_img[0] != 1.0 || canvas.cam_data.X_img[1] != 0.0 || canvas.cam_data.X_img[2] != 0.0 );
    var d_Y_img = ( canvas.cam_data.Y_img[0] != 0.0 || canvas.cam_data.Y_img[1] != 1.0 || canvas.cam_data.Y_img[2] != 0.0 );
    var d_Z_img = ( canvas.cam_data.Z_img[0] != 0.0 || canvas.cam_data.Z_img[1] != 0.0 || canvas.cam_data.Z_img[2] != 1.0 );
    if ( d_X_img || d_Y_img || d_Z_img ) {
        var hidden_ctx = hidden_src_canvas.getContext('2d');
        if ( hidden_src_canvas.there_s_a_new_img ) {
            hidden_src_canvas.there_s_a_new_img = false;
            hidden_src_canvas.width  = w;
            hidden_src_canvas.height = 2 * h;
            hidden_ctx.drawImage( canvas.cam_data.img_rgba, 0, 0 );
        }
        var src_pix = hidden_ctx.getImageData( 0, 0, w, 2 * h );
        var src_data = src_pix.data;

        var t0 = new Date().getTime();
        //
        if ( d_Z_img ) {
            var lineargradient = ctx.createLinearGradient( 0, 0, 0, h );
            lineargradient.addColorStop( 0.0, "rgb( 0, 0, 0   )" );
            lineargradient.addColorStop( 0.5, "rgb( 0, 0, 40  )" );
            lineargradient.addColorStop( 1.0, "rgb( 0, 0, 150 )" );
            ctx.fillStyle = lineargradient;
            ctx.fillRect( 0, 0, w, h );

            var s = canvas.cam_data.size_rect_img_rot_all || 10;
            var sz = s * canvas.cam_data.zoom_img;
            var cx = canvas.cam_data.R * ( canvas.cam_data.offset_x + 1.0 );
            var cy = canvas.cam_data.R * ( 1.0 - canvas.cam_data.offset_y );
            var ziuroiy = mwh * canvas.cam_data.zoom * 0.8 / 255.0 * canvas.cam_data.zoom_img;
            if ( want_z_sorting ) {
                var pix = new Array();
                var o = 0;
                var nx = ( cx - canvas.cam_data.X_img[0] * cx - canvas.cam_data.Y_img[0] * cy ) * canvas.cam_data.zoom_img + canvas.cam_data.offset_x_img;
                var ny = ( cy - canvas.cam_data.X_img[1] * cx - canvas.cam_data.Y_img[1] * cy ) * canvas.cam_data.zoom_img + canvas.cam_data.offset_y_img;
                var nz = - canvas.cam_data.X_img[2] * cx - canvas.cam_data.Y_img[2] * cy;
                for(var y=0;y<h;y+=s) {
                    var oy = o;
                    var old_nx = nx;
                    var old_ny = ny;
                    var old_nz = nz;
                    for(var x=0;x<w;x+=s) {
                        if ( src_data[ o + 3 ] == 255 ) {
                            var dz = ( 128.0 - src_data[ w * h * 4 + o + 1 ] ) * ziuroiy;
                            pix.push( [
                                nz + canvas.cam_data.Z_img[2] * dz,
                                nx + canvas.cam_data.Z_img[0] * dz,
                                ny + canvas.cam_data.Z_img[1] * dz,
                                src_data[ o + 0 ], src_data[ o + 1 ], src_data[ o + 2 ]
                            ] );
                        }
                        o += 4 * s;
                        nx += s * canvas.cam_data.X_img[0] * canvas.cam_data.zoom_img;
                        ny += s * canvas.cam_data.X_img[1] * canvas.cam_data.zoom_img;
                        nz += s * canvas.cam_data.X_img[2] * canvas.cam_data.zoom_img;
                    }
                    o = oy + 4 * w * s;
                    nx = old_nx + s * canvas.cam_data.Y_img[0] * canvas.cam_data.zoom_img;
                    ny = old_ny + s * canvas.cam_data.Y_img[1] * canvas.cam_data.zoom_img;
                    nz = old_nz + s * canvas.cam_data.Y_img[2] * canvas.cam_data.zoom_img;
                }
                pix.sort();
                for(var i=0;i<pix.length;i++) {
                    var p = pix[ i ];
                    ctx.fillStyle = "rgb( "+p[3]+", "+p[4]+", "+p[5]+" )";
                    ctx.fillRect( p[1], p[2], sz, sz );
                }
            } else {
                var o = 0;
                var nx = ( cx - canvas.cam_data.X_img[0] * cx - canvas.cam_data.Y_img[0] * cy ) * canvas.cam_data.zoom_img + canvas.cam_data.offset_x_img;
                var ny = ( cy - canvas.cam_data.X_img[1] * cx - canvas.cam_data.Y_img[1] * cy ) * canvas.cam_data.zoom_img + canvas.cam_data.offset_y_img;
                var wh4z = w * h * 4, dnx = s * canvas.cam_data.X_img[0] * canvas.cam_data.zoom_img, dny = s * canvas.cam_data.X_img[1] * canvas.cam_data.zoom_img;
                for(var y=0;y<h;y+=s) {
                    var oy = o;
                    var old_nx = nx;
                    var old_ny = ny;
                    for(var x=0;x<w;x+=s) {
                        if ( src_data[ o + 3 ] == 255 ) {
                            var mz = src_data[ wh4z + o ];
                            if ( mz > 10 && mz < 245 ) {
                                var dz = ( 128.0 - mz ) * ziuroiy;

                                ctx.fillStyle = "rgb( "+src_data[ o + 0 ]+", "+src_data[ o + 1 ]+", "+src_data[ o + 2 ]+" )";
                                ctx.fillRect(
                                        nx + canvas.cam_data.Z_img[0] * dz,
                                        ny + canvas.cam_data.Z_img[1] * dz,
                                        sz, sz
                                );
                            }
                        }
                        o += 4 * s;
                        nx += dnx;
                        ny += dny;
                    }
                    o = oy + 4 * w * s;
                    nx = old_nx + s * canvas.cam_data.Y_img[0] * canvas.cam_data.zoom_img;
                    ny = old_ny + s * canvas.cam_data.Y_img[1] * canvas.cam_data.zoom_img;
                }
            }

            t0 = new Date().getTime() - t0;
            canvas.cam_data.size_rect_img_rot_all = Math.ceil( canvas.cam_data.size_rect_img_rot_all * Math.sqrt( t0 / 50 ) ) || 8;
            // document.getElementById("com").firstChild.data = z_mean / num_z;
        } else { // rot z only
            var s = canvas.cam_data.size_rect_img_rot_z_only;
            if ( s == 0 ) {
                var res_pix = ctx.getImageData( 0, 0, w, h );
                var res_data = res_pix.data;

                for(var y=0;y<h;y++) {
                    if ( y == 10 && new Date().getTime() - t0 > max_time_for_img_disp * 10.0 / h ) { // timings
                        s = 10;
                        t0 = new Date().getTime();
                        break;
                    }
                    for(var x=0;x<w;x++) {
                        var dx = ( x - canvas.cam_data.offset_x_img ) / canvas.cam_data.zoom_img;
                        var dy = ( y - canvas.cam_data.offset_y_img ) / canvas.cam_data.zoom_img;
                        var nx = Math.floor( canvas.cam_data.X_img[0] * dx + canvas.cam_data.X_img[1] * dy );
                        var ny = Math.floor( canvas.cam_data.Y_img[0] * dx + canvas.cam_data.Y_img[1] * dy );
                        var no = 4 * ( w * ny + nx );
                        var o  = 4 * ( w *  y +  x );

                        if ( nx >= 0 && nx < w && ny >= 0 && ny < h && src_data[ no + 3 ] == 255 ) {
                            res_data[ o + 0 ] = src_data[ no + 0 ];
                            res_data[ o + 1 ] = src_data[ no + 1 ];
                            res_data[ o + 2 ] = src_data[ no + 2 ];
                            res_data[ o + 3 ] = 255;
                        } else {
                            res_data[ o + 0 ] = 0;
                            res_data[ o + 1 ] = 0;
                            var q = 2.0 * y / h;
                            res_data[ o + 2 ] = 40.0 * q + ( 150.0 - 2.0 * 40.0 ) * ( q - 1.0 ) * ( q > 1.0 );
                            res_data[ o + 3 ] = 255;
                        }
                    }
                }

                ctx.putImageData( res_pix, 0, 0 );
            } else { // size
                var lineargradient = ctx.createLinearGradient( 0, 0, 0, h );
                lineargradient.addColorStop( 0.0, "rgb( 0, 0, 0 )" );
                lineargradient.addColorStop( 0.5, "rgb( 0, 0, 40 )" );
                lineargradient.addColorStop( 1.0, "rgb( 0, 0, 150 )" );
                ctx.fillStyle = lineargradient;
                ctx.fillRect( 0, 0, w, h );

                for(var y=0;y<h;y+=s) {
                    for(var x=0;x<w;x+=s) {
                        var dx = ( x - canvas.cam_data.offset_x_img ) / canvas.cam_data.zoom_img;
                        var dy = ( y - canvas.cam_data.offset_y_img ) / canvas.cam_data.zoom_img;
                        var nx = Math.floor( canvas.cam_data.X_img[0] * dx + canvas.cam_data.X_img[1] * dy );
                        var ny = Math.floor( canvas.cam_data.Y_img[0] * dx + canvas.cam_data.Y_img[1] * dy );
                        var no = 4 * ( w * ny + nx );
                        if ( nx >= 0 && nx < w && ny >= 0 && ny < h && src_data[ no + 3 ] == 255 ) {
                            ctx.fillStyle = "rgb( "+src_data[ no + 0 ]+", "+src_data[ no + 1 ]+", "+src_data[ no + 2 ]+" )";
                            ctx.fillRect( x, y, s, s );
                        }
                    }
                }
            }

            t0 = new Date().getTime() - t0;
            canvas.cam_data.size_rect_img_rot_z_only = Math.ceil( canvas.cam_data.size_rect_img_rot_z_only * Math.sqrt( t0 / 50 ) ) || 8;
        }
        // document.getElementById("com").firstChild.data = canvas.cam_data.size_rect_img_rot_z_only;
    } else {
        var lineargradient = ctx.createLinearGradient( 0, 0, 0, h );
        lineargradient.addColorStop( 0.0, "rgb( 0, 0, 0 )" );
        lineargradient.addColorStop( 0.5, "rgb( 0, 0, 40 )" );
        lineargradient.addColorStop( 1.0, "rgb( 0, 0, 150 )" );
        ctx.fillStyle = lineargradient;
        ctx.fillRect( 0, 0, w, h );

        ctx.drawImage(
            canvas.cam_data.img_rgba,
            canvas.cam_data.offset_x_img,
            canvas.cam_data.offset_y_img,
            w * canvas.cam_data.zoom_img,
            2 * h * canvas.cam_data.zoom_img
        );

        if ( canvas.cam_data.offset_y_img + h * canvas.cam_data.zoom_img < canvas.width )
            ctx.fillRect(
                canvas.cam_data.offset_x_img,
                canvas.cam_data.offset_y_img + h * canvas.cam_data.zoom_img,
                w * canvas.cam_data.zoom_img,
                h * canvas.cam_data.zoom_img
            );
    }

    //     ctx.beginPath();
    //     ctx.moveTo( w2, h2 ); ctx.lineTo( Math.floor( w2 + 100 * canvas.cam_data.X_img[0] ), Math.floor( h2 + 100 * canvas.cam_data.X_img[1] ) );
    //     ctx.moveTo( w2, h2 ); ctx.lineTo( Math.floor( w2 + 100 * canvas.cam_data.Y_img[0] ), Math.floor( h2 + 100 * canvas.cam_data.Y_img[1] ) );
    //     ctx.moveTo( w2, h2 ); ctx.lineTo( Math.floor( w2 + 100 * canvas.cam_data.Z_img[0] ), Math.floor( h2 + 100 * canvas.cam_data.Z_img[1] ) );
    //     ctx.closePath();
    //     ctx.stroke();
}

function update_img_src( canvas ) { // draw_canvas
    // englobing sphere
    if ( canvas.cam_data.R <= 0 ) {
        send_async_xml_http_request( address_php + "?mode=get_RC&s=" + canvas.cam_data.img_session_id, function( rep ) {
            eval( rep ); // canvas.cam_data.R = ...; canvas.cam_data.C = ...;
            update_img_src( canvas );
        } );
        return;
    }

    // update transformation matrix
    update_trans( canvas.cam_data, canvas.width, canvas.height );

    //
    var img_src = address_php + "?mode=img_txt&counter=" + new Date().getTime() + "&s=" + canvas.cam_data.img_session_id + "&w=" + canvas.cam_data.width + "&h=" + canvas.cam_data.height;
    for(i=0;i<16;i++)
        img_src += "&t" + i + "=" + canvas.cam_data.trans[ i ];
    var eye_pos = get_eye_pos( canvas.cam_data );
    img_src += "&ep0=" + eye_pos[ 0 ] + "&ep1=" + eye_pos[ 1 ] + "&ep2=" + eye_pos[ 2 ];

    //
    canvas.cam_data.img_rgba = new Image();
    canvas.cam_data.img_rgba.onload = function() {
        canvas.cam_data.hidden_src_canvas.there_s_a_new_img = true;
        canvas.cam_data.offset_x_img = 0;
        canvas.cam_data.offset_y_img = 0;
        canvas.cam_data.zoom_img     = 1.0;
        canvas.cam_data.X_img        = [ 1.0, 0.0, 0.0 ];
        canvas.cam_data.Y_img        = [ 0.0, 1.0, 0.0 ];
        canvas.cam_data.Z_img        = [ 0.0, 0.0, 1.0 ];
        draw_img_on_canvas( canvas );
    }
    canvas.cam_data.img_rgba.src = img_src;
}

function restart_timer_until_src_update( canvas ) {
    if ( canvas.cam_data.current_timer_until_src_update )
        clearTimeout( canvas.cam_data.current_timer_until_src_update );
    canvas.cam_data.current_timer_until_src_update = setTimeout( "update_img_src( document.getElementById(\"" + canvas.id + "\") )", delay_send );
}

function getLeft( l ) {
    if ( l.offsetParent )
        return l.offsetLeft + getLeft( l.offsetParent );
    else
        return l.offsetLeft;
}

function getTop( l ) {
    if (l.offsetParent)
        return l.offsetTop + getTop( l.offsetParent );
    else
        return l.offsetTop;
}

function img_mouse_down( evt ) {
    if ( !evt ) evt = window.event;

    // code from http://unixpapa.com/js/mouse.html
    if ( evt.which == null )
       button = ( evt.button < 2 ) ? "LEFT" : ( ( evt.button == 4 ) ? "MIDDLE" : "RIGHT" );
    else
       button = ( evt.which  < 2 ) ? "LEFT" : ( ( evt.which  == 2 ) ? "MIDDLE" : "RIGHT" );

    this.onmousemove = img_mouse_move;
    this.onmouseout  = img_mouse_out;
    old_x = evt.clientX - getLeft( this );
    old_y = evt.clientY - getTop ( this );

    if( evt.preventDefault ) evt.preventDefault();
    evt.returnValue = false;
    return false;
}

function img_mouse_up( evt ) {
    if ( !evt ) evt = window.event;

    this.onmousemove = null;

    if( evt.preventDefault ) evt.preventDefault();
    evt.returnValue = false;
    return false;
}

function img_mouse_out( evt ) {
    this.onmousemove = null;
}

function img_mouse_move( evt ) {
    if ( !evt ) evt = window.event;

    var new_x = evt.clientX - getLeft( this );
    var new_y = evt.clientY - getTop ( this );
    if ( new_x == old_x && new_y == old_y )
        return;

    if ( button == "LEFT" ) { // rotate
        var w = this.width;
        var h = this.height;
        var mwh = Math.max( w, h );
        if ( evt.shiftKey ) {
            rotate( this.cam_data, 0.0, 0.0, Math.atan2( new_y - h / 2.0, new_x - w / 2.0 ) - Math.atan2( old_y - h / 2.0, old_x - w / 2.0 ) );
        } else {
            rotate( this.cam_data, 2.0 * ( new_y - old_y ) / mwh, 2.0 * ( new_x - old_x ) / mwh, 0.0 );
        }
    } else if ( button == "MIDDLE" ) { // pan
        this.cam_data.offset_x += ( new_x - old_x ) * 2.0 / this.width;
        this.cam_data.offset_y -= ( new_y - old_y ) * 2.0 / this.height;
        this.cam_data.offset_x_img += new_x - old_x;
        this.cam_data.offset_y_img += new_y - old_y;
    }

    draw_img_on_canvas( this );
    restart_timer_until_src_update( this );

    old_x = new_x;
    old_y = new_y;
    // document.getElementById("com").firstChild.data = canvas.cam_data.trans;

    if( evt.preventDefault ) evt.preventDefault();
    evt.returnValue = false;
    return false;
}

function img_mouse_wheel( evt ) {
    if ( !evt ) evt = window.event;

    // browser compatibility -> stolen from http://unixpapa.com/js/mouse.html
    var delta = 0;
    if ( evt.wheelDelta ) {
        delta = evt.wheelDelta / 120.0;
        if ( window.opera )
            delta = - delta;
    } else if ( evt.detail )
        delta = - evt.detail / 3.0;

    //
    var x = evt.clientX - getLeft( this );
    var y = evt.clientY - getTop ( this );
    var coeff = Math.pow( 1.2, delta );

    // 2D
    this.cam_data.offset_x_img = x + ( this.cam_data.offset_x_img - x ) * coeff;
    this.cam_data.offset_y_img = y + ( this.cam_data.offset_y_img - y ) * coeff;
    this.cam_data.zoom_img *= coeff;

    // 3D
    x = x * 2.0 / this.cam_data.width  - 1.0;
    y = 1.0 - y * 2.0 / this.cam_data.height;
    this.cam_data.offset_x = x + ( this.cam_data.offset_x - x ) * coeff;
    this.cam_data.offset_y = y + ( this.cam_data.offset_y - y ) * coeff;
    this.cam_data.zoom *= coeff;

    //
    draw_img_on_canvas( this );
    restart_timer_until_src_update( this );

    if( evt.preventDefault ) evt.preventDefault();
    evt.returnValue = false;
}

function img_init( canvas ) {
    // init cam_data
    canvas.cam_data = {
        width : canvas.width,
        height : canvas.height,

        X : [1.0,0.0,0.0],
        Y : [0.0,1.0,0.0],
        Z : [0.0,0.0,1.0],
        R : -1.0,
        C : [0.0,0.0,0.0],
        zoom : 1.0,
        perspective : 0.2,
        offset_x : 0.0,
        offset_y : 0.0,

        offset_x_img : 0,
        offset_y_img : 0,
        zoom_img     : 1,
        X_img        : [1.0,0.0,0.0],
        Y_img        : [0.0,1.0,0.0],
        Z_img        : [0.0,0.0,1.0],

        size_rect_img_rot_z_only : 0,
        size_rect_img_rot_all : 10
    };

    canvas.cam_data.hidden_src_canvas = document.createElement("canvas");
    canvas.cam_data.hidden_src_canvas.style.display = "none";
    document.body.appendChild( canvas.cam_data.hidden_src_canvas );

    // events
    if ( canvas.addEventListener )
        canvas.addEventListener( "DOMMouseScroll", img_mouse_wheel, false );
    canvas.onmousedown  = img_mouse_down;
    canvas.onmouseup    = img_mouse_up;
    canvas.onmousewheel = img_mouse_wheel;

    // start new session. When ready, draw img
    //alert(address_php + "?mode=newsession&w=" + canvas.width + "&h=" + canvas.height);
    send_async_xml_http_request( address_php + "?mode=newsession&w=" + canvas.width + "&h=" + canvas.height, function( rep ) {
        canvas.cam_data.img_session_id = rep;
        update_img_src( canvas );
    } );
}

function dec_img( canvas, z ) {
    canvas.cam_data.zoom *= z;
    canvas.cam_data.zoom_img *= z;
    canvas.cam_data.offset_x_img = canvas.cam_data.width  / 2 + ( canvas.cam_data.offset_x_img - canvas.cam_data.width  / 2 ) * z
    canvas.cam_data.offset_y_img = canvas.cam_data.height / 2 + ( canvas.cam_data.offset_y_img - canvas.cam_data.height / 2 ) * z;

    draw_img_on_canvas( canvas );
    restart_timer_until_src_update( canvas );
}

function fit_img( canvas ) {
    canvas.cam_data.zoom = 1.5;
    canvas.cam_data.offset_x = 0.0;
    canvas.cam_data.offset_y = 0.0;
    draw_img_on_canvas( canvas );
    restart_timer_until_src_update( canvas );
}

function rot_img_X( canvas ) {
    canvas.cam_data.X = [1.0,0.0,0.0];
    canvas.cam_data.Y = [0.0,1.0,0.0];
    canvas.cam_data.Z = [0.0,0.0,1.0];
    draw_img_on_canvas( canvas );
    restart_timer_until_src_update( canvas );
}

function rot_img_Y( canvas ) {
    canvas.cam_data.X = [0.0,0.0,1.0];
    canvas.cam_data.Y = [0.0,1.0,0.0];
    canvas.cam_data.Z = [-1.0,0.0,0.0];
    draw_img_on_canvas( canvas );
    restart_timer_until_src_update( canvas );
}

function rot_img_Z( canvas ) {
    canvas.cam_data.X = [1.0,0.0,0.0];
    canvas.cam_data.Y = [0.0,0.0,1.0];
    canvas.cam_data.Z = [0.0,-1.0,0.0];
    draw_img_on_canvas( canvas );
    restart_timer_until_src_update( canvas );
}

function toggle_want_z_sorting( obj, canvas ) {
    want_z_sorting = ! want_z_sorting;
    obj.firstChild.data = "Z-sorting -> " +  ( want_z_sorting ? "yes" : "no" );
}

// function set_function_button( func, canvas ) {
//     this.onmousedown = function() { func( this, canvas ) };
//     this.onmouseover = function() { this.style.background = '#d9e3e9'; };
//     this.onmouseout  = function() { this.style.background = this.style.old_bk; };
// }

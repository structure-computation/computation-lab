# coffee -b --watch --compile *.coffee
# ScModel needs ScClient

# drawable object for ScDisp
class ScItem
    sd_list: undefined # list of ScDisp which contain this
    z_index: 0 # ...
    
    init_ScItem: -> 
        @sd_list = [] # ScDisp list

    redraw_containers: ->
        for sd in @sd_list
            sd.draw()

    draw_2d: ( ctx, cam ) ->
        alert( "todo" )

    get_num_elem: ( x, y ) ->
        undefined

    get_num_group: ( x, y ) ->
        undefined
        
    fit: () ->
        undefined

    shrink: ( s ) ->
        undefined

    set_elem_filter: ( filter ) ->
        undefined

    color_by_field: ( name, num_comp = 0 ) ->
        undefined
    
# draw a gradient background
class ScItem_GradiendBackground extends ScItem
    color_stops : undefined
    
    constructor: ( @color_stops, @z_index = 100 ) ->
        @init_ScItem()
    
    draw_2d: ( ctx, cam ) ->
        lineargradient = ctx.createLinearGradient( 0, 0, 0, cam.h )
        for [ s, v ] in @color_stops
            lineargradient.addColorStop( s, v )
        ctx.fillStyle = lineargradient
        ctx.fillRect( 0, 0, cam.w, cam.h )
    
# draw xyz axes
# position possibles : lb, mm, ... voir @rp
class ScItem_Axes extends ScItem
    p : undefined # left bottom by default
    r : undefined # size of the box, expressed as ratio of the screen size
    d : undefined # "real" diameter of axes. Used only if @p == "mm"
    l : 3 # line width

    constructor: ( position = "lb", ratio = 1.0 / 20.0 ) ->
        @init_ScItem()
        @p = position
        @r = ratio

    fixed: () -> @p == "mm"

    rp: ( cam ) ->
        if not @d?
            @d = cam.d
        l = @r * ( if @fixed() then @d else cam.d )
        s = 0.3 * cam.mwh() * @r
        
        o = cam.re_2_sc.proj( [ 0, 0, 0 ] )
        x = cam.re_2_sc.proj( [ l, 0, 0 ] )
        y = cam.re_2_sc.proj( [ 0, l, 0 ] )
        z = cam.re_2_sc.proj( [ 0, 0, l ] )
        
        mi_x = Math.min( o[ 0 ], x[ 0 ], y[ 0 ], z[ 0 ] )
        ma_x = Math.max( o[ 0 ], x[ 0 ], y[ 0 ], z[ 0 ] )
        mi_y = Math.min( o[ 1 ], x[ 1 ], y[ 1 ], z[ 1 ] )
        ma_y = Math.max( o[ 1 ], x[ 1 ], y[ 1 ], z[ 1 ] )
        
        if @p[ 0 ] == "l" or @p[ 0 ] == "r"
            dec = if @p[ 0 ] == "r" then cam.w - ma_x - s else s - mi_x
            x[ 0 ] += dec
            y[ 0 ] += dec
            z[ 0 ] += dec
            o[ 0 ] += dec
        if @p[ 1 ] == "b" or @p[ 1 ] == "t"
            dec = if @p[ 1 ] == "b" then cam.h - ma_y - s else s - mi_y
            x[ 1 ] += dec
            y[ 1 ] += dec
            z[ 1 ] += dec
            o[ 1 ] += dec
        return [ o, x, y, z ]
        

    draw_2d: ( ctx, cam ) ->
        [ o, x, y, z ] = @rp( cam )
        for a in [[o,x,'#FF0000'],[o,y,'#00AA00'],[o,z,'#4444FF']].sort( ( a, b ) -> a[1][2] < b[1][2] )
            ctx.lineWidth = @l
            ctx.strokeStyle = a[ 2 ]
            ctx.beginPath()
            ctx.moveTo( a[ 0 ][ 0 ], a[ 0 ][ 1 ] )
            ctx.lineTo( a[ 1 ][ 0 ], a[ 1 ][ 1 ] )
            ctx.stroke()
            ctx.closePath()

# nd model, loaded from the server
class ScItem_Model extends ScItem
    window.SCVisu.ScClient.make_child( ScItem_Model )
    
    loc_cam   : undefined # local camera, updated by the server
    img_rgba  : undefined
    img_zzzz  : undefined
    img_ngrp  : undefined
    img_altc  : undefined
    info      : undefined # info on loaded object (displayable fields, ...)
    delay_send: 300 # delay before sending a new img request to the server
    alpha_altc: 0.5
    nb_alt_ctx: 0
    want_fps  : 40
    waiting_server : 1
    linked_panes : undefined # panels with set_info methods
    
    size_disp_rect: 5
    need_update   : 0

    constructor: ( port = "00" ) ->
        # ancestors
        @init_ScClient( port )
        @init_ScItem()
        
        # basic init
        @cmd_list  = ""
        @img_rgba  = new Image()
        @img_zzzz  = new Image()
        @img_ngrp  = new Image()
        @img_altc  = new Image()
        @linked_panes = []

        
        @img_rgba.onload = () =>
            @img_rgba.data = undefined
            @waiting_server = 0
            @need_update = 0
            @redraw_containers()
        @img_zzzz.onload = () =>
            @img_zzzz.data = undefined
        @img_ngrp.onload = () =>
            @img_ngrp.data = undefined
        @img_altc.onload = () =>
            @img_altc.data = undefined

    get_num_elem: ( x, y ) ->
        o = 4 * ( y * @loc_cam.w + x )
        ngrp_data = @get_img_data( @img_ngrp )
        num_elem = ngrp_data[ o + 0 ] + 256 * ngrp_data[ o + 1 ] + 256 * 256 * ngrp_data[ o + 2 ]
        if num_elem == 16777215
            return undefined
        return num_elem
        
    # num group sur x, y
    get_num_group: ( x, y ) ->
        n = @get_num_elem( x, y )
        if n?
            res = 0
            for o in @info.off_elem_list
                if o >= n
                    return res
                res += 1
            return @info.off_elem_list.length - 1
        return undefined

    load_vtu: ( m ) ->
        @queue_img_server_cmd( 'load_vtu ' + m + '\n' )

    load_hdf: ( file, mesh ) ->
        @queue_img_server_cmd( 'load_hdf ' + file + ' ' + mesh + '\n' )
        
    load_initial_geometry_hdf: ( file ) ->
        @queue_img_server_cmd( 'load_initial_geometry_hdf ' + file + '\n' )

    load_geometry_hdf: ( file, nb_proc ) ->
        @queue_img_server_cmd( 'load_geometry_hdf ' + file + ' ' + nb_proc + '\n' )

    load_fields_hdf: ( file, nb_proc , pt, resolution) ->
        @queue_img_server_cmd( 'load_fields_hdf ' + file + ' ' + nb_proc + ' ' + pt + ' ' + resolution + '\n' )

    warp: ( name , coef=0 ) ->
        @queue_img_server_cmd( 'warp ' + name + ' ' +  coef + '\n' )
        @need_update = 1
        
    get_info: ( name ) ->
        @queue_img_server_cmd( 'get_info ' + name + '\n' )

    get_num_group_info: ( name ) ->
        @queue_img_server_cmd( 'get_num_group_info ' + name + '\n' )

    fit: () ->
        @waiting_server = 1
        @queue_img_server_cmd( 'fit window.SCVisu.ScClient.get_item_by_id( ' + @item_id + ' ).change_cam\n' )
        @flush_img_server_cmd()

    make_img: ( cam ) ->
        @queue_img_server_cmd( 'set_O ' + cam.O[ 0 ] + ' ' + cam.O[ 1 ] + ' ' + cam.O[ 2 ] + '\n' )
        @queue_img_server_cmd( 'set_X ' + cam.X[ 0 ] + ' ' + cam.X[ 1 ] + ' ' + cam.X[ 2 ] + '\n' )
        @queue_img_server_cmd( 'set_Y ' + cam.Y[ 0 ] + ' ' + cam.Y[ 1 ] + ' ' + cam.Y[ 2 ] + '\n' )
        @queue_img_server_cmd( 'set_d ' + cam.d + '\n' )
        @queue_img_server_cmd( 'set_a ' + cam.a + '\n' )
        @queue_img_server_cmd( 'set_wh ' + cam.w + ' ' + cam.h + '\n' )
        @queue_img_server_cmd( 'render\n' )
        @flush_img_server_cmd()
    
    shrink: ( s ) ->
        @queue_img_server_cmd( 'shrink ' + s + '\n' )
        @need_update = 1
        
    get_num_elem_info: ( name ) ->
        @queue_img_server_cmd( 'get_num_elem_info ' + name + '\n' )

    set_elem_filter: ( filter ) ->
        @queue_img_server_cmd( 'set_elem_filter ' + filter + '\n' )
        @need_update = 1


    color_by_field: ( name, num_comp = 0 ) ->
        b = name.indexOf( "[" )
        e = name.indexOf( "]" )
        if b == -1 or e == -1
            @queue_img_server_cmd( 'set_num_comp ' + num_comp + '\n' )
            @queue_img_server_cmd( 'color_by ' + name + '\n' )
        else
            @queue_img_server_cmd( 'set_num_comp ' + name.substr( b + 1, e - b - 1 ) + '\n' )
            @queue_img_server_cmd( 'color_by ' + name.substr( 0, b ) + '\n' )
        @need_update = 1

    change_cam: ( mi, ma ) ->
        @waiting_server = 0
        for sc in @sd_list
            sc.cam.O = [
                0.5 * ( mi[ 0 ] + ma[ 0 ] ),
                0.5 * ( mi[ 1 ] + ma[ 1 ] ),
                0.5 * ( mi[ 2 ] + ma[ 2 ] )
            ]
            sc.cam.d = 1.5 * Math.max( Math.max( ma[ 0 ] - mi[ 0 ], ma[ 1 ] - mi[ 1 ] ), ma[ 2 ] - mi[ 2 ] )
            sc.draw()

    set_info: ( info ) ->
        @info = info
        for pane in @linked_panes
            pane.set_info( info, @item_id )
        
    restart_timer_for_src_update: ( cam ) ->
        if @timer_for_src_update?
            clearTimeout( @timer_for_src_update )
        @timer_for_src_update = setTimeout( ( () => @make_img( cam ) ), @delay_send )
        
    # return an array with RGBA image data
    get_img_data: ( img ) ->
        if not img.data?
            if not img.hc?
                img.hc = document.createElement( "canvas" )
                img.hc.style.display = "none"
                document.body.appendChild( img.hc )
            img.hc.width  = img.width
            img.hc.height = img.height
            ctx = img.hc.getContext( '2d' )
            ctx.drawImage( img, 0, 0 )
            src_pix = ctx.getImageData( 0, 0, img.width, img.height )
            img.data = src_pix.data
        return img.data
        
    draw_2d: ( ctx, cam ) ->
        # if we are requesting a fit
        if @waiting_server
            return undefined

        # first image -> no delay and no approx
        if not @loc_cam?
            @waiting_server = 1
            return @make_img( cam )
            
        # cam are = -> simply display the image
        if cam.equal( @loc_cam ) and not @need_update
            ctx.drawImage( @img_rgba, 0, 0 )
            if @nb_alt_ctx
                ctx.globalAlpha = @alpha_altc
                ctx.drawImage( @img_altc, 0, 0 )
                ctx.globalAlpha = 1.0
            return undefined
        
        # send a new command to the server
        @restart_timer_for_src_update( cam )
        @need_update = 0
        
        #
        rgba_data = @get_img_data( @img_rgba )
        zzzz_data = @get_img_data( @img_zzzz )
        
        
        old_buf = @loc_cam.new_TransBuf()
        new_eye = cam     .new_TransEye()
        inv_z = cam.dot_3( old_buf.Z, new_eye.Z ) < 0

        w = cam.w
        h = cam.h
        rw = w / @size_disp_rect
        rh = h / @size_disp_rect
        
        #if @hc_tmp.width != rw or @hc_tmp.height != rh
            #@hc_tmp.width  = rw
            #@hc_tmp.height = rh
            #@ctx_tmp = @hc_tmp.getContext( '2d' )
            #@loc_img = @ctx_tmp.createImageData( rw, rh )
            #@loc_img_dat = @loc_img.data
        #else
            #for i in [ 0 .. rw * rh ]
                #@loc_img_dat[ 4 * i + 3 ] = 0

        oz_dir = cam.nor_3( old_buf.Z )
        p1i0 = ( x ) -> x + ( x == 0 )
        off_loc_image_data = -4
        t0 = new Date().getTime()
        for r_y in [ 0 .. rh - 1 ]
            y_b = @size_disp_rect * r_y
            y_s = y_b + 0.5 * @size_disp_rect
            for r_x in [ 0 .. rw - 1 ]
                x_b = @size_disp_rect * r_x
                x_s = x_b + 0.5 * @size_disp_rect
                off_loc_image_data += 4

                # starting point for the ray (in th Oxy plane) - old_O
                new_P = new_eye.pos( x_s, y_s )
                new_D = new_eye.dir( x_s, y_s )

                # intersection of the ray / z planes
                div_m = 1 / p1i0( cam.dot_3( new_D, oz_dir ) )
                d_mir = ( @z_min - cam.dot_3( cam.sub_3( new_P, old_buf.O ), oz_dir ) ) * div_m
                d_mar = ( @z_max - cam.dot_3( cam.sub_3( new_P, old_buf.O ), oz_dir ) ) * div_m
                # document.getElementById( "com" ).firstChild.data = div_m
                
                # position of the rays in the 2 z planes
                P_mis = old_buf.proj( [
                    new_P[ 0 ] + d_mir * new_D[ 0 ],
                    new_P[ 1 ] + d_mir * new_D[ 1 ],
                    new_P[ 2 ] + d_mir * new_D[ 2 ]
                ] )
                P_mas = old_buf.proj( [
                    new_P[ 0 ] + d_mar * new_D[ 0 ],
                    new_P[ 1 ] + d_mar * new_D[ 1 ],
                    new_P[ 2 ] + d_mar * new_D[ 2 ]
                ] )
                x_mis = P_mis[ 0 ]; y_mis = P_mis[ 1 ]
                x_mas = P_mas[ 0 ]; y_mas = P_mas[ 1 ]


                # totally out of the (old) screen ?
                if x_mis <  0 and x_mas <  0 then continue
                if x_mis >= w and x_mas >= w then continue
                if y_mis <  0 and y_mas <  0 then continue
                if y_mis >= h and y_mas >= h then continue

                # bounds for the ray
                s_mm = @size_disp_rect / ( Math.max( Math.abs( x_mas - x_mis ), Math.abs( y_mas - y_mis ) ) + 1e-40 )
                b_mm = 0.0; e_mm = 1.0
                if x_mis < x_mas
                    if x_mis < 0     then b_mm = Math.max( b_mm, ( 0 -     x_mis ) / p1i0( x_mas - x_mis ) )
                    if x_mas > w - 1 then e_mm = Math.min( e_mm, ( w - 1 - x_mis ) / p1i0( x_mas - x_mis ) )
                else
                    if x_mas < 0     then e_mm = Math.min( e_mm, ( x_mis - 0     ) / p1i0( x_mis - x_mas ) )
                    if x_mis > w - 1 then b_mm = Math.max( b_mm, ( x_mis - w + 1 ) / p1i0( x_mis - x_mas ) )
                if y_mis < y_mas
                    if y_mis < 0     then b_mm = Math.max( b_mm, ( 0 -     y_mis ) / p1i0( y_mas - y_mis ) )
                    if y_mas > h - 1 then e_mm = Math.min( e_mm, ( h - 1 - y_mis ) / p1i0( y_mas - y_mis ) )
                else
                    if y_mas < 0     then e_mm = Math.min( e_mm, ( y_mis - 0     ) / p1i0( y_mis - y_mas ) )
                    if y_mis > h - 1 then b_mm = Math.max( b_mm, ( y_mis - h + 1 ) / p1i0( y_mis - y_mas ) )
                
                #document.getElementById( "com" ).firstChild.data = r_y
                #if inv_z
                    #i = e_mm
                    #while i >= b_mm
                        #x_md = Math.ceil( x_mis + i * ( x_mas - x_mis ) )
                        #y_md = Math.ceil( y_mis + i * ( y_mas - y_mis ) )
                        #o = 4 * ( y_md * w + x_md )
                        #zu = zzzz_data[ o + 0 ]
                        #if zu != 255
                            #z = @z_min + zu / 254.0 * ( @z_max - @z_min ) # screen space
                            #z_md_0 = @z_min + ( i - 2 * s_mm ) * ( @z_max - @z_min )
                            #z_md_1 = @z_min + ( i + 3 * s_mm ) * ( @z_max - @z_min )
                            #if z <= z_md_1 and z >= z_md_0
                                #r = rgba_data[ o + 0 ]
                                #g = rgba_data[ o + 1 ]
                                #b = rgba_data[ o + 2 ]
                                #ctx.fillStyle = "rgb( " + r + ", " + g + ", " + b + " )"
                                #ctx.fillRect( x, y, @size_disp_rect, @size_disp_rect )
                                #break
                        #i -= s_mm
                #else
                i = b_mm
                while i <= e_mm
                    x_md = Math.ceil( x_mis + i * ( x_mas - x_mis ) )
                    y_md = Math.ceil( y_mis + i * ( y_mas - y_mis ) )
                    b = y_md * @loc_cam.w + x_md; o = 4 * b
                    zu = zzzz_data[ o ]
                    if zu != 255
                        z = @z_min + zu * ( @z_max - @z_min ) / 254.0 # screen space
                        z_md_0 = @z_min + ( i - 2 * s_mm ) * ( @z_max - @z_min )
                        z_md_1 = @z_min + ( i + 3 * s_mm ) * ( @z_max - @z_min )
                        if z <= z_md_1 and z >= z_md_0
                            r = rgba_data[ o + 0 ]
                            g = rgba_data[ o + 1 ]
                            b = rgba_data[ o + 2 ]
                            ctx.fillStyle = "rgb( " + r + ", " + g + ", " + b + " )"
                            ctx.fillRect( x_b, y_b, @size_disp_rect, @size_disp_rect )
                            break
                    i += s_mm
        
        t1 = new Date().getTime() - t0
        @size_disp_rect = Math.max( 1, Math.min( 30, Math.ceil( @size_disp_rect * Math.pow( @want_fps * t1 / 1000.0, 0.5 ) ) ) )
        # document.getElementById("com").firstChild.data = @size_disp_rect
        


# display camera
class ScCam # screen -> eye dir and pos
    class TransEye # screen -> eye dir and pos
        constructor: ( d, w, h ) ->
            mwh = Math.min( w, h )
            c = d.d / mwh
            sm3 = ( x, t ) -> [ x[ 0 ] * t, x[ 1 ] * t, x[ 2 ] * t ] 
            @X = sm3( ScCam.prototype.nor_3( d.X ), c )
            @Y = sm3( ScCam.prototype.nor_3( d.Y ), - c )
            @Z = sm3( ScCam.prototype.nor_3( ScCam.prototype.cro_3( d.X, d.Y ) ), c )
            @p = Math.tan( d.a / 2 * 3.14159265358979323846 / 180 ) / ( mwh / 2 )
            # center
            @O = d.O
            @o_x = - w / 2
            @o_y = - h / 2
            
        dir: ( x, y ) ->
            ScCam.prototype.nor_3( [
                ( ( x + @o_x ) * @X[ 0 ] + ( y + @o_y ) * @Y[ 0 ] ) * @p + @Z[ 0 ],
                ( ( x + @o_x ) * @X[ 1 ] + ( y + @o_y ) * @Y[ 1 ] ) * @p + @Z[ 1 ],
                ( ( x + @o_x ) * @X[ 2 ] + ( y + @o_y ) * @Y[ 2 ] ) * @p + @Z[ 2 ]
            ] )
            
        pos: ( x, y ) -> [
            @O[ 0 ] + ( x + @o_x ) * @X[ 0 ] + ( y + @o_y ) * @Y[ 0 ],
            @O[ 1 ] + ( x + @o_x ) * @X[ 1 ] + ( y + @o_y ) * @Y[ 1 ],
            @O[ 2 ] + ( x + @o_x ) * @X[ 2 ] + ( y + @o_y ) * @Y[ 2 ]
        ]

    class TransBuf # real pos -> screen
        constructor: ( d, w, h ) ->
            mwh = Math.min( w, h )
            c = mwh / d.d
            sm3 = ( x, t ) -> [ x[ 0 ] * t, x[ 1 ] * t, x[ 2 ] * t ] 
            @X = sm3( ScCam.prototype.nor_3( d.X ),   c )
            @Y = sm3( ScCam.prototype.nor_3( d.Y ), - c )
            @Z = sm3( ScCam.prototype.nor_3( ScCam.prototype.cro_3( d.X, d.Y ) ), c )
            @p = Math.tan( d.a / 2 * 3.14159265358979323846 / 180 ) / ( mwh / 2 )
            # center
            @O = d.O
            @o_x = w / 2
            @o_y = h / 2
            
        proj: ( P ) ->
            d = ScCam.prototype.sub_3( P, @O )
            x = ScCam.prototype.dot_3( d, @X )
            y = ScCam.prototype.dot_3( d, @Y )
            z = ScCam.prototype.dot_3( d, @Z )
            d = 1 / ( 1 + @p * z )
            return [ @o_x + d * x, @o_y + d * y, z ]
            
    new_TransBuf: -> new TransBuf( this, @w, @h )
    new_TransEye: -> new TransEye( this, @w, @h )

    # input
    O   : undefined # view center
    X   : undefined # 1st axe
    Y   : undefined # 2nd axe
    a   : 20 # perspective angle
    d   : 50 # viewable diameter (in real coordinates)
    
    # variables modified by update_wh
    w   : 100 # width  of the screen
    h   : 100 # height of the screen
    re_2_sc : undefined # real to screen coordinates
    sc_2_rp : undefined # screen to real coordinates

    constructor: ->
        @O = [ 0, 0, 0 ]
        @X = [ 1, 0, 0 ]
        @Y = [ 0, 1, 0 ]

    equal: ( l ) ->
        ap_3 = ( a, b, e = 1e-3 ) -> Math.abs( a[ 0 ] - b[ 0 ] ) < e and Math.abs( a[ 1 ] - b[ 1 ] ) < e and Math.abs( a[ 2 ] - b[ 2 ] ) < e 
        return l.w == @w and l.h == @h and ap_3( l.O, @O ) and ap_3( l.X, @X ) and ap_3( l.Y, @Y ) and Math.abs( l.a - @a ) < 1e-3 and Math.abs( l.d - @d ) / @d < 1e-3
        
    # set tmp variables
    update_wh: ( w, h ) ->
        @w = w
        @h = h
        @re_2_sc = @new_TransBuf() # real to screen coordinates
        @sc_2_rp = @new_TransEye() # screen to real coordinates

    mwh: () -> Math.min( @w, @h )

    sub_3: ( a, b ) ->
        return [ a[ 0 ] - b[ 0 ], a[ 1 ] - b[ 1 ], a[ 2 ] - b[ 2 ] ]

    add_3: ( a, b ) ->
        return [ a[ 0 ] + b[ 0 ], a[ 1 ] + b[ 1 ], a[ 2 ] + b[ 2 ] ]

    mus_3: ( a, b ) -> # mul by scalar
        return [ a * b[ 0 ], a * b[ 1 ], a * b[ 2 ] ]

    dot_3: ( a, b ) ->
        return a[ 0 ] * b[ 0 ] + a[ 1 ] * b[ 1 ] + a[ 2 ] * b[ 2 ]

    cro_3: ( a, b ) ->
        return [ a[ 1 ] * b[ 2 ] - a[ 2 ] * b[ 1 ], a[ 2 ] * b[ 0 ] - a[ 0 ] * b[ 2 ], a[ 0 ] * b[ 1 ] - a[ 1 ] * b[ 0 ] ]

    len_3: ( a ) ->
        return Math.sqrt( a[ 0 ] * a[ 0 ] + a[ 1 ] * a[ 1 ] + a[ 2 ] * a[ 2 ] )

    nor_3: ( a ) ->
        l = @len_3( a ) + 1e-40
        return [ a[ 0 ] / l, a[ 1 ] / l, a[ 2 ] / l ]

    rot_3: ( V, R ) ->
        a = @len_3( R ) + 1e-40
        x = R[ 0 ] / a
        y = R[ 1 ] / a
        z = R[ 2 ] / a
        c = Math.cos( a )
        s = Math.sin( a )
        return [
            ( x*x+(1-x*x)*c ) * V[ 0 ] + ( x*y*(1-c)-z*s ) * V[ 1 ] + ( x*z*(1-c)+y*s ) * V[ 2 ],
            ( y*x*(1-c)+z*s ) * V[ 0 ] + ( y*y+(1-y*y)*c ) * V[ 1 ] + ( y*z*(1-c)-x*s ) * V[ 2 ],
            ( z*x*(1-c)-y*s ) * V[ 0 ] + ( z*y*(1-c)+x*s ) * V[ 1 ] + ( z*z+(1-z*z)*c ) * V[ 2 ]
        ]

    s_to_w_vec: ( V ) -> # screen orientation to real world.
        Z = @get_Z()
        return [
            V[ 0 ] * @X[ 0 ] + V[ 1 ] * @Y[ 0 ] + V[ 2 ] * Z[ 0 ],
            V[ 0 ] * @X[ 1 ] + V[ 1 ] * @Y[ 1 ] + V[ 2 ] * Z[ 1 ],
            V[ 0 ] * @X[ 2 ] + V[ 1 ] * @Y[ 2 ] + V[ 2 ] * Z[ 2 ]
        ]
        
    get_Z: () ->
        @X = @nor_3( @X )
        @Y = @nor_3( @Y )
        @Z = @nor_3( @cro_3( @X, @Y ) )


# new ScDisp( "canvas_id" ) to @init() a canvas as a scene with objects of type ScItem
class ScDisp
    canvas   : undefined # name 
    ctx      : undefined # drawing context
    cam      : undefined # camera
    ctx_type : "" # 2d, WebGl
    obj_list : undefined # list of drawable objects
    C        : undefined # rotation center
    click_fun: undefined # list of called func if click with left button
    selected : 0

    constructor: ( canvas_ref, allow_gl = false ) ->
        # basic init
        @click_fun = []

        # camera
        @obj_list = []
        @cam = new ScCam()

        # canvas and ctx
        @canvas = if typeof canvas_ref == "string" then document.getElementById( canvas_ref ) else canvas_ref
        @canvas.sc_disp = this
        @init_ctx( allow_gl )

        # events
        @canvas.onmousedown  = ( evt ) => @img_mouse_down( evt )
        @canvas.onmouseup    = ( evt ) => @img_mouse_up( evt )
        @canvas.onmousewheel = ( evt ) => @img_mouse_wheel( evt )
        @canvas.onmouseout   = ( evt ) => @img_mouse_out( evt )
        @canvas.addEventListener?( "DOMMouseScroll", @canvas.onmousewheel, false )
        
    init_ctx: ( allow_gl ) ->
        @ctx_type = "2d"
        @ctx = @canvas.getContext( '2d' )

    add_item: ( item ) ->
        item.sd_list.push( this )
        #         if ScItem.all_it.indexOf( item ) == -1
        #             ScItem.all_it.push( item )
        @obj_list.push( item )

    draw: () ->
        w = @canvas.width
        h = @canvas.height
        @cam.update_wh( w, h )
        for o in @obj_list
            o.draw_2d( @ctx, @cam )
        if @selected
            m = 2
            n = m / 2
            @ctx.lineWidth = m
            @ctx.strokeStyle = "#AAAAFF"
            @ctx.beginPath()
            @ctx.moveTo( n    , n     )
            @ctx.lineTo( w - n, n     )
            @ctx.lineTo( w - n, h - n )
            @ctx.lineTo( n    , h - n )
            @ctx.lineTo( n    , n     )
            @ctx.stroke()
            @ctx.closePath()
            
    fit: () ->
        @cam.d = 0
        for o in @obj_list
            o.fit( @cam )
        @draw()
    
    # repositionner la piece suivant les plans de base
    set_XY: ( X, Y ) ->
        @cam.X = X
        @cam.Y = Y
        @draw()

    # voir les arrètes du maillage
    shrink: ( s ) ->
        for o in @obj_list
            o.shrink( s )
        @draw()

    # visualise une selection de piece ou interfaces 
    set_elem_filter: ( filter ) ->
        for o in @obj_list
            o.set_elem_filter( filter )
        @draw()

    color_by_field: ( name, num_comp = 0 ) ->
        for o in @obj_list
            o.color_by_field( name, num_comp )

    # obtenir la position réelle dans le canvas
    getLeft: ( l ) ->
      if l.offsetParent?
          return l.offsetLeft + @getLeft( l.offsetParent )
      else
          return l.offsetLeft

    # obtenir la position réelle dans le canvas
    getTop: ( l ) ->
        if l.offsetParent?
            return l.offsetTop + @getTop( l.offsetParent )
        else
            return l.offsetTop

    rotate_cam: ( x, y, z ) ->
        R = @cam.s_to_w_vec( [ x, y, z ] )
        if not @C?
            @C = [ @cam.O[ 0 ], @cam.O[ 1 ], @cam.O[ 2 ] ]

        @cam.X = @cam.rot_3( @cam.X, R )
        @cam.Y = @cam.rot_3( @cam.Y, R )
        @cam.O = @cam.add_3( @C, @cam.rot_3( @cam.sub_3( @cam.O, @C ), R ) )

    img_mouse_down: ( evt ) ->
        evt = window.event if not evt?

        # code from http://unixpapa.com/js/mouse.html
        @old_button = 
            if evt.which?
                if evt.which  < 2 then "LEFT" else ( if evt.which  == 2 then "MIDDLE" else "RIGHT" )
            else
                if evt.button < 2 then "LEFT" else ( if evt.button == 4 then "MIDDLE" else "RIGHT" )

        @canvas.onmousemove = ( evt ) => @img_mouse_move( evt )
        @old_x = evt.clientX - @getLeft( @canvas )
        @old_y = evt.clientY - @getTop ( @canvas )

        @mouse_has_moved_since_mouse_down = false

        evt.preventDefault?()
        evt.returnValue = false
        return false
        
    img_mouse_up: ( evt ) ->
        @canvas.onmousemove = null
        if @old_button == "LEFT" and not @mouse_has_moved_since_mouse_down
            for fun in @click_fun
                fun( this, evt )
                
    img_mouse_out: ( evt ) ->
        @canvas.onmousemove = null
            
    # num elem sur x, y
    get_num_elem: ( x, y ) ->
        x -= @getLeft( @canvas )
        y -= @getTop ( @canvas )
        for o in @obj_list
            g = o.get_num_elem( x, y )
            if g?
                return g
    
    # num group sur x, y
    get_num_group: ( x, y ) ->
        x -= @getLeft( @canvas )
        y -= @getTop ( @canvas )
        for o in @obj_list
            g = o.get_num_group( x, y )
            if g?
                return g

    # zoom sur l'objet avec la mollette
    img_mouse_wheel: ( evt ) ->
        evt = window.event if not evt?

        # browser compatibility -> stolen from http://unixpapa.com/js/mouse.html
        delta = 0
        if evt.wheelDelta?
            delta = evt.wheelDelta / 120.0
            if window.opera
                delta = - delta
        else if evt.detail
            delta = - evt.detail / 3.0

        #
        coeff = Math.pow( 1.2, delta );

        # get position of the click in the real world
        mwh = Math.min( @canvas.width, @canvas.height )
        x = ( evt.clientX - @getLeft( @canvas ) - @canvas.width  / 2 ) * @cam.d / mwh
        y = ( @canvas.height / 2 - evt.clientY + @getTop( @canvas )  ) * @cam.d / mwh
        O = @cam.O
        X = @cam.X
        Y = @cam.Y
        P = [ O[ 0 ] + x * X[ 0 ] + y * Y[ 0 ], O[ 1 ] + x * X[ 1 ] + y * Y[ 1 ], O[ 2 ] + x * X[ 2 ] + y * Y[ 2 ] ]

        # update cam_data
        @cam.d /= coeff
        for d in [ 0 .. 2 ]
            @cam.O[ d ] = P[ d ] + ( O[ d ] - P[ d ] ) / coeff

        # redraw
        @draw()

        evt.preventDefault?()
        evt.returnValue = false
        return false
        
    img_mouse_move: ( evt ) ->
        evt = window.event if not evt?
        @mouse_has_moved_since_mouse_down = true
        
        new_x = evt.clientX - @getLeft( @canvas )
        new_y = evt.clientY - @getTop ( @canvas )
        if new_x == @old_x and new_y == @old_y
            return false

        mwh = Math.min( @canvas.width, @canvas.height )
        if @old_button == "LEFT" # rotate
            if evt.shiftKey
                w = @canvas.width
                h = @canvas.height
                a = Math.atan2( new_y - h / 2.0, new_x - w / 2.0 ) - Math.atan2( @old_y - h / 2.0, @old_x - w / 2.0 )
                @rotate_cam( 0.0, 0.0, a )
            else
                x = 2.0 * ( new_x - @old_x ) / mwh
                y = 2.0 * ( new_y - @old_y ) / mwh
                @rotate_cam( y, x, 0.0 )
        else if @old_button == "MIDDLE" # pan
            x = @cam.d * ( new_x - @old_x ) / mwh;
            y = @cam.d * ( @old_y - new_y ) / mwh;
            for d in [ 0 .. 2 ]
                @cam.O[ d ] -= x * @cam.X[ d ] + y * @cam.Y[ d ]

        @draw()

        @old_x = new_x
        @old_y = new_y

# Placement des classes dans l'espace global de la visualisation.
window.SCVisu = {} unless window.SCVisu?

window.SCVisu.ScCam                     = ScCam                    
window.SCVisu.ScDisp                    = ScDisp                   
window.SCVisu.ScItem                    = ScItem                   
window.SCVisu.ScItem_Axes               = ScItem_Axes              
window.SCVisu.ScItem_GradiendBackground = ScItem_GradiendBackground
window.SCVisu.ScItem_Model              = ScItem_Model
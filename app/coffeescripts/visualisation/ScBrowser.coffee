# coffee -b --watch --compile *.coffee
    
class ScBrowser
    ScClient.make_child( ScBrowser )
    
    par_div   : undefined # parent div
    main_div  : undefined # main div
    loc_div   : undefined # location toolbar (includes icons and dir_div)
    dir_div   : undefined # directory, as clickable text (inside loc_div)
    ico_div   : undefined # icon list div
    
    icon_size : 64 # icon size
    cur_dir   : undefined # icon list div
    foc_keys  : undefined # letters typed to get focus on...
    
    prev_dir  : undefined # history
    next_dir  : undefined # history

    open_win  : undefined # opened window
    file_sel  : undefined # hidden file selector

    # should be done with a reduction
    ew = ( file, ends ) ->
        for e in ends
            if file.match( e + "$" )
                return true
        return false

    @img_list : [
        [ "img/64x64/places/folder.png", ( file, data ) -> data.is_a_dir ],
        [ "img/64x64/mimetypes/application-javascript.png", ( file, data ) -> ew( file, [ ".js" ] ) ],
        [ "img/64x64/mimetypes/application-pdf.png", ( file, data ) -> ew( file, [ ".pdf" ] ) ],
        [ "img/64x64/mimetypes/application-rtf.png", ( file, data ) -> ew( file, [ ".rtf" ] ) ],
        [ "img/64x64/mimetypes/application-x-arj.png", ( file, data ) -> ew( file, [ ".zip", ".tbz2", ".tgz", ".gz", ".bz2", ".rar" ] ) ],
        [ "img/64x64/mimetypes/application-x-mplayer2.png", ( file, data ) -> ew( file, [ ".avi" ] ) ],
        [ "img/64x64/mimetypes/text-x-python.png", ( file, data ) -> ew( file, [ ".py" ] ) ],
        [ "img/64x64/mimetypes/text-x-nfo.png", ( file, data ) -> true ],
    ]
    @sel_background : "#CCCCFF"
    @std_background : "none"
    
    constructor: ( par_ref, model_id = -1, base_dir = "", port = "00" ) ->
        if model_id != -1
            base_dir = "/share/sc2/Developpement/MODEL/model_" + model_id

        @init_ScClient( @port )
        console.log( base_dir )
        if base_dir.length
            @queue_img_server_cmd( "base " + base_dir + "\n" )


        @par_div = if typeof par_ref == "string" then document.getElementById( par_ref ) else par_ref
        size_toolbar = 22
        
        @prev_dir = []
        @next_dir = []
        @open_win = []
        @foc_keys = ""

        # hidden file selector
        @file_sel = make_ch( document.body, {
            type       : "file"
            onchange   : (evt) => @upload( evt.target.files )
        }, {
            visibility : "hidden"
        }, "input" )

        # 
        @main_div = make_ch( @par_div, {}, {
            #position : "absolute",
            width       : if chemins_absolus_SC then "721px" else ""
            #height      : "10px"
            cssFloat    : "left"
            #top      : 0,
            #bottom   : 0,
            #left     : 0,
            #right    : 0,
        } )
            
        @main_div.addEventListener( "dragenter", ( ( evt ) => @pass_func( evt ) ), false )
        @main_div.addEventListener( "dragexit" , ( ( evt ) => @pass_func( evt ) ), false )
        @main_div.addEventListener( "dragover" , ( ( evt ) => @pass_func( evt ) ), false )
        @main_div.addEventListener( "drop"     , ( ( evt ) => @drop_func( evt ) ), false )

        key_map = {
            8 : ( evt ) => # backspace
                if @foc_keys.length
                    @update_foc_keys( @foc_keys.substr( 0, @foc_keys.length - 1 ) )
                        
            13 : ( evt ) => # enter
                ico = @focused_icon()
                if ico?
                    if evt.altKey
                        new_name = prompt( 'Rename to', ico.my_file )
                        if new_name?
                            @queue_img_server_cmd( "push " + @cur_dir + "/" + ico.my_file + "\n" )
                            @queue_img_server_cmd( "push " + @cur_dir + "/" + new_name    + "\n" )
                            @queue_img_server_cmd( "rename\n" )
                            @refresh()
                        return undefined
                    @click_file( ico.my_file, ico.my_data )
                
            32 : ( evt ) => # space
                ico = @focused_icon()
                if ico?
                    ico.my_data.is_selected = not ico.my_data.is_selected
                    return ico.make_bg()
                
            36 : ( evt ) => # home
                if evt.altKey
                    return @cd( "~" )
                        
            37 : ( evt ) => # left
                if evt.altKey
                    return @cd_prev()
                @change_ico_focus( [ -1,  0 ] )
                
            38 : ( evt ) => # up
                if evt.altKey
                    return @cd_pare()
                @change_ico_focus( [  0, -1 ] )
                
            39 : ( evt ) => # right
                if evt.altKey
                    return @cd_next()
                @change_ico_focus( [  1,  0 ] )
                
            40 : ( evt ) => # down
                @change_ico_focus( [  0,  1 ] )
                
            88 : ( evt ) => # X
                if evt.ctrlKey # cut
                    @cut()
                
            67 : ( evt ) => # C
                if evt.ctrlKey # copy
                    @copy()
                
            86 : ( evt ) => # V
                if evt.ctrlKey # paste
                    @paste()
                
            46 : ( evt ) => # suppr
                @rm()
                
            112 : ( evt ) => # F1
                @help()
                
            116 : ( evt ) => # F5
                @refresh()
        }

        # document.body.onkeydown
        document.onkeydown = ( evt ) =>
            if not evt.altKey and not evt.ctrlKey
                if evt.keyCode >= 65 and evt.keyCode < 65 + 26
                    @update_foc_keys( @foc_keys + String.fromCharCode( evt.keyCode ).toLowerCase() )
                if evt.keyCode >= 96 and evt.keyCode < 96 + 10
                    @update_foc_keys( @foc_keys + String.fromCharCode( evt.keyCode ) )
                    
            # alert( evt.keyCode )
            if key_map[ evt.keyCode ]?
                @pass_func( evt )
                key_map[ evt.keyCode ]( evt )
                return true
                    
                
        # location toolbar
        @loc_div = make_ch( @main_div, {}, {
            width          : "100%"
            #position : "absolute"
            #top      : 0
            height         : size_toolbar + 12
            backgroundColor: if chemins_absolus_SC then "#2a3556" else "#FFFFFF"
            cssFloat       : "left"
            padding        : if chemins_absolus_SC then "10px 0px 10px 0px" else "10 0 0 0"
            #left     : 0
            #right    : 0
        } )
        
        loc_div_sep = 0
        off_dir_div = 0
        
        add_img_to_loc_div = ( name, func, sep = 0 ) =>
            icons_dir = "img/22x22/actions/"
            if chemins_absolus_SC
                icons_dir = "/javascripts/SCVisu/scene/img/22x22/actions/"
            img = document.createElement( "img" )
            img.onmousedown = func
            img.src = icons_dir + name
            off_dir_div += size_toolbar
            if loc_div_sep
                img.style.paddingLeft = loc_div_sep
                loc_div_sep = 0
            @loc_div.appendChild( img )

        add_sep_to_loc_div = ( d = 10 ) ->
            off_dir_div += d
            loc_div_sep = d

        if not chemins_absolus_SC
            add_sep_to_loc_div()
        add_img_to_loc_div( "go-previous.png" , ( evt ) => @cd_prev() )
        add_img_to_loc_div( "go-next.png"     , ( evt ) => @cd_next() )
        add_img_to_loc_div( "go-up.png"       , ( evt ) => @cd_pare() )
        add_img_to_loc_div( "view-refresh.png", ( evt ) => @refresh() )
        add_img_to_loc_div( "go-home.png"     , ( evt ) => @cd( "~" ) )
        add_sep_to_loc_div()
        add_img_to_loc_div( "edit-cut.png"    , ( evt ) => @cut()     )
        add_img_to_loc_div( "edit-copy.png"   , ( evt ) => @copy()    )
        add_img_to_loc_div( "edit-paste.png"  , ( evt ) => @paste()   )
        add_sep_to_loc_div()
        add_img_to_loc_div( "folder-new.png"  , ( evt ) => @mkdir()   )
        add_sep_to_loc_div( 2 )
        add_img_to_loc_div( "mail-receive.png", ( evt ) => @upload()  )
        add_sep_to_loc_div()
                

        @dir_div = make_ch( @loc_div, {}, {
            #position   : "absolute"
            fontFamily  : "Segoe UI, Arial, sans-serif"
            fontSize    : size_toolbar * 30 / 32
            cssFloat    : if chemins_absolus_SC then "right" else ""
            padding     : if chemins_absolus_SC then "0px 20px 0 0" else ""
            marginLeft  : if chemins_absolus_SC then 0 else 5
            marginTop   : if chemins_absolus_SC then 0 else 5
            #top        : 0
            #bottom     : 0
            #left        : if chemins_absolus_SC then "" else off_dir_div
            #right      : 0
        }, "span" )

        # ico_div
        @ico_div = make_ch( @main_div, {
            onmousedown : ( evt ) =>
                # deselected included 
                for ch in @to_element_of( evt ).childNodes
                    if ch.my_data?
                        ch.my_data.is_selected = false
                        ch.make_bg()
        }, {
            #position : "absolute"
            overflow  : "auto"
            cssFloat  : "left"
            padding   : if chemins_absolus_SC then "10px 0px 0 20px" else""
            #top      : size_toolbar + 6
            #bottom   : 0
            #left     : 0
            #right    : 0
        } )


        # onresize
        @old_onresize = window.onresize
        window.onresize = ( evt ) => @update_ico_div()


        # first cmd to the server
        @cd( "~" )

    destructor: () ->
        window.onresize = @old_onresize

    launch: () ->
        @par_div.appendChild( @main_div )

    # find ico with focus and change dir
    focused_icon: () ->
        for ico in @ico_div.childNodes
            if ico.my_data.has_focus
                return ico
        return undefined
        
    selected_icons: ( allow_focused_if_no_selection = false ) ->
        res = []
        for ico in @ico_div.childNodes
            if ico.my_data.is_selected
                res.push( ico )
        if allow_focused_if_no_selection and not res.length
            for ico in @ico_div.childNodes
                if ico.my_data.has_focus
                    return [ ico ]
        return res
    
    cd_pare: () ->
        l = @cur_dir.lastIndexOf( "/" )
        if l > 0
            @cd( @cur_dir.substr( 0, l ) )

    cd_prev: () ->
        if @prev_dir.length == 0
            return
        @next_dir.push( @cur_dir )
        @cd( @prev_dir.pop(), false )

    cd_next: () ->
        if @next_dir.length == 0
            return
        @prev_dir.push( @cur_dir )
        @cd( @next_dir.pop(), false )
    
    refresh: () ->
        @cd( @cur_dir )
        
    help: () ->
        window.open( "ScBrowserHelp.html", "ScBrowserHelp.html" )
        
    cd: ( dir, push_prev_dir = true ) ->
        if push_prev_dir
            @next_dir = []
            if @cur_dir? and dir != @cur_dir
                @prev_dir.push( @cur_dir )
        @cur_dir = dir
        @update_dir_div()
        @queue_img_server_cmd( "cd " + dir + "\n" )
        @queue_img_server_cmd( "ls ScClient.get_item_by_id( " + @item_id + " ).set_files\n" )
        @flush_img_server_cmd()
        @update_foc_keys( "" )

    cut: () ->
        @paste_mode = "cut"
        @queue_img_server_cmd( "new_sel\n" )
        for ico in @selected_icons( true )
            @queue_img_server_cmd( "app_sel " + @cur_dir + "/" + ico.my_file + "\n" )
                
    copy: () ->
        @paste_mode = "copy"
        @queue_img_server_cmd( "new_sel\n" )
        for ico in @selected_icons( true )
            @queue_img_server_cmd( "app_sel " + @cur_dir + "/" + ico.my_file + "\n" )
                
    paste: () ->
        @queue_img_server_cmd( @paste_mode + "\n" )
        @refresh()

    mkdir: ( dir ) ->
        if not dir?
            dir = prompt( 'Name of the new directory', 'NewDir' )
            if not dir?
                return
        @queue_img_server_cmd( "mkdir " + @cur_dir + "/" + dir + "\n" )
        @refresh()
        
    rm: () ->
        l = ( ico.my_file for ico in @selected_icons( true ) )
        if l.length
            if confirm( "Do you want to delete " + l + " ?" )
                for f in l
                    @queue_img_server_cmd( "rm " + @cur_dir + "/" + f + "\n" )
            @refresh()
        else
            alert( "If you want to delete files, you first have to select them" )
    
    upload: ( files ) ->
        if not files?
            return @file_sel.click()
        for file in files
            fn = encodeURIComponent( @cur_dir + "/" + file.name )
            @send_data_to_server( file, "_upload_" + fn )

    # set images in the icon list div
    set_files: ( files ) ->
        pref_dir = ( a, b ) -> b[ 1 ].is_a_dir - a[ 1 ].is_a_dir or ( if b[ 0 ].toLowerCase() < a[ 0 ].toLowerCase() then 1 else -1 )
        @files = ( [ file, data ] for [ file, data ] in files when not ( file.match( "^\\." ) or file.match( "~$" ) ) ).sort( pref_dir )
        if @files.length
            @files[ 0 ][ 1 ].has_focus = true
        @update_ico_div()

    # drop handlers
    pass_func: ( evt ) ->
        evt.stopPropagation()
        evt.preventDefault()
        
    #
    drop_func: ( evt ) ->
        @pass_func( evt )
        @upload( evt.dataTransfer.files )

    to_element_of: ( evt ) ->
        if evt.toElement?
            return evt.toElement
        return evt.target

    change_ico_focus: ( wan_dir ) ->
        # find focused ico
        foc_ico = undefined
        for ico in @ico_div.childNodes
            if ico.my_data.has_focus
                foc_ico = ico
                break
        if not foc_ico?
            if @ico_div.length
                @ico_div.firstChild.has_focus = true
            return undefined
        foc_pos = [ foc_ico.offsetLeft, foc_ico.offsetTop ]
        ort_dir = [ - wan_dir[ 1 ], wan_dir[ 0 ] ]
        # find nearest ico in the 
        ddo_2 = ( a, b, c ) ->
            ( a[ 0 ] - b[ 0 ] ) * c[ 0 ] + ( a[ 1 ] - b[ 1 ] ) * c[ 1 ]
        dda_2 = ( a, b, c ) ->
            Math.abs( ddo_2( a, b, c ) )
        new_ico = undefined
        new_pos = undefined
        for ico in @ico_div.childNodes
            pos = [ ico.offsetLeft, ico.offsetTop ]
            if ddo_2( pos, foc_pos, wan_dir ) <= 0
                continue
            if not new_pos?
                new_ico = ico
                new_pos = pos
                continue
            if ddo_2( pos, foc_pos, wan_dir ) <= ddo_2( new_pos, foc_pos, wan_dir ) and
               dda_2( pos, foc_pos, ort_dir ) <= dda_2( new_pos, foc_pos, ort_dir )
                new_ico = ico
                new_pos = pos
        # change focus
        if new_ico?
            foc_ico.my_data.has_focus = false
            new_ico.my_data.has_focus = true
            foc_ico.make_bg()
            new_ico.make_bg()
        
    click_file: ( my_file, my_data ) ->
        if my_data.is_a_dir
            @cd( @cur_dir + "/" + my_file )
        if my_file.match( ".vtu$" )
            loc = "test_ScVisu_header.html?" + encodeURIComponent( "models=['" + @cur_dir + "/" + my_file + "'];" )
            if @open_win[ loc ]? and @open_win[ loc ].closed
                @open_win[ loc ] = undefined
            if @open_win[ loc ]?
                @open_win[ loc ].focus?()
                @open_win[ loc ].document.focus?()
            else
                @open_win[ loc ] = window.open( loc, loc )

    #
    update_foc_keys: ( n ) ->
        if @timer_for_foc_update?
            clearTimeout( @timer_for_foc_update )
            
        @foc_keys = n
        @foc_div.firstChild.data = @foc_keys
        
        if n.length
            # find old focus
            old_ico = undefined
            for ico in @ico_div.childNodes
                if ico.my_data.has_focus
                    old_ico = ico
                    break
            # find new focus
            new_ico = undefined
            for ico in @ico_div.childNodes
                if ico.my_file.indexOf( @foc_keys ) == 0
                    new_ico = ico
                    break
            if new_ico? and old_ico != new_ico
                old_ico.my_data.has_focus = false
                old_ico.make_bg()
                new_ico.my_data.has_focus = true
                new_ico.make_bg()
                   
            # timer
            @timer_for_foc_update = setTimeout( ( () => @update_foc_keys( "" ) ), 1000 )

    # update text in the location toolbar, according to @cur_dir
    update_dir_div: ( wd = @cur_dir ) ->
        while @dir_div.hasChildNodes()
            @dir_div.removeChild( @dir_div.firstChild )

        acc = ""
        for c in wd.split( "/" )
            if c.length == 0
                continue
            acc += c + "/"
            dir = document.createElement( "a" )
            dir.my_dir = acc
            dir.appendChild( document.createTextNode( c + "/" ) )
            dir.onmouseover = ( evt ) -> @style.color = '#9999FF'
            dir.onmouseout  = ( evt ) -> @style.color = '#000000'
            dir.onmousedown = ( evt ) => @cd( @to_element_of( evt ).my_dir )
            @dir_div.appendChild( dir )
        
        @foc_div = document.createElement( "a" )
        @foc_div.appendChild( document.createTextNode( "" ) )
        @foc_div.style.opacity = 0.5
        @dir_div.appendChild( @foc_div )
        
    # set images in the icon list div, according to @files
    update_ico_div: () -> 
        while @ico_div.hasChildNodes()
            @ico_div.removeChild( @ico_div.firstChild )
            
        [ x, y ] = [ 0, 18 ]
        dx = @icon_size * 3 / 2
        dy = @icon_size + 32
        for [ file, data ] in @files
            # div
            div = make_ch( @ico_div, {
                my_file   : file
                my_data   : data
                draggable : true
                
                make_bg : () ->
                    @style.background     = if @my_data.is_selected then ScBrowser.sel_background else ScBrowser.std_background
                    @style.textDecoration = if @my_data.has_focus   then "underline"              else "none"
                    @style.fontWeight     = if @my_data.has_focus   then "bold"                   else "normal"
                    
                ondragstart: ( evt ) =>
                    @drag_source = evt.target
                    while not @drag_source.my_file?
                        @drag_source = @drag_source.parentNode
                    
                    evt.dataTransfer.effectAllowed = if evt.ctrlKey then "copy" else "move"

                ondragover: ( evt ) =>
                    return false

                ondrop: ( evt ) =>
                    # get target
                    target = evt.target
                    while not target.my_file?
                        target = target.parentNode
                    
                    #
                    if target.my_data.is_a_dir
                        # console.log( @drag_source.my_file + " -> " + target.my_file )
                        old_dir = @cur_dir
                        @queue_img_server_cmd( "new_sel\n" )
                        @queue_img_server_cmd( "app_sel " + @cur_dir + "/" + @drag_source.my_file + "\n" )
                        @queue_img_server_cmd( "cd " + @cur_dir + "/" + target.my_file + "\n" )
                        @queue_img_server_cmd( if evt.dataTransfer.effectAllowed == "copy" then "copy\n" else "cut\n" )
                        @cd( old_dir )
                        
                    evt.stopPropagation()
                    return false

                onmouseup : ( evt ) =>
                    ori = @to_element_of( evt )
                    while not ori.my_file?
                        ori = ori.parentNode
                    if evt.ctrlKey
                        ori.my_data.is_selected = not ori.my_data.is_selected
                        ori.make_bg()
                        return
                    @click_file( ori.my_file, ori.my_data )
                        
            }, {
                #position  : "absolute"
                fontSize  : if chemins_absolus_SC then "0.8em" else "1em"
                textAlign : "center"
                overflow  : "hidden"
                #top       : y + 2
                #left      : x + 2
                #width     : dx - 4
                #height    : dy - 4
                width      : "120px"
                cssFloat   : "left"
                margin     : "5px 5px 5px 0"
            } )
            div.make_bg()
            
            # image src
            find_src = ( file, data ) ->
                for [ name, func ] in ScBrowser.img_list
                    if func( file, data )
                        if chemins_absolus_SC
                            return "/javascripts/SCVisu/scene/" + name
                        return name
            
            # icon
            img = make_ch( div, {
                src      : find_src( file, data )
            }, {
                #position  : "absolute"
                width      : @icon_size
                #top       : 0
                #left      : ( dx - 4 - @icon_size ) / 2
                #cssFloat    : "left"
            }, "img" )
            
            # text
            txt = make_ch( div, {}, {
                #position : "absolute"
                #top      : @icon_size
                #left     : 4
                #right    : 8
                width     : "100%"
                #fontSize  : 10
                #height   : dy - @icon_size
                cssFloat      : "left"
            }, "a" )
            txt.appendChild( document.createTextNode(
                file
            ) )
            
            # pos
            x += dx
            if x + dx >= @ico_div.clientWidth
                x = 0
                y += dy
            
            
            
            
            

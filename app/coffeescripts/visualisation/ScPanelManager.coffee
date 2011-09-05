# coffee -b --watch --compile *.coffee

#
class ScPanel_UnsplittedArea
    par : undefined  # ScPanelManager

    resize: ( p_min, p_max, b ) ->
        @p_min = ScPanelManager.copy( p_min ); @p_max = ScPanelManager.copy( p_max )
        @resize_UnsplittedArea( p_min, p_max )
    
    mk_split: ( d, p, o, new_func ) ->
        if p[ 0 ] >= @p_min[ 0 ] and p[ 1 ] >= @p_min[ 1 ] and p[ 0 ] < @p_max[ 0 ] and p[ 1 ] < @p_max[ 1 ]
            if p[ d ] > o[ d ]
                return new ScPanel_Split( @par, d, [ new_func( @par ), this ], [ p[ d ] ] )
            return new ScPanel_Split( @par, d, [ this, new_func( @par ) ], [ p[ d ] ] )
        return this

    rm_split: ( splitter, di ) ->
        return this

    size_box: ( p ) ->
        [ ScPanelManager.copy( @p_min ), ScPanelManager.copy( @p_max ) ]
        
    is_a_split: () -> 0

    selectable: () -> 1

    get_panels: ( panels ) -> panels.push( this )

#
class ScPanel_Div extends ScPanel_UnsplittedArea
    constructor: ( @par ) ->
        @div = document.createElement( 'div' )
        @div.style.position   = "absolute"
        @par.main_div.appendChild( @div )
            
    destructor: () ->
        @par.main_div.removeChild( @div )
        
    resize_UnsplittedArea: ( p_min, p_max ) ->
        ScPanelManager.resize_div( @div, p_min, p_max )

#
class ScPanel_Split
    # d = dim of cut plane
    constructor: ( @par, @d, @ch, @di, @drag_border ) ->
        # clickable drag_border
        if not @drag_border?
            @drag_border = document.createElement( 'div' )
            @drag_border.style.position   = "absolute"
            @drag_border.style.background = "#FFFFFF"
            @drag_border.onmousedown = ( evt ) => @border_mouse_down( evt )
            @par.main_div.appendChild( @drag_border )
            
    destructor: () ->
        @par.main_div.removeChild( @drag_border )
        for c in @ch
            c.destructor()

    get_panels: ( panels ) ->
        for c in @ch
            c.get_panels( panels )
        
    resize: ( p_min, p_max, b ) ->
        if @p_min?
            @di[ 0 ] = p_min[ @d ] + ( p_max[ @d ] - p_min[ @d ] ) * ( @di[ 0 ] - @p_min[ @d ] ) / ( @p_max[ @d ] - @p_min[ @d ] )
        @p_min = ScPanelManager.copy( p_min )
        @p_max = ScPanelManager.copy( p_max )
        @b = b
        
        # ch[ ... ].resize
        p_max_0 = ScPanelManager.copy( @p_max ); p_max_0[ @d ] = @di[ 0 ] - b / 2
        p_min_1 = ScPanelManager.copy( @p_min ); p_min_1[ @d ] = @di[ 0 ] + b / 2
        @ch[ 0 ].resize( p_min, p_max_0, @b )
        @ch[ 1 ].resize( p_min_1, p_max, @b )

        # drag_border
        @update_drag_border( @drag_border )
        
    update_drag_border: ( db ) ->
        p_min_b = ScPanelManager.copy( @p_min ); p_min_b[ @d ] = @di[ 0 ] - @b / 2
        p_max_b = ScPanelManager.copy( @p_max ); p_max_b[ @d ] = @di[ 0 ] + @b / 2
        ScPanelManager.resize_div( db, p_min_b, p_max_b )

    border_mouse_down: ( evt ) ->
        evt = window.event if not evt?

        # drag_border
        @par.main_div.appendChild( @par.drag_border )
        @update_drag_border( @par.drag_border )
        
        # mouse
        @par.main_div.onmouseup   = ( evt ) => @border_mouse_up( evt )
        @par.main_div.onmouseout  = ( evt ) => @border_mouse_out( evt )
        @par.main_div.onmousemove = ( evt ) => @border_mouse_move( evt )

        evt.preventDefault?()
        evt.returnValue = false
        return false
        
    border_mouse_move: ( evt ) ->
        evt = window.event if not evt?
        
        @di[ 0 ] = [ evt.clientX - @par.getLeft( @par.main_div ), evt.clientY - @par.getTop( @par.main_div ) ][ @d ]
        @update_drag_border( @par.drag_border )

    border_mouse_out: ( evt ) ->
        evt = window.event if not evt?
        
        from = evt.relatedTarget || evt.toElement
        if not from or from.nodeName == "HTML"
            @par.main_div.onmouseup   = null
            @par.main_div.onmouseout  = null
            @par.main_div.onmousemove = null
            @par.main_div.removeChild( @par.drag_border )
            #
            @par.rm_split( this, @di )
            @par.resize()
            
    border_mouse_up: ( evt ) ->
        @par.main_div.onmouseup   = null
        @par.main_div.onmouseout  = null
        @par.main_div.onmousemove = null
        @par.main_div.removeChild( @par.drag_border )
        
        if @di[ 0 ] < @p_min[ @d ] + @b or @di[ 0 ] >= @p_max[ @d ] - @b
            @par.rm_split( this, @di )
        @par.resize()
        
    size_box: ( p ) ->
        return @ch[ 1 * ( p[ @d ] >= @di[ 0 ] ) ].size_box( p )
    
    mk_split: ( d, p, o, new_func ) ->
        l = []
        for c in @ch
            l.push( c.mk_split( d, p, o, new_func ) )
        return new ScPanel_Split( @par, @d, l, @di, @drag_border )
        
    rm_split: ( splitter, di ) ->
        eq = ( a, b ) -> a.p_min[ 0 ] == b.p_min[ 0 ] and a.p_min[ 1 ] == b.p_min[ 1 ] and a.p_max[ 0 ] == b.p_max[ 0 ] and a.p_max[ 1 ] == b.p_max[ 1 ]
        if eq( splitter, this )
            @par.main_div.removeChild( @drag_border )
            n = 1 * ( di[ 0 ] < 0.5 * ( @p_min[ @d ] + @p_max[ @d ] ) )
            m = 1 - n
            @ch[ n ].resize( @p_min, @p_max, @b )
            @ch[ m ].destructor()
            return @ch[ n ]
        # else
        l = []
        for c in @ch
            l.push( c.rm_split( splitter, di ) )
        return new ScPanel_Split( @par, @d, l, @di, @drag_border )
        
    is_a_split: () ->
        true


# s = new ScPanelManager(  )
class ScPanelManager
    main_div    : undefined # th div which contains all this
    container   : undefined # ScPanel_Div, ScPanel_Split, ...
    border_list : undefined # clickable border list
    drag_border : undefined # transparent tmp border, for dragging
    border_size : undefined # in pixel
    new_func    : undefined # metohod called when a new pane has to be created

    constructor: ( div_ref, @border_size = 10, @new_func = undefined ) ->
        # @main_div
        @main_div  = if typeof div_ref == "string" then document.getElementById( div_ref ) else div_ref
        
        # @container
        @container = @new_func( this )
        
        # drag_border
        @drag_border = document.createElement( 'div' )
        @drag_border.style.position   = "absolute"
        @drag_border.style.opacity    = 0.5
        @drag_border.style.background = "#FFFFFF"

        # border_list
        @border_list = []
        for s in [ 0 .. 3 ]
            border = document.createElement( 'div' )
            border.style.position = "absolute"
            border.style.background = "#FFFFFF"
            @main_div.appendChild( border )
            @border_list.push( border )

        @border_list[ 0 ].style.left   = 0
        @border_list[ 0 ].style.top    = @border_size
        @border_list[ 0 ].style.width  = @border_size
        @border_list[ 0 ].style.bottom = @border_size

        @border_list[ 1 ].style.left   = @border_size
        @border_list[ 1 ].style.top    = 0
        @border_list[ 1 ].style.right  = @border_size
        @border_list[ 1 ].style.height = @border_size

        @border_list[ 2 ].style.right  = 0
        @border_list[ 2 ].style.top    = @border_size
        @border_list[ 2 ].style.width  = @border_size
        @border_list[ 2 ].style.bottom = @border_size

        @border_list[ 3 ].style.left   = @border_size
        @border_list[ 3 ].style.bottom = 0
        @border_list[ 3 ].style.right  = @border_size
        @border_list[ 3 ].style.height = @border_size

        # not done in a for loop... due to pointer / ref javascript crap
        @border_list[ 0 ].onmousedown = ( evt ) => @border_mouse_down( 0, evt )
        @border_list[ 1 ].onmousedown = ( evt ) => @border_mouse_down( 1, evt )
        @border_list[ 2 ].onmousedown = ( evt ) => @border_mouse_down( 0, evt )
        @border_list[ 3 ].onmousedown = ( evt ) => @border_mouse_down( 1, evt )
        
        # 
        window.onresize = ( evt ) => @resize()
        @resize()

    panels: () ->
        res = []
        @container.get_panels( res )
        return res

    split_at: ( dim, pos_mouse_move, pos_mouse_down ) ->
        @container = @container.mk_split( dim, pos_mouse_move, pos_mouse_down, @new_func )
        @resize()
            
    # position de l'objet / window
    getLeft: ( l ) -> if l.offsetParent? then l.offsetLeft + @getLeft( l.offsetParent ) else l.offsetLeft

    # position de l'objet / window
    getTop:  ( l ) -> if l.offsetParent? then l.offsetTop  + @getTop(  l.offsetParent ) else l.offsetTop
            
    border_mouse_down: ( d, evt ) ->
        evt = window.event if not evt?
        @pos_mouse_down = [ evt.clientX - @getLeft( @main_div ), evt.clientY - @getTop( @main_div ) ]

        # drag_border
        @main_div.appendChild( @drag_border )
        @update_drag_border( d, @pos_mouse_down )
        
        # mouse
        @main_div.onmouseup   = ( evt ) => @border_mouse_up( d, evt )
        @main_div.onmouseout  = ( evt ) => @border_mouse_out( d, evt )
        @main_div.onmousemove = ( evt ) => @border_mouse_move( d, evt )

        evt.preventDefault?()
        evt.returnValue = false
        return false
        
    border_mouse_move: ( d, evt ) ->
        evt = window.event if not evt?
        @update_drag_border( d, [ evt.clientX - @getLeft( @main_div ), evt.clientY - @getTop( @main_div ) ] )

    border_mouse_out: ( d, evt ) ->
        evt = window.event if not evt?
        
        from = evt.relatedTarget || evt.toElement
        if not from or from.nodeName == "HTML"
            @main_div.onmouseup   = null
            @main_div.onmouseout  = null
            @main_div.onmousemove = null
            @main_div.removeChild( @drag_border )
            
    border_mouse_up: ( d, evt ) ->
        @main_div.onmouseup   = null
        @main_div.onmouseout  = null
        @main_div.onmousemove = null
        @main_div.removeChild( @drag_border )

        @split_at( d, [ evt.clientX - @getLeft( @main_div ), evt.clientY - @getTop( @main_div ) ], @pos_mouse_down )
            
    update_drag_border: ( d, p ) ->
        [ p_min, p_max ] = @container.size_box( p )
        p_min[ d ] = p[ d ] - @border_size / 2
        p_max[ d ] = p[ d ] + @border_size / 2
        ScPanelManager.resize_div( @drag_border, p_min, p_max )

    # make a new container without the Splitter named splitter
    rm_split: ( splitter, di ) ->
        @container = @container.rm_split( splitter, di )

    # utility function
    @resize_div: ( obj, p_min, p_max ) ->
        obj.style.left     = p_min[ 0 ]
        obj.style.top      = p_min[ 1 ]
        obj.style.width    = p_max[ 0 ] - p_min[ 0 ]
        obj.style.height   = p_max[ 1 ] - p_min[ 1 ]
    
    @copy: ( l ) ->
        r = []
        for c in l
            r.push( c )
        return r
 
    resize: () ->
        w = @main_div.clientWidth
        h = @main_div.clientHeight
        b = @border_size
    
        # container
        @container.resize( [ b, b ], [ w - b, h - b ], b )

window.SCVisu = {} unless window.SCVisu?


window.SCVisu.ScPanelManager          = ScPanelManager        
window.SCVisu.ScPanel_Div             = ScPanel_Div           
window.SCVisu.ScPanel_Split           = ScPanel_Split         
window.SCVisu.ScPanel_UnsplittedArea  = ScPanel_UnsplittedArea


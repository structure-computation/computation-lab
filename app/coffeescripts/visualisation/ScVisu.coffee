# coffee -b --watch --compile *.coffee

window.SCVisu = {} unless window.SCVisu?


# ScPanel_UnsplittedArea which contain a canvas with a model
class ScPanel_Visu extends window.SCVisu.ScPanel_UnsplittedArea
    sc_disp : undefined
    item_id : undefined
    
    constructor: ( @par, models_to_load = [], field_to_display = undefined, @info_pane ) ->
        @canvas = document.createElement( 'canvas' )
        @canvas.style.position = "absolute"
        par.main_div.appendChild( @canvas )

        @sc_disp = new window.SCVisu.ScDisp( @canvas )
        @sc_disp.click_fun.push( 
            ( sc_disp, evt ) =>
                for p in @par.panels() when p.sc_disp?
                    p.sc_disp.selected = 0
                sc_disp.selected = 1
                for p in @par.panels() when p.sc_disp?
                    p.sc_disp.draw()
                @info_pane.disp_sc_disp( @item_id )
        )
        for p in @par.panels() when p.sc_disp?
            p.sc_disp.selected = 0
        @sc_disp.selected = 1
        
        # axes
        @sc_disp.add_item( new window.SCVisu.ScItem_GradiendBackground( [
            [ 0.0, "rgb( 0, 0,   0 )" ],
            [ 0.5, "rgb( 0, 0,  40 )" ],
            [ 1.0, "rgb( 0, 0, 200 )" ]
        ] ) )
        
        # model
        m = new window.SCVisu.ScItem_Model()
        @item_id = m.item_id
        for l in models_to_load
            if typeof( l ) == "string"
                m.load_vtu( l )
            else
                m.load_hdf( l[ 0 ], l[ 1 ] )
        if field_to_display?
            if typeof( field_to_display ) == "string"
                m.color_by_field( field_to_display )
            else
                m.color_by_field( field_to_display[ 0 ], field_to_display[ 1 ] )
        m.linked_panes.push( @info_pane )
        m.get_info()
        m.fit()
        # s.get_num_group_info( "num_group_info" )
        @sc_disp.add_item( m )
        
        @sc_disp.add_item( new window.SCVisu.ScItem_Axes( "lb" ) )
            
    destructor: () ->
        @par.main_div.removeChild( @canvas )

    resize_UnsplittedArea: ( p_min, p_max ) ->
        @sc_disp.canvas.width  = p_max[ 0 ] - p_min[ 0 ]
        @sc_disp.canvas.height = p_max[ 1 ] - p_min[ 1 ]
        ScPanelManager.resize_div( @sc_disp.canvas, p_min, p_max )
        
        @sc_disp.draw()

#
class ScPanel_VisuInfoDiv extends ScPanel_Div
    class VisuInfo
        div        : undefined 
        info       : undefined # info from server
        field_but  : undefined # list of field buttons
        sc_item_id : undefined # 
        
        constructor: ( @info, @sc_item_id ) ->
            @field_but = []
            
            @div = document.createElement( "div" )
            @div.className = "ui-accordion ui-widget ui-helper-reset"
            @div.style.overflowX = "hidden"
            @div.style.overflowY = "auto"
            @div.style.height = "100%"
             
            # helper
            add_option = ( sele, name ) ->
                opti = document.createElement( "option" )
                opti.appendChild( document.createTextNode( name ) )
                opti.value = name
                sele.appendChild( opti )

            # select color by
            div_colo = @make_accordion( "Color by" )
            sele = document.createElement( "select" )
            sele.style.width = "100%"
            sele.className = "ui-state-default"
            sele.onchange = ( evt ) =>
                item = ScClient.get_item_by_id( @sc_item_id )
                item.color_by_field( evt.currentTarget.value )
                item.redraw_containers()
                
            add_option( sele, "none" )
            for name, val of @info.fields
                if val.nb_comp > 1
                    for i in [ 0 .. val.nb_comp - 1 ]
                        add_option( sele, name + "[" + i + "]" )
                else
                    add_option( sele, name )
            div_colo.appendChild( sele )

            # warp by
            div_warp = @make_accordion( "Warp by" )
            sele = document.createElement( "select" )
            sele.style.width = "100%"
            sele.className = "ui-state-default"
            
            add_option( sele, "none" )
            for name, val of @info.fields when val.nb_comp >= 2
                add_option( sele, name )
            div_warp.appendChild( sele )
                
        make_accordion: ( title ) ->
            h3 = document.createElement( "h3" )
            h3.className = "NC_top_box ui-accordion-header ui-helper-reset ui-state-default "
            #h3.className = "NC_top_box "
            
            sp = document.createElement( "span" )
            sp.className = "ui-icon ui-icon-triangle-1-s"
            h3.appendChild( sp )
            
            al = document.createElement( "a" )
            al.appendChild( document.createTextNode( title ) )
            al.style.textIndent = 16
            h3.appendChild( al )
            
            @div.appendChild( h3 )
            
            re = document.createElement( "div" )
            re.className = "ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom ui-accordion-content-active"
            @div.appendChild( re )
            
            h3.onmousedown = ( evt ) ->
                if re.style.display == "none"
                    re.style.display = "block"
                    sp.className = sp.className.replace( "ui-icon-triangle-1-e", "ui-icon-triangle-1-s" )
                else
                    re.style.display = "none"
                    sp.className = sp.className.replace( "ui-icon-triangle-1-s", "ui-icon-triangle-1-e" )
            
            return re


    @cur_id   : 0 # next free id for next instanciation
    @all_it   : [] # all items
    @item_id  : 0

    info_for  : undefined # list of VisuInfo
    tab_div   : undefined # tabs for selection of window

    constructor: ( par ) ->
        ScPanel_Div.prototype.constructor( par )
        
        # register
        @item_id = ScPanel_VisuInfoDiv.cur_id
        ScPanel_VisuInfoDiv.cur_id += 1
        ScPanel_VisuInfoDiv.all_it.push( this )

        #
        @info_for = new Object()
        
        # color
        #r = Math.floor( Math.random() * 255 );
        #g = Math.floor( Math.random() * 255 );
        #b = Math.floor( Math.random() * 255 );
        #@div.style.background = "rgb( " + r + ", " + g + ", " + b + " )";

    selectable: () -> 0

    @get_item_by_id: ( obj_id ) ->
        for o in ScPanel_VisuInfoDiv.all_it
            if o.item_id == obj_id
                return o
        alert( "item_id not found " + obj_id )
        
    disp_sc_disp: ( sc_item_id ) ->
        for key, val of @info_for
            try
                @div.removeChild( val.div )
            catch error
                undefined
        @div.appendChild( @info_for[ sc_item_id ].div )

    set_info: ( info, sc_item_id ) ->
        # tabs 
        # @mk_tab_div()
        # new div
        for key, val of @info_for
            try
                @div.removeChild( val.div )
            catch error
                undefined
            
        @info_for[ sc_item_id ] = new window.SCVisu.VisuInfo( info, sc_item_id )
        
        @div.appendChild( @info_for[ sc_item_id ].div )

    #mk_tab_div: () ->
        ## rm old
        #if @tab_div?
            #@div.removeChild( @tab_div )

        ## make a new
        #nb_ch = 1
        #for key, val of @info_for
            #nb_ch += 1

        #if nb_ch >= 2
            #@tab_div = document.createElement( "div" )
            #@tab_div.className = "ui-tabs ui-widget ui-widget-content ui-corner-all"
            
            #ul = document.createElement( "ul" )
            #ul.className = "ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all"
            #@tab_div.appendChild( ul )

            #for i in [ 1 .. nb_ch ]
                #li = document.createElement( "li" )
                #li.className = "ui-state-default ui-corner-top"
                #if i == nb_ch
                    #li.className += " ui-tabs-selected ui-state-active"
                #ul.appendChild( li )

                #a = document.createElement( "a" )
                #a.appendChild( document.createTextNode( "T" + i ) )
                #li.appendChild( a )
           
            #@div.appendChild( @tab_div )
            #@div.className = "ui-tabs-panel ui-widget-content ui-corner-bottom"

# s = new ScVisu
# requires ScPanelManager.js and ScDisp.js
# field_to_display can be a string or a [ string, int ] (value, num component)
class ScVisu
    panel_manager  : undefined
    models_to_load : undefined
    info_pane      : undefined # info div
    
    constructor: ( div_ref, @models_to_load = [], @field_to_display = undefined, border_size = 10 ) ->
        @panel_manager = new ScPanelManager( div_ref, border_size, ( par ) => @create_pane( par ) )

    create_pane: ( par ) ->
        if not par.container?
            res = new ScPanel_VisuInfoDiv( par )
            @info_pane = res
            return res
            
        # ScDisp
        return new ScPanel_Visu( par, @models_to_load, @field_to_display, @info_pane )
        
    panels: () ->
        return @panel_manager.panels()



# On crée un espace SCVisu si il n'existe pas déjà.
window.SCVisu = {} unless window.SCVisu?
  
# Et l'on y rend accessibles les classes définies dans ce fichier :
window.SCVisu.ScPanel_Visu        = ScPanel_Visu       
window.SCVisu.ScPanel_VisuInfoDiv = ScPanel_VisuInfoDiv
window.SCVisu.ScVisu              = ScVisu             

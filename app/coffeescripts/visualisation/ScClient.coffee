# class to speak to a Sc Client
class ScClient
   @cur_id : 0 # next free id for next instanciation
   @all_it : [] # all items
   
   item_id    : undefined
   session_id : 0 # number returned by the server
   cmd_list   : undefined # command to be sent
   port       : undefined # port of the server

   init_ScClient: ( @port = "00" ) -> 
       ScClient.all_it.push( this )
       
       @item_id = ScClient.cur_id
       ScClient.cur_id += 1
       
       window.onunload = ( evt ) =>
           @queue_img_server_cmd( "close_session\n" )
           @flush_img_server_cmd()
       
       @cmd_list = ""

   # used to extend
   @make_child: ( obj ) ->
       for name, method of ScClient.prototype
           obj.prototype[ name ] = method

   @get_item_by_id: ( obj_id ) ->
       for o in ScClient.all_it
           if o.item_id == obj_id
               return o
       alert "item_id '" + obj_id + "' not found "

   queue_img_server_cmd: ( cmd ) ->
       @cmd_list += cmd

   flush_img_server_cmd: ()->
       if @session_id == 0
           @cmd_list = 'set_item_id ' + @item_id + '\nget_session_id\n' + @cmd_list
       @send_data_to_server( @cmd_list )
       @cmd_list = ""
       
   send_data_to_server: ( data, opt_cmd = "" )->
       #@send_async_xml_http_request( "/img_server_" + @port + "?" + @session_id + opt_cmd, data, ( ( rep ) ->
       data1 = @session_id + opt_cmd + "\n" + data
       #alert SCVisu.visualisation.data1
       $.post("/visualisation/update",{data: data1},
          (response) ->
            SCVisu.NOTIFICATIONS.close()
            c = {}
            #alert response
            eval response
            if c.err and c.err.length
               alert c.err
       )
       
   
       #@send_async_xml_http_request( "/visualisation/update", '{' + @session_id + opt_cmd + data + '}' , ( ( rep ) ->                                                                                            
       #    c = {}
       #    eval rep
       #    if c.err and c.err.length
       #        alert c.err
       #) )

   my_xml_http_request: ->
       if window.XMLHttpRequest # Firefox
           return new XMLHttpRequest()
       if ( window.ActiveXObject ) # Internet Explorer
           return new ActiveXObject( "Microsoft.XMLHTTP" )
       alert( "Votre navigateur ne supporte pas les objets XMLHTTPRequest..." )

   send_async_xml_http_request: ( url, data, func ) ->
       xhr_object = @my_xml_http_request()
       xhr_object.open( "POST", url, true )
       xhr_object.onreadystatechange = ->
           if this.readyState == 4 && this.status == 200
               func( this.responseText )
       alert data
       xhr_object.send( data )
       

window.SCVisu = {} unless window.SCVisu?

window.SCVisu.ScClient                     = ScClient
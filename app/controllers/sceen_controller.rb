class SceenController < ApplicationController
  before_filter :authenticate_user!
  layout "application_ext_app"
  def index
    #@page = :home # Pour afficher le menu en selected.
    render :layout => false 
  end
  
#   def cmd
#     
#     #logger.debug params
#     #request = params[:data] + "$"
#     logger.debug request.raw_post
#     
#     host = 'localhost'     # The web server
#     port = 8888                           # Default HTTP port
#     logger.debug "avant open cmd"
#     logger.debug "avant print"
#     socket = TCPSocket.open(host,port)  # Connect to server
#     socket.write( "POST /sceen/cmd \n\n" + request.raw_post ) # Send request
#     #debugger
#     logger.debug "avant read cmd"
#     response = socket.read              # Read complete response
#     socket.close
#     #logger.debug response
#     logger.debug "après read cmd"
#     response1 = response.split(/\n\n/).drop(1).join("\n\n")
#     render :text => response1
#     
#   end
  
  def _
    #debugger
    #logger.debug params
    #request = params[:data] + "$"
    #logger.debug request
    
    host = 'localhost'     # The web server
    port = 8888                           # Default HTTP port
    logger.debug "avant open _"
    socket = TCPSocket.open(host,port)  # Connect to server
    #logger.debug  request.method + " " + request.fullpath + " \n\n" + request.raw_post 
    #socket.print( "POST /sceen/_ \n\n" + request.raw_post ) # Send request
    logger.debug "avant print  _"
    socket.write( request.method + " " + request.fullpath + " \n\n" + request.raw_post ) # Send request
    #debugger
    logger.debug "avant read _"
    response = socket.read              # Read complete response
    socket.close
    #logger.debug response
    logger.debug "après read _"
    #     response1 = response.split(/\n\n/).drop(1).join("\n\n")
    logger.debug response
    render :text => response
  end

end
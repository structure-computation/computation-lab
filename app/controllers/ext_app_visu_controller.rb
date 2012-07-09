class ExtAppVisuController < ApplicationController
  layout "application_ext_app"
  def index
    #@page = :home # Pour afficher le menu en selected.
    render :layout => false 
  end
  
  def update
    request = params[:data]
    
    logger.debug params[:data].size()
    request = params[:data] + "$"
    logger.debug request
    
    host = 'localhost'     # The web server
    port = 8888                           # Default HTTP port

    socket = TCPSocket.open(host,port)  # Connect to server
    socket.print(request)               # Send request
    response = socket.read              # Read complete response
    #logger.debug response
    
    render :text => response
  end
  
end

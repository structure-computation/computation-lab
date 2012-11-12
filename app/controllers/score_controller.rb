class ScoreController < ApplicationController
  before_filter :authenticate_user!
  layout "application_ext_app"
  
  def index
    @current_model = current_workspace_member.sc_models.find(params[:sc_model_id])
    @current_model.tool_in_use("sceen", current_workspace_member)
    @model_id = params[:sc_model_id]
    #@page = :home # Pour afficher le menu en selected.
    render :layout => false 
  end
  
  def upload
    host = 'localhost'     # The web server
    port = 8888                           # Default HTTP port
    socket = TCPSocket.open(host,port)  # Connect to server
    logger.debug  request.method + " " + request.fullpath + " \n\n" + request.raw_post 
    socket.write( request.method + " " + request.fullpath + " \n\n" + request.raw_post ) # Send request
    response = socket.read              # Read complete response
    socket.close
    logger.debug response
    render :text => response
  end
  
  
  def _ 
    host = 'localhost'     # The web server
    port = 8888                           # Default HTTP port
    socket = TCPSocket.open(host,port)  # Connect to server
    length = request.raw_post.length
    file = request.raw_post.to_s
    logger.debug  "request.raw_post.length = " + length.to_s
    logger.debug  "request.raw_post = " + file
    socket.write( request.method + " " + request.fullpath + " Content-Length: " + length.to_s + " \n\n" + request.raw_post ) # Send request
    response = socket.read              # Read complete response
    socket.close
    logger.debug response
    render :text => response
  end
  
  
end

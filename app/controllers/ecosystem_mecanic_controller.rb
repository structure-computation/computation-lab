# encoding: utf-8

class EcosystemMecanicController < ApplicationController  
  before_filter :authenticate_user!
  
  def index
#     if params[:sc_model_id] 
#       @current_model = current_workspace_member.sc_models.find(params[:sc_model_id])
#     else
#       @current_model = current_workspace_sc_model
#     end
#     session[:current_workspace_sc_model_id] = @current_model.id
    current_workspace_member.workspace.tool_in_use("EcosystemMecanic", current_workspace_member)
#     @model_id = params[:sc_model_id]
    #@page = :home # Pour afficher le menu en selected.
  end
  
  
  # TODO: Cette action n'est peut être plus utilisée. A valider.
  def upload
    host = 'localhost'     # The web server
    port = 8888                           # Default HTTP port
    socket = TCPSocket.open(host,port)  # Connect to server
    #logger.debug  request.method + " " + request.fullpath + " \n\n" + request.raw_post  
    socket.write( request.method + " " + request.fullpath + " \n\n" + request.raw_post ) # Send request
    response = socket.read              # Read complete response
    socket.close
    render :text => response
  end
  
  # Action qui fait le passage entre l'appel HTTP et SODA.
  # Cette action est appellée par les API SOJA (appellé par le filesystem SOJA).
  def _
    host = 'localhost'     # The web server
    port = 8888                           # Default HTTP port
    socket = TCPSocket.open(host,port)  # Connect to server
    length = request.raw_post.length
    #logger.debug  "request.method = " + request.method + " " + request.fullpath + " \n\n" + request.raw_post 
    #logger.debug  "request.raw_post.length = " + length.to_s
    socket.write( request.method + " " + request.fullpath + " Content-Length: " + length.to_s + " \n\n" + request.raw_post ) # Send request
    response = socket.read              # Read complete response
    socket.close
    render :text => response
  end
end

class VisualisationController < ApplicationController
  require 'json'
  require 'socket'
  include Socket::Constants
  before_filter :authenticate_user!
  
  def index
    @page = 'SCcompute'
    @id_model = params[:id_model]
    current_model = current_workspace_member.sc_models.find(@id_model)
    @dim_model = current_model.dimension
    respond_to do |format|
      format.html {render :layout => false }
    end 
  end
  
  def info_model
    @id_model = params[:id_model]  
    
    # lecture du fichier sur le disque
    path_to_file = "#{SC_MODEL_ROOT}/model_#{@id_model}/MESH/mesh.txt"
    results = File.read(path_to_file)
    
    render :json => results
  end
  
  def launch_visu_server
    result = system("cd /home/scproduction/code_dev/Visu; make;")
    #stdin, stdout, stderr = Open3.popen3("cd /home/jbellec/code_dev/Visu; make;") 
    render :text => result
  end
  
  def update
    request = params[:data]
    
    logger.debug params[:data].size()
    request = params[:data] + "$"
    logger.debug request
    
    host = 'localhost'     # The web server
    port = 10001                           # Default HTTP port

    socket = TCPSocket.open(host,port)  # Connect to server
    socket.print(request)               # Send request
    response = socket.read              # Read complete response
    #logger.debug response
    
    render :text => response
  end
  
  
end

class VisualisationController < ApplicationController
  require 'json'
  require 'socket'
  include Socket::Constants
  before_filter :login_required , :except => :calcul_valid
  
  def index
    @page = 'SCcompute'
    @id_model = params[:id_model]
    current_model = @current_user.sc_models.find(@id_model)
    @dim_model = current_model.dimension
    respond_to do |format|
      format.html {render :layout => false }
    end 
  end
  
  def info_model
    @id_model = params[:id_model]  
    # création des elements a envoyer au calculateur
    send_data  = { :id_model => @id_model, :mode => "info_model"};
    
    # socket d'envoie au serveur
    socket    = Socket.new( AF_INET, SOCK_STREAM, 0 )
    sockaddr  = Socket.pack_sockaddr_in( 12346, 'localhost' )
    #sockaddr  = Socket.pack_sockaddr_in( 12346, 'sc2.ens-cachan.fr' )
    socket.connect( sockaddr )
    socket.write( send_data.to_json )
    
    # reponse du calculateur
    results = socket.read
    
    #fic =File.open("/home/scproduction/MODEL/model_#{id_model}/MESH/mesh.txt",'r')
    
    respond_to do |format|
      format.js   {render :json => results}
    end
  end
  
end

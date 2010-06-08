class DetailModelController < ApplicationController
  require 'socket'
  require 'json'
  include Socket::Constants
  before_filter :login_required,  :except => :mesh_valid

  
  def index
    @page = 'SCcompute'
    @id_model = params[:id_model]
    @current_model = @current_user.sc_models.find(@id_model)
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @current_model.to_json}
    end 
  end
  
  def get_list_resultat
    @id_model = params[:id_model]
    current_model = @current_user.sc_models.find(@id_model)
    list_resultats = current_model.calcul_results.find(:all, :conditions => {:state => "finish"})
    respond_to do |format|
      format.js   {render :json => list_resultats.to_json}
    end 
  end
  
   def get_list_utilisateur
    @id_model = params[:id_model]
    current_model = @current_user.sc_models.find(@id_model)
    list_role_utilisateurs = current_model.user_sc_models
    @users = []
    list_role_utilisateurs.each{ |utilisateur_i| 
      user = Hash.new
      user['user'] = Hash.new 
      user['user'] = { :email  => utilisateur_i.user.email, :name => utilisateur_i.user.firstname + " " + utilisateur_i.user.lastname, :role => utilisateur_i.role }
      @users << user
    }
    # list_utilisateurs = current_model.users
    respond_to do |format|
      format.js   {render :json => @users.to_json}
    end 
  end
  
  def send_mesh
    @id_model = params[:id_model]
    current_model = @current_user.sc_models.find(@id_model)
    file = params[:fichier]
    
    # création des elements a envoyer au calculateur
    identite_calcul = { :id_societe => current_model.company.id, :id_user => @current_user.id,         :id_projet => '', :id_model => current_model.id, :id_calcul => '', :dimension  => current_model.dimension};
    priorite_calcul = { :priorite => 0 };                               
    mesh            = { :mesh_directory => "MESH", :mesh_name  => "mesh", :extension  => ".bdf"};
    
    json_model        = { :identite_calcul => identite_calcul, :priorite_calcul => priorite_calcul, :mesh => mesh}; 
    
    send_data       = { :id_user => @current_user.id, :json_model => json_model,:fichier => file.read, :mode => "create"};
    
    # socket d'envoie au serveur
    socket    = Socket.new( AF_INET, SOCK_STREAM, 0 )
    sockaddr  = Socket.pack_sockaddr_in( 12346, 'localhost' )
    #sockaddr  = Socket.pack_sockaddr_in( 12346, 'sc2.ens-cachan.fr' )
    socket.connect( sockaddr )
    socket.write( send_data.to_json )
    #socket.write( file.read )
    
    # reponse du calculateur
    results = socket.read
    current_model.state = 'in_process'
    current_model.save
    
    # envoie de la reponse au client
    render :text => results
  end
  
  def mesh_valid
    @id_model = params[:id_model]
    @current_model = ScModel.find(@id_model)
    @current_model.mesh_valid(params[:id_user],params[:time],params[:json])
    render :text => { :result => 'success' }
  end
  
  def download
    @id_model = params[:id_model]
    @id_resultat = params[:id_resultat]
    #name_file = '/home/scproduction/MODEL/model_' + @id_model + '/calcul_' + @id_resultat + '/resultat_0_0.vtu'
    
    send_data  = { :id_model => @id_model, :id_resultat => @id_resultat, :mode => "download"};
    
    # socket d'envoie au serveur
    socket    = Socket.new( AF_INET, SOCK_STREAM, 0 )
    sockaddr  = Socket.pack_sockaddr_in( 12346, 'localhost' )
    #sockaddr  = Socket.pack_sockaddr_in( 12346, 'sc2.ens-cachan.fr' )
    socket.connect( sockaddr )
    socket.write( send_data.to_json )
    
    # reponse du calculateur
    results = socket.read
    
    # envoie du fichier en telechargement
    name_resultats = 'result_' + @id_resultat + '.vtu'
    send_data results, :filename => name_resultats

    #send_file name_file
  end
 
end

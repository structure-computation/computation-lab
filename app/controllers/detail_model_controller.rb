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
    list_resultats = current_model.calcul_results
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
    @id_user = params[:id_user]
    @id_model = params[:id_model]
    @time = params[:time]
    @current_user = User.find(@id_user)
    @current_model = ScModel.find(@id_model)
    jsonobject = JSON.parse(params[:json])

    @current_model.parts = jsonobject[0]['mesh']['nb_groups_elem']
    @current_model.interfaces = jsonobject[0]['mesh']['nb_groups_inter']
    @current_model.state = 'active'
    
    @calcul_result = @current_model.calcul_results.build(:calcul_time => @time, :ctype => 'create', :state => 'finish', :gpu_allocated => 1) 
    @calcul_result.user = @current_user
    
    @current_model.save
    @calcul_result.save
    
    render :text => { :result => 'success' }
  end
  
end

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
    list_resultats = current_model.calcul_results.find(:all, :conditions => {:log_type => "compute", :state => "finish"})
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
  
  def get_list_utilisateur_new
    @current_company = @current_user.company
    list_utilisateur_new = @current_company.users
    @users = []
    list_utilisateur_new.each{ |utilisateur_i| 
      user = Hash.new
      user['user'] = Hash.new 
      user['user'] = { :id => utilisateur_i.id, :email  => utilisateur_i.email, :name => utilisateur_i.firstname + " " + utilisateur_i.lastname, :role => utilisateur_i.role }
      @users << user
    }
    # list_utilisateurs = current_model.users
    respond_to do |format|
      format.js   {render :json => @users.to_json}
    end 
  end
  
  def valid_new_utilisateur
    @id_model = params[:id_model]
    @current_model = @current_user.sc_models.find(@id_model)
    @current_company = @current_model.company
    jsonobject = JSON.parse(params[:file])
    num_user = 0
    jsonobject.each{ |utilisateur_i| 
            user = @current_company.users.find(utilisateur_i['user']['id']) 
            if(@current_model.users.exists?(user.id))
            else
		@current_model.users << user
		num_user += 1
            end
    }
    # list_utilisateurs = current_model.users
    render :text => 'membres correstement ajoutés au modèle'
  end
  
  def send_mesh
    @id_model = params[:id_model]
    current_model = @current_user.sc_models.find(@id_model)
    
    # on enregistre les fichier sur le disque et on change les droit pour que le serveur de calcul y ai acces
    file = params[:fichier] 
    path_to_model = "#{SC_MODEL_ROOT}/model_#{@id_model}"
    path_to_mesh = "#{SC_MODEL_ROOT}/model_#{@id_model}/MESH"
 
    Dir.mkdir(path_to_model, 0777) unless File.exists?(path_to_model)
    Dir.mkdir(path_to_mesh, 0777) unless File.exists?(path_to_mesh)

    path_to_file = path_to_mesh + "/mesh.bdf"
    File.open(path_to_file, 'w+') do |f|
        f.write(file.read)
    end
    File.chmod 0777, path_to_mesh

    # création du fichier json_model 
    identite_calcul = { :id_societe => current_model.company.id, :id_user => @current_user.id,         :id_projet => '', :id_model => current_model.id, :id_calcul => '', :dimension  => current_model.dimension};
    priorite_calcul = { :priorite => 0 };                               
    mesh            = { :mesh_directory => path_to_mesh, :mesh_name  => "mesh", :extension  => ".bdf"};
    
    json_model        = { :identite_calcul => identite_calcul, :priorite_calcul => priorite_calcul, :mesh => mesh}; 
    
    path_to_json_model = path_to_mesh + "/model_id.json"
    File.open(path_to_json_model, 'w+') do |f|
        f.write(JSON.pretty_generate(json_model))
    end
    
    # envoi de la requette de création de model au serveur de calcul
    send_data       = { :id_user => @current_user.id, :mode => "create", :identite_calcul => identite_calcul };
    
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
    @current_model = ScModel.find(@id_model)
    @current_resultat = @current_model.calcul_results.find(@id_resultat)
    name_file = "#{SC_MODEL_ROOT}/model_" + @id_model + "/calcul_" + @id_resultat + "/resultat_0_0.vtu"
    name_resultats = 'result_' + @id_resultat + '.vtu'
    send_file name_file, :filename => name_resultats
    
    @current_resultat.state = 'downloaded'
  end
 
end

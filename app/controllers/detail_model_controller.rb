class DetailModelController < ApplicationController
  require 'json'
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
    # list_resultats = current_model.calcul_results.find(:all, :conditions => {:log_type => "compute", :state => "finish"})
    list_resultats = current_model.calcul_results.find(:all, :conditions => {:log_type => "compute"})
    respond_to do |format|
      format.js   {render :json => list_resultats.to_json}
    end 
  end
  
  def get_list_file
    @id_model = params[:id_model]
    current_model = @current_user.sc_models.find(@id_model)
    # list_file = current_model.calcul_results.find(:all, :conditions => {:log_type => "compute", :state => "finish"})
    list_files = current_model.files_sc_models.find(:all)
    respond_to do |format|
      format.js   {render :json => list_files.to_json}
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
    current_model = @current_user.sc_models.find(params[:id_model])
    results = current_model.send_mesh(params,@current_user)
    # envoie de la reponse au client
    render :text => results
  end
  
  def send_new_file
    current_model = @current_user.sc_models.find(params[:id_model])
    results = current_model.send_file(params,@current_user)
    # envoie de la reponse au client
    render :text => results
  end
  
  
  def mesh_valid
    @current_model = ScModel.find(params[:id_model])
    #@current_model.mesh_valid(params[:id_user],params[:time],params[:json])
    @current_model.mesh_valid(params)
    render :text => { :result => 'success' }
  end
  
  def download_resultat
    @id_model = params[:id_model]
    @id_resultat = params[:id_resultat]
    @current_model = ScModel.find(@id_model)
    @current_resultat = @current_model.calcul_results.find(@id_resultat)
    name_file = "#{SC_MODEL_ROOT}/model_" + @id_model + "/calcul_" + @id_resultat + "/resultat_0_0.vtu"
    name_resultats = 'result_' + @id_resultat + '.vtu'
    send_file name_file, :filename => name_resultats, :x_sendfile=>true
    
    @current_resultat.change_state('downloaded') 
  end
  
  def download_file
    @id_model = params[:id_model]
    @id_file = params[:id_file]
    @current_model = ScModel.find(@id_model)
    @current_file = @current_model.files_sc_models.find(@id_file)
    file = "#{SC_MODEL_ROOT}/model_" + @id_model + "/FILE/" + @current_file.name
    name_file = @current_file.name
    send_file file, :filename => name_file, :x_sendfile=>true
    
  end
  
  
  def delete_resultat
    @id_model = params[:id_model]
    @id_resultat = params[:id_resultat]
    @current_model = @current_user.sc_models.find(@id_model)
    @current_calcul = @current_model.calcul_results.find(@id_resultat)
    if(@current_calcul.test_delete?)
      @current_calcul.delete_calcul()
      render :text => "true"
    else
      render :text => "false"
    end
  end
 
end

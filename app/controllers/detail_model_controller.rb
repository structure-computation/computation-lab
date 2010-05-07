class DetailModelController < ApplicationController
  
  before_filter :login_required
  
  def index
    @page = 'SCcompute'
    @id_model = params[:id_model]
    current_model = @current_user.sc_models.find(@id_model)
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => current_model.to_json}
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
  
end

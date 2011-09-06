class ScAdminDetailWorkspaceController < ApplicationController
  before_filter :authenticate_user!
  before_filter :valid_admin_user
  
  def index
    @page = 'SCadmin'
    @id_workspace = params[:id_workspace]
    @current_workspace = Workspace.find(@id_workspace)
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @current_workspace.to_json}
    end 
  end
  
  def get_list_gestionnaires
    @id_workspace = params[:id_workspace]
    @current_workspace = Workspace.find(@id_workspace)
    gestionnaire = @current_workspace.users.find(:all, :conditions => {:role => "gestionnaire"})
    @users = []
    gestionnaire.each{ |gestionnaire_i|
      user = Hash.new
      user['user'] = Hash.new 
      user['user'] = { :id =>gestionnaire_i.id ,:date => gestionnaire_i.created_at.to_date, :email  => gestionnaire_i.email, :name => gestionnaire_i.firstname + " " + gestionnaire_i.lastname }
      @users << user
    } 
    respond_to do |format|
      format.js   {render :json => @users.to_json}
    end 
  end
  
  def get_list_factures
    @id_workspace = params[:id_workspace]
    @current_workspace = Workspace.find(@id_workspace)
    @factures = @current_workspace.factures.find(:all)
    respond_to do |format|
      format.js   {render :json => @factures.to_json}
    end 
  end
  
  def get_list_forfait
    @forfait = Forfait.find(:all)
    respond_to do |format|
      format.js   {render :json => @forfait.to_json}
    end 
  end
  
  def get_calcul_account
    @id_workspace = params[:id_workspace]
    @current_workspace = Workspace.find(@id_workspace)
    @calcul_account = @current_workspace.calcul_account
    respond_to do |format|
      format.js   {render :json => @calcul_account.to_json}
    end 
  end
  
  def valid_new_forfait
    @id_workspace = params[:id_workspace]
    @current_workspace = Workspace.find(@id_workspace)
    @calcul_account = @current_workspace.calcul_account
    @calcul_account.add_forfait(params[:id_forfait])
    respond_to do |format|
      format.js   {render :json => { :result => 'success' }}
    end 
  end
  
  def get_list_abonnement
    @abonnement = Abonnement.find(:all)
    respond_to do |format|
      format.js   {render :json => @abonnement.to_json}
    end 
  end
  
  def get_memory_account
    @id_workspace = params[:id_workspace]
    @current_workspace = Workspace.find(@id_workspace)
    @memory_account = @current_workspace.memory_account
    respond_to do |format|
      format.js   {render :json => @memory_account.to_json}
    end 
  end
  
  def valid_new_abonnement
    @id_workspace = params[:id_workspace]
    @current_workspace = Workspace.find(@id_workspace)
    @memory_account = @current_workspace.memory_account
    @memory_account.add_abonnement(params[:id_abonnement])
    respond_to do |format|
      format.js   {render :json => { :result => 'success' }}
    end
  end
  
  def valid_facture
    @id_workspace = params[:id_workspace]
    @current_workspace = Workspace.find(@id_workspace)
    @id_facture = params[:id_facture]
    @current_facture = @current_workspace.factures.find(@id_facture)
    @current_facture.valid_facture()
    render :text => "crédit alloués"
  end
end

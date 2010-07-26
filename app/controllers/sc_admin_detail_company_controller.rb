class ScAdminDetailCompanyController < ApplicationController
  before_filter :login_required
  before_filter :valid_admin_user
  
  def index
    @page = 'SCadmin'
    @id_company = params[:id_company]
    @current_company = Company.find(@id_company)
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @current_company.to_json}
    end 
  end
  
  def get_list_gestionnaires
    @id_company = params[:id_company]
    @current_company = Company.find(@id_company)
    gestionnaire = @current_company.users.find(:all, :conditions => {:role => "gestionnaire"})
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
  
  def get_list_forfait
    @forfait = Forfait.find(:all)
    respond_to do |format|
      format.js   {render :json => @forfait.to_json}
    end 
  end
  
  def get_calcul_account
    @id_company = params[:id_company]
    @current_company = Company.find(@id_company)
    @calcul_account = @current_company.calcul_account
    respond_to do |format|
      format.js   {render :json => @calcul_account.to_json}
    end 
  end
  
  def valid_new_forfait
    @id_company = params[:id_company]
    @current_company = Company.find(@id_company)
    @calcul_account = @current_company.calcul_account
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
    @id_company = params[:id_company]
    @current_company = Company.find(@id_company)
    @memory_account = @current_company.memory_account
    respond_to do |format|
      format.js   {render :json => @memory_account.to_json}
    end 
  end
  
  def valid_new_abonnement
    @id_company = params[:id_company]
    @current_company = Company.find(@id_company)
    @memory_account = @current_company.memory_account
    @memory_account.add_abonnement(params[:id_abonnement])
    respond_to do |format|
      format.js   {render :json => { :result => 'success' }}
    end 
  end
end

class CompanyController < ApplicationController
  
  before_filter :login_required
  
  def index
    @page = 'SCmanage' 
    @current_company = @current_user.company
    @id_company = @current_company.id
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @current_company.to_json}
    end
  end

  def list_membre
    @users = @current_user.company.users
    render :json => @users.to_json
  end
  
  def get_gestionnaire
    #recherche des gestionnaires dans la bdd
    gestionnaire = @current_user.company.users.find(:all, :conditions => {:role => "gestionnaire"})

    # creation du tableau des gestionnaires réduit a envoyer
    @users = []
    gestionnaire.each{ |gestionnaire_i|
      user = Hash.new
      user['user'] = Hash.new 
      user['user'] = { :id =>gestionnaire_i.id ,:date => gestionnaire_i.created_at.to_date, :email  => gestionnaire_i.email, :name => gestionnaire_i.firstname + " " + gestionnaire_i.lastname }
      @users << user
    } 
    render :json => @users.to_json
  end
  
  
  def get_solde
    # Creation d'une liste fictive d'opération.
    @soldes = @current_user.company.solde_calcul_accounts.find(:all)
    render :json => @soldes.to_json
  end
  
  def get_calcul_account
    @id_company = params[:id_company]
    @current_company = Company.find(@id_company)
    @calcul_account = @current_company.calcul_account
    respond_to do |format|
      format.js   {render :json => @calcul_account.to_json}
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
  
  def create_user
    @current_company = @current_user.company
    @user = @current_company.users.create(params[:user])
    if @user.errors.empty? 
      UserMailer.deliver_signup_notification(@user)
      render :text => "l'utilsateur un message a été envoyé à l'utilisateur"
    else
      render :text => "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
    end
  end
  
end

class CompaniesController < InheritedResources::Base
  
  before_filter :authenticate_user!
  before_filter :set_page_name 
  
  layout 'company'
  
  def set_page_name
    @page = 'SCmanage'
  end
  
  
  def index
    @page = 'SCmanage' 
    @current_company = current_user.company
    @id_company = @current_company.id
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @current_company.to_json}
    end
  end


  # TODO: Passer en ressource incluse.
  def get_gestionnaire
    #recherche des gestionnaires dans la bdd
    gestionnaire = current_user.company.users.find(:all, :conditions => {:role => "gestionnaire"})

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
  
  # Suppr
  def get_solde
    # Creation d'une liste fictive d'opération.
    @soldes = current_user.company.solde_calcul_accounts.find(:all)
    render :json => @soldes.to_json
  end
  
  # Supprimer
  def get_calcul_account
    @id_company = params[:id_company]
    @current_company = Company.find(@id_company)
    @calcul_account = @current_company.calcul_account
    respond_to do |format|
      format.js   {render :json => @calcul_account.to_json}
    end 
  end
  
  
  # Supprimer.
  def get_memory_account
    @id_company = params[:id_company]
    @current_company = Company.find(@id_company)
    @memory_account = @current_company.memory_account
    respond_to do |format|
      format.js   {render :json => @memory_account.to_json}
    end 
  end
  
  # TODO: Ressource incluse "member"
  def delete_user
    @current_company = current_user.company
    @user = @current_company.users.find(params[:id_membre])
    if(@user && @user.id == current_user.id)
      render :text => "false " + @user.id.to_s() + "  " + current_user.id.to_s()
    else
      @user.delete!
      render :text => "true" + @user.id.to_s() + "  " + current_user.id.to_s()
    end
  end
  
end

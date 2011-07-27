class CompaniesController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :set_page_name 
  before_filter :get_solde, :only =>[:index, :show]
  
  # Actions inherited ressource. 
  actions :all, :except => [ :index, :edit, :update, :destroy ]
  
  
  layout 'company'
  
  def set_page_name
    @page = 'SCmanage'
  end
  
  # Suppr
  def get_solde
    # Creation d'une liste fictive d'opération.
    @solde_calculs = current_user.company.solde_calcul_accounts.find(:all)
  end
  
  
  def index
    redirect_to current_user.company
    # @page = 'SCmanage' 
    # @company = current_user.company
    # respond_to do |format|
    #   format.html {render :layout => true }
    #   format.js   {render :json => @current_company.to_json}
    # end
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
  
  protected
    def begin_of_association_chain
      Company.accessible_by_user(@current_user)
    end
  
end

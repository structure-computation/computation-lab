class CompaniesController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :set_page_name 
  before_filter :create_solde, :only =>[:index, :show]
  respond_to :json
  
  # Actions inherited ressource. 
  actions :all, :except => [ :index, :edit, :update, :destroy ]
  
  layout 'company'
    
  def set_page_name
    @page = :manage
  end
  
  # Suppr
  def create_solde
    # Creation d'une liste fictive d'opération.
    @solde_calculs = current_user.company.solde_calcul_accounts.find(:all)
  end
  
  
  def index
    redirect_to company_path(current_user.company)
    # @page = 'SCmanage' 
    # respond_to do |format|
    #   format.html {render :layout => true }
    #   format.js   {render :json => @current_company.to_json}
    # end
  end
    
  protected
    def begin_of_association_chain
      Company.accessible_by_user(current_user)
    end
  
end

class WorkspacesController < InheritedResources::Base
  helper :application
  
  before_filter :authenticate_user!
  before_filter :set_page_name 
  before_filter :create_solde, :only =>[:index, :show]
  
  # Actions inherited ressource. 
  actions :all, :except => [ :index, :edit, :update, :destroy ]
  
  layout 'company'
    
  def set_page_name
    @page = :manage
  end
  
  # Suppr
  def create_solde
    # Creation d'une liste fictive d'opération.
    @solde_calculs = current_company_member.workspace.solde_calcul_accounts.find(:all)
  end
  
  
  def index
    redirect_to company_path(current_company_member.workspace)
    # @page = 'SCmanage' 
    # respond_to do |format|
    #   format.html {render :layout => true }
    #   format.js   {render :json => @current_company.to_json}
    # end
  end
    
  protected
    def begin_of_association_chain
      Workspace.accessible_by_user(current_user)
    end   
      
  def create     
    kind = params[:workspace][:kind]
    case kind
    when "Project"
      @workspace = Project.new(params[:workspace])
    when "Fillial"
      @workspace = Fillial.new(params[:workspace])  
    when "Company"
      @workspace = Company.new(params[:workspace])  
    end
    create! 
  end      
  
end

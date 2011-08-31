class WorkspacesController < InheritedResources::Base
  helper :application     
  
  # # Un espace de travail peut avoir plusieurs espaces de travail  
  # has_many :workspace_relationships                             
  # has_many :related_workspaces, :through => :workspace_relationships   
  # 
  # # Relation "inverse", permet de voir les workspaces qui partagent avec vous
  # has_many :inverse_workspace_relationships, :class_name => "WorkspaceRelationship", :foreign_key => "related_workspaces_id"  
  # has_many :inverse_workspace_relationships, :through => :inverse_workspace_relationships, :source => :workspace  
  
  before_filter :authenticate_user!
  before_filter :set_page_name 
  before_filter :create_solde, :only =>[:index, :show]
  
  # Actions inherited ressource. 
  actions :all, :except => [ :index, :edit, :update, :destroy ]
  
  layout 'company'  
  
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
    
  def set_page_name
    @page = :manage
  end
  
  # Suppr
  def create_solde
    # Creation d'une liste fictive d'opération.
    @solde_calculs = current_company_member.workspace.solde_calcul_accounts.find(:all)
  end
  
  
  def index
    redirect_to workspace_path(current_company_member.workspace)
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

  def percent_of(n)
   self.to_f / n.to_f * 100.0
   #left_tokens =
   #consumed_tokens = 
   #score = consumed_tokens.percent_of(left_tokens)
  end

end

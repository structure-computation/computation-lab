class CompanyController < InheritedResources::Base
  
    helper :application     
  
  # # Un espace de travail peut avoir plusieurs espaces de travail  
  # has_many :workspace_relationships                             
  # has_many :related_workspaces, :through => :workspace_relationships   
  # 
  # # Relation "inverse", permet de voir les workspaces qui partagent avec vous
  # has_many :inverse_workspace_relationships, :class_name => "WorkspaceRelationship", :foreign_key => "related_workspaces_id"  
  # has_many :inverse_workspace_relationships, :through => :inverse_workspace_relationships, :source => :workspace  
  
  before_filter :authenticate_user!  
  before_filter :must_be_manager
  #before_filter :set_page_name 
  
  # Actions inherited ressource. 
  actions :all, :except => [ :index, :edit, :update, :destroy ]
  
  layout 'workspace'  
  
  def show
    @company    = current_workspace_member.company
    if @company 
      # show!
      render
    else
      respond_to do |format|
        format.html {redirect_to workspace_path(current_workspace_member), 
                    :notice => "Vous n'avez pas acces à cette page."}
        format.json {render :status => 404, :json => {}}
      end
    end
  end
  
  def new
    @new_company = Company.new
  end
  
  def create
    @page = :sc_admin_company
    @new_company = Company.create(params[:company])
    render :json => { :result => 'success' }
    if @new_company 
      respond_to do |format|
        format.html {redirect_to sc_admin_company_path(), 
                    :notice => "Nouvelle société créée."}
        format.json {render :status => 404, :json => {}}
      end
    else
      respond_to do |format|
        format.html {redirect_to sc_admin_company_path(), 
                    :notice => "La société n'a pas été créée."}
        format.json {render :status => 404, :json => {}}
      end
    end
  end
  
end

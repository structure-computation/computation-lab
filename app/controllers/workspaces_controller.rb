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
  before_filter :must_be_manager, :except => [ :new, :create ]
  before_filter :set_page_name 
  before_filter :create_solde, :only =>[:index, :show]
  
  # Actions inherited ressource. 
  actions :all, :except => [ :index, :edit, :update, :destroy ]
  
  layout 'workspace'  
  
  def set_page_name
    @page = :manage
  end
  
  def show
    @workspace    = current_workspace_member.workspace
    @credits      = @workspace.token_account.credits.find(:all, :conditions => {:state => "active"})
    @soldes       = @workspace.token_account.solde_token_accounts.find(:all, :order => " created_at DESC")
    
    if @workspace 
      # show!
      render
    else
      respond_to do |format|
        format.html {redirect_to workspace_path(current_workspace_member), 
                    :notice => "Vous demandez l'affichage d'une page appartenant à un autre espace de travail."}
        format.json {render :status => 404, :json => {}}
      end
    end
  end
  
  def new
    @workspace = Workspace.new
  end
  
  def create     
    @new_workspace = current_user.workspaces.build(params[:workspace]) 
    @new_workspace.init_account
    if @new_workspace 
      @new_workspace.save
      @new_workspace.members << current_user
      @new_workspace.save
      @current_workspace_member = current_user.user_workspace_memberships.find(:first, :conditions => {:workspace_id =>  @new_workspace.id} )
      @current_workspace_member.manager = true
      @current_workspace_member.engineer = true
      @current_workspace_member.save
      respond_to do |format|
        format.html {redirect_to scratch_user_path(current_user), 
                    :notice => "Nouveau workspace créée."}
        format.json {render :status => 404, :json => {}}
      end
    else
      respond_to do |format|
        format.html {redirect_to scratch_user_path(current_user), 
                    :notice => "Le workspace n'a pas été créé."}
        format.json {render :status => 404, :json => {}}
      end
    end
    #kind = params[:workspace][:kind]
    #     case kind
    #     when "Project"
    #       @workspace = Project.new(params[:workspace])
    #     when "Fillial"
    #       @workspace = Fillial.new(params[:workspace])  
    #     when "Company"
    #       @workspace = Company.new(params[:workspace])  
    #     end
  end
  
  def edit
    @workspace = current_workspace_member.workspace
  end
  
  def update
    @workspace = current_workspace_member.workspace
    if @workspace.update_attributes(params[:workspace]) 
      logger.debug "ok"
      redirect_to workspace_path(@workspace, :anchor => "Description"), :notice => "Le workspace a été modifié." # TODO traduire 
    else
      logger.debug "pas ok"
      redirect_to edit_workspace_path(@workspace), :notice => "Le workspace n'a pas été modifié." # TODO traduire 
    end
  end
  
  # Suppr
  def create_solde
    # Creation d'une liste fictive d'opération.
    @solde_calculs = current_workspace_member.workspace.token_account.solde_token_accounts.find(:all)
  end
  
  
  def index   
    redirect_to workspace_path(current_workspace_member.workspace)                                                   
    # if !current_worksapce.member.manager?  
    #   redirect_to workspace_sc_models_path(current_workspace_member.workspace) 
    #   flash[:notice] = "Vous n'avez pas accès à cette partie de l'espace de travail."
    # end
    # @page = 'SCmanage' 
    # respond_to do |format|
    #   format.html {render :layout => true }
    #   format.js   {render :json => @current_workspace.to_json}
    # end
  end
  
  
  #protected
    # def begin_of_association_chain
    #   Workspace.accessible_by_user(current_user)
    # end      

  def percent_of(n)
   self.to_f / n.to_f * 100.0
   #left_tokens =
   #consumed_tokens = 
   #score = consumed_tokens.percent_of(left_tokens)
  end
end

class ScAdminWorkspaceController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :valid_admin_user
  
  layout 'sc_admin'
  
  def index 
    @page = :sc_admin_workspace
    @workspaces = Workspace.all
    if params[:notice] 
      flash[:notice] = params[:notice]
    end
  end
  
  def new
    @page = :sc_admin_workspace
    @workspace = Workspace.new
  end
  
  def create
    @page = :sc_admin_workspace
    @new_workspace = Workspace.create(params[:workspace])
    @new_workspace.init_account
    if @new_workspace 
      respond_to do |format|
        format.html {redirect_to :action => :index, 
                    :notice => "Nouveau workspace créée."}
        format.json {render :status => 404, :json => {}}
      end
    else
      respond_to do |format|
        format.html {redirect_to :action => :index, 
                    :notice => "Le workspace n'a pas été créé."}
        format.json {render :status => 404, :json => {}}
      end
    end
  end
  
  def show
    @page = :sc_admin_workspace
    @workspace    = Workspace.find_by_id(params[:id])
    if params[:notice] 
      flash[:notice] = params[:notice]
    end
    if @workspace 
      # show!
      render
    else
      respond_to do |format|
        format.html {redirect_to :action => :index, 
                    :notice => "Ce workspace n'existe pas ou n'est pas accessible à partir de cette page."}
        format.json {render :status => 404, :json => {}}
      end
    end
  end
  
  def edit
    @page = :sc_admin_workspace
    @workspace = Workspace.find_by_id(params[:id])
  end
  
end

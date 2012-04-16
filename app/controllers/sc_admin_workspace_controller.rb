class ScAdminWorkspaceController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :valid_admin_user
  
  layout 'sc_admin'
  
  def index 
    @page = :sc_admin_workspace
    @workspaces = Workspace.all
  end
  
  def create
    @new_workspace = Workspace.create(params[:workspace])
    @new_workspace.init_account
    render :json => { :result => 'success' }
  end
  
  def show
    @page = :sc_admin_workspace
    @workspace    = Workspace.find_by_id(params[:id])
    if @workspace 
      # show!
      render
    else
      respond_to do |format|
        format.html {redirect_to sc_admin_detail_workspace_path(current_workspace_member.workspace.id), 
                    :notice => "Ce workspace n'existe pas ou n'est pas accessible à partir de cette page."}
        format.json {render :status => 404, :json => {}}
      end
    end
  end
  
end

class ScAdminWorkspaceController < ApplicationController
  before_filter :authenticate_user!
  before_filter :valid_admin_user
  
  layout 'workspace'
  
  def index 
    @page = 'SCadmin'
    @workspaces = Workspace.all
    
    respond_to do |format|
      format.html {render :layout => true }
      format.js   {render :json => @workspaces.to_json}
    end
  end
  
  def create
    @new_workspace = Workspace.create(params[:workspace])
    @new_workspace.init_account
    render :json => { :result => 'success' }
  end
end

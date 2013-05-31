# encoding: utf-8

class ScAdminWorkspaceController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :valid_admin_user
  before_filter :set_page_name
  
  layout 'sc_admin'
  
  def set_page_name
    @page = :sc_admin_workspace
  end
  
  def index 
    @workspaces = Workspace.all
    if params[:notice] 
      flash[:notice] = params[:notice]
    end
  end
  
  def show
    @workspace    = Workspace.find_by_id(params[:id])
    @credits      = @workspace.token_account.credits.find(:all, :conditions => {:state => "active"})
    @soldes       = @workspace.token_account.solde_token_accounts.find(:all, :order => " created_at DESC")
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
  
  def new
    @workspace = Workspace.new
  end
  
  def create
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
  
  def edit
    @workspace = Workspace.find_by_id(params[:id])
  end
  
end

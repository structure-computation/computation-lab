class ScratchUserController < InheritedResources::Base  
  before_filter :authenticate_user!  
  layout 'login'
  
  def new
    @user = User.new
  end
  
  def create
    @new_user = User.create(params[:user])
    if @new_user 
      respond_to do |format|
        format.html {redirect_to destroy_user_session_path, 
                    :notice => "Nouvel utilsateur créé. vous allez recevoir un message de confirmation"}
        format.json {render :status => 404, :json => {}}
      end
    else
      respond_to do |format|
        format.html {redirect_to destroy_user_session_path, 
                    :notice => "L'utilsateur n'a pas été créé."}
        format.json {render :status => 404, :json => {}}
      end
    end
  end
  
  def show  
    @user       =  current_user
    @workspace  =  current_workspace_member
    logger.debug current_workspace_member
    if params[:notice] 
      flash[:notice] = params[:notice]
    end
    render :show, :layout => 'workspace'
  end
  
  def edit  
    @user           = current_user
    render :edit, :layout => 'workspace'
  end
  
  def select_workspace
    @user = current_user
    if !params[:workspace_id]
      flash[:notice] = "Aucun espace de travail séléctionné" # TODO: traduire.
      render :show
    else      
      workspace = @user.workspaces.find(params[:workspace_id])
      if workspace.nil?
        #flash[:notice] = "Cet espace de travail est inexistant ou ne vous est pas accessible." # TODO: traduire.
        format.html {redirect_to destroy_user_session_path, 
                    :notice => "Cet espace de travail est inexistant ou ne vous est pas accessible."}
        #render :show
      else
        set_current_worskspace(params[:workspace_id])
        format.html {redirect_to destroy_user_session_path, 
                    :notice => "Espace de travail modifié."}
        #flash[:notice] = "Espace de travail modifié." # TODO: traduire.
        #render :show
      end
    end
  end
  
end

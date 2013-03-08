# encoding: utf-8

class ScratchUserController < InheritedResources::Base  
  before_filter :authenticate_user!  , :except => [:new, :create]   
  layout 'login'
  
  def index
    @change_current_workspace_member=current_user.user_workspace_memberships.find(:first, :conditions => {:workspace_id => params[:workspace_id]})
    #current_workspace_member =  @change_current_workspace_member
    session[:current_workspace_member_id] = @change_current_workspace_member.id
    
    #     @change_current_workspace_sc_model=ScModel.from_workspace(current_workspace_member.workspace.id).first
    #     session[:current_workspace_sc_model_id] = @change_current_workspace_sc_model.id
    
    logger.debug "current_user_id: " + current_user.id.to_s
    logger.debug "workspace_id: " + params[:workspace_id].to_s
    logger.debug "session[:current_workspace_member_id]: " + session[:current_workspace_member_id].to_s
    logger.debug "session[:current_workspace_sc_model_id]: " + session[:current_workspace_sc_model_id].to_s
    
    if params[:workspace_id]
      redirect_to  :controller => "ecosystem_mecanic", :action => "index", :sc_model_id => current_workspace_sc_model.id
      #redirect_to scratch_user_path(current_user.id), :notice => "Espace de travail modifié." # TODO: traduire.
    else
      redirect_to  :controller => "ecosystem_mecanic", :action => "index", :sc_model_id => current_workspace_sc_model.id
      #redirect_to scratch_user_path(current_user.id), :notice => "Aucun espace de travail séléctionné." # TODO: traduire. 
    end
  end
  
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
    #session[:current_workspace_member_id] = nil
    if session[:current_workspace_member_id]
      if !current_workspace_member
        session[:current_workspace_member_id] = nil
      end
      logger.debug "session[:current_workspace_member_id]: " + session[:current_workspace_member_id].to_s
    else
      
      @change_current_workspace_member = current_workspace_member
      @change_current_workspace_sc_model = current_workspace_sc_model
      #current_workspace = @user.workspaces.first
      #@change_current_workspace_member=current_user.user_workspace_memberships.find(:first, :conditions => {:workspace_id => current_workspace.id})
      session[:current_workspace_member_id] = @change_current_workspace_member.id
      
      #@change_current_workspace_sc_model=ScModel.from_workspace(current_workspace_member.workspace.id).first
      session[:current_workspace_sc_model_id] = @change_current_workspace_sc_model.id
    end
    logger.debug "session[:current_workspace_member_id]: " + session[:current_workspace_member_id].to_s
    logger.debug "session[:current_workspace_sc_model_id]: " + session[:current_workspace_sc_model_id].to_s
    
    logger.debug current_workspace_member.id
    logger.debug current_workspace_sc_model.id
    
    redirect_to  :controller => "ecosystem_mecanic", :action => "index", :sc_model_id => current_workspace_sc_model.id
#     if params[:notice] 
#       flash[:notice] = params[:notice]
#     end
#     render :show, :layout => 'workspace'
  end
  
  def edit  
    @user           = current_user
    render :edit, :layout => 'workspace'
  end
  
  
  
end

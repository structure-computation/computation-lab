# encoding: utf-8

class ScAdminUserController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :valid_admin_user
  
  layout 'sc_admin'
  
  
  def index 
    @page = :sc_admin_user
    @users = User.all
    @admin_users = UserScAdmin.all
    if params[:notice] 
      flash[:notice] = params[:notice]
    end
  end
  
  def new
    @page = :sc_admin_user
    @user = User.new
  end
  
  def create
    @new_user = User.create(params[:user])
    if @new_user 
      respond_to do |format|
        format.html {redirect_to :action => :index, 
                    :notice => "Nouvel utilsateur créé."} # TODO: traduire. 
        format.json {render :status => 404, :json => {}}
      end
    else
      respond_to do |format|
        format.html {redirect_to :action => :index, 
                    :notice => "L'utilsateur n'a pas été créé."} # TODO: traduire. 
        format.json {render :status => 404, :json => {}}
      end
    end
  end
  
  def show
    @page = :sc_admin_user
    @user    = User.find_by_id(params[:id])
    if params[:notice] 
      flash[:notice] = params[:notice]
    end
    if @user 
      # show!
      render
    else
      respond_to do |format|
        format.html {redirect_to :action => :index, 
                    :notice => "Cet utilisateur n'existe pas ou n'est pas accessible à partir de cette page."} # TODO: traduire. 
        format.json {render :status => 404, :json => {}}
      end
    end
  end
  
  def edit
    @page = :sc_admin_user
    @user = User.find_by_id(params[:id])
  end
  
  def destroy
      @user = User.find_by_id(params[:id])
      @user.destroy
      redirect_to :controller => :sc_admin_user, :action => :index,  :notice => "Utilsateur suprimé." # TODO: traduire. 
      #destroy!{ workspace_path(@workspace, :anchor => 'Membres') }
  end
  
  def add_admin_user
      @admin_workspace = ScAdmin.find_by_workspace_id(current_workspace_member.workspace.id)
      @user_to_add = User.find_by_id(params[:id])
      @test_workspace = @user_to_add.workspaces.find(@admin_workspace.workspace.id)
      
      unless @test_workspace.nil?
          new_user_admin = @admin_workspace.user_sc_admins.build() 
          new_user_admin.user = @user_to_add
          new_user_admin.save
          redirect_to :controller => :sc_admin_user, :action => :index,  :notice => "Super utilsateur ajouté." # TODO: traduire. 
      else
          redirect_to :controller => :sc_admin_user, :action => :index,  :notice => "Aucun super utilsateur ajouté." # TODO: traduire. 
      end
      #destroy!{ workspace_path(@workspace, :anchor => 'Membres') }
  end
  
  def remove_admin_user
      admin_users = UserScAdmin.find(:all)
      if admin_users.length > 1
          @user_to_remove = UserScAdmin.find_by_id(params[:id])
          @user_to_remove.destroy
          redirect_to :controller => :sc_admin_user, :action => :index,  :notice => "Super utilsateur suprimé." # TODO: traduire. 
      else
          redirect_to :controller => :sc_admin_user, :action => :index,  :notice => "Le super utilsateur ne peut pas être suprimé." # TODO: traduire. 
      end
      #destroy!{ workspace_path(@workspace, :anchor => 'Membres') }
  end

  
end

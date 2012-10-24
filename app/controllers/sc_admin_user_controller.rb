# encoding: utf-8

class ScAdminUserController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :valid_admin_user
  
  layout 'sc_admin'
  
  
  def index 
    @page = :sc_admin_user
    @users = User.all
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

  
end

class UsersController < ApplicationController


  before_filter :login_required,  :except => :activate
  # Protect these actions behind an admin login
  # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
  before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]
  
  def index
    @page = 'SCmanage' 
  end
 
  # render new.rhtml
  def new
    @user = User.new
  end
 
  def create
    #logout_keeping_session!
    user_temp = Hash.new
    user_temp = params
    user_temp["password"] = 'monkey'
    user_temp["password_confirmation"] = 'monkey'
    @user = User.new(user_temp) 
    @user.company = @current_user.company
    @user.register! if @user && @user.valid?
    success = @user && @user.valid?
    if success && @user.errors.empty? 
      render :text => "validation du nouvel utilisateur"
#       redirect_back_or_default('/')
#       flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
    else
      render :text => "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
#       flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
#       render :action => 'new'
    end
  end

  def activate
    logger.debug "activate"
    #logout_keeping_session!
    user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    case
    when (!params[:activation_code].blank?) && user && !user.active?
      logger.debug "activate valid"
      user.activate!
      flash[:notice] = "Signup complete! Please sign in to continue."
      redirect_to '/login'
    when params[:activation_code].blank?
      logger.debug "activate not valid 1"
      flash[:error] = "The activation code was missing.  Please follow the URL from your email."
      redirect_back_or_default('/')
    else 
      logger.debug "activate not valid 2"
      flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
      redirect_back_or_default('/')
    end
  end
  
  def suspend
    @user.suspend! 
    redirect_to users_path
  end

  def unsuspend
    @user.unsuspend! 
    redirect_to users_path
  end

  def destroy
#     @current_company = @current_user.company
#     @user = @current_company.users.find(params[:id_membre])
    if(@user && @user.id == @current_user.id)
      render :text => "false " + @user.id.to_s() + "  " + @current_user.id.to_s()
    else
      @user.delete!
      render :text => "true" + @user.id.to_s() + "  " + @current_user.id.to_s()
    end
#     @user.delete!
#     redirect_to users_path
  end

  def purge
    @user.destroy
    redirect_to users_path
  end
  
  # There's no page here to update or destroy a user.  If you add those, be
  # smart -- make sure you check that the visitor is authorized to do so, that they
  # supply their old password along with a new one to update it, etc.

protected
  def find_user
    @user = User.find(params[:id])
  end
end

# Controlleur permettant de gerer les utilisateurs (user) au sein d'une équipe.
# Ulterieurement pourra être une ressource incluse dans une ressource company

class MembersController < InheritedResources::Base
  
    # Creer un layout spécifique pour les fonctions du menu "scté".
    layout        "company"
    
    defaults      :resource_class => User, :collection_name => 'members', :instance_name => 'member'
    belongs_to    :company
    
    
    respond_to    :html, :json, :js

    before_filter :authenticate_user! #,  :except => :activate
    
    # Protect these actions behind an admin login
    # before_filter :admin_required, :only => [:suspend, :unsuspend, :destroy, :purge]
    
    before_filter :find_user, :only => [:suspend, :unsuspend, :destroy, :purge]
    
    def show
      @member = User.find(params[:id])
      show!
    end
    
    def index
      @page    = 'SCmanage' 
      @users   = current_user.company.users
      @member  = User.new
      @members = User.all
      
      respond_with(@users) 
      
      # TODO: Mis de côté en attendant de travailler avec le bon format résultat.
      # respond_with(@users) do |format|
      #   format.html
      #   # format.json { render_for_api :std, :json => @users, :root => :users }
      #   format.json { render_for_api :std, :json => @users }
      # end
         
    end

    # render new.rhtml
    def new
      @member = User.new
      render :layout => false 
    end

    def create
      pwd            = generate_password
      #params["member"]["password"] = pwd
      #pwd            = "monkey"
      @user          = User.new  params["member"]
      #@user.password = pwd
      @user.company  = current_user.company
      # @user.register! if @user && @user.valid?
      success        = @user.save
      if @user.errors
        logger.debug "New user errors : " + @user.errors.full_messages.join("\n")
      end
      if success
        render :text => "validation du nouvel utilisateur"
  #       redirect_back_or_default('/')
  #       flash[:notice] = "Thanks for signing up!  We're sending you an email with your activation code."
      else
        render :text => "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
  #       flash[:error]  = "We couldn't set up that account, sorry.  Please try again, or contact an admin (link is above)."
  #       render :action => 'new'
      end
    end

    # def activate
    #   logger.debug "activate"
    #   
    #   user = User.find_by_activation_code(params[:activation_code]) unless params[:activation_code].blank?
    #   case
    #   when (!params[:activation_code].blank?) && user && !user.active?
    #     logger.debug "activate valid"
    #     user.activate!
    #     flash[:notice] = "Signup complete! Please sign in to continue."
    #     redirect_to '/login'
    #   when params[:activation_code].blank?
    #     logger.debug "activate not valid 1"
    #     flash[:error] = "The activation code was missing.  Please follow the URL from your email."
    #     redirect_back_or_default('/')
    #   else 
    #     logger.debug "activate not valid 2"
    #     flash[:error]  = "We couldn't find a user with that activation code -- check your email? Or maybe you've already activated -- try signing in."
    #     redirect_back_or_default('/')
    #   end
    # end

    def suspend
      @user.suspend! 
      redirect_to users_path
    end

    def unsuspend
      @user.unsuspend! 
      redirect_to users_path
    end

    # TODO: écrire un traitement cohérent et compatible avec devise et la volonté de conserver toutes les données utilisateurs.
  #   def destroy
  # #     @current_company = current_user.company
  # #     @user = @current_company.users.find(params[:id_membre])
  #     if(@user && @user.id == current_user.id)
  #       render :text => "false " + @user.id.to_s() + "  " + current_user.id.to_s()
  #     else
  #       @user.delete!
  #       render :text => "true" + @user.id.to_s() + "  " + current_user.id.to_s()
  #     end
  # #     @user.delete!
  # #     redirect_to users_path
  #   end

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
    
    # TODO: Trouver un emplacement plus pertinent.
    def generate_password
      pwd = `pwgen 12 1`
      return pwd
    end
  
end

# Controlleur permettant de gerer les utilisateurs (user) au sein d'une équipe.
# Ulterieurement pourra être une ressource incluse dans une ressource company

class MembersController < InheritedResources::Base
  
    # Creer un layout spécifique pour les fonctions du menu "scté".
    # TODO: replacer :layout        "company"
    
    # Configuration de inherited ressource.
    defaults      :resource_class => User, :collection_name => 'members', :instance_name => 'member'
    belongs_to    :company
    
    respond_to    :html, :json, :js

    before_filter :authenticate_user! #,  :except => :activate
    
    
    # Protect these actions behind an admin login
    # before_filter :admin_required, :only => [ :destroy ]
    
    # TODO: Supprimer à terme : InheritedRessource fait la recherche sur member seul.
    # before_filter :find_user, :only => [:destroy]
    
    before_filter {@page    = 'SCmanage' }
    
    


    # render new.rhtml
    def new
      @member = User.new
      render :layout => false 
    end

    def create
      pwd            = generate_password
      @user          = User.new  params["member"]
      @user.company  = current_user.company
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
    



    # There's no page here to update or destroy a user.  If you add those, be
    # smart -- make sure you check that the visitor is authorized to do so, that they
    # supply their old password along with a new one to update it, etc.
    
  protected
    # Configuration de InheritedRessource
    def begin_of_association_chain
      Company.accessible_by_user(current_user)
    end
  
    
    # TODO: Trouver un emplacement plus pertinent.
    def generate_password
      pwd = `pwgen 12 1`
      return pwd
    end
  
end

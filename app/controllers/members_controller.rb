# Controlleur permettant de gerer les utilisateurs (user) au sein d'une équipe.
# Ulterieurement pourra être une ressource incluse dans une ressource workspace

class MembersController < InheritedResources::Base
  
    layout 'workspace'
    
    # Configuration de inherited ressource.
    defaults      :resource_class => User, :collection_name => 'members', :instance_name => 'member'
    belongs_to    :workspace
    
    respond_to    :html, :json, :js

    before_filter :authenticate_user! #,  :except => :activate
    before_filter :set_page_name
    
    # Protect these actions behind an admin login
    # before_filter :admin_required, :only => [ :destroy ]
    
    # TODO: Supprimer à terme : InheritedRessource fait la recherche sur member seul.
    # before_filter :find_user, :only => [:destroy]
    
    def set_page_name
      @page = :manage
    end
    
    # render new.rhtml
    def new
      @member = User.new
      new!
      #render :layout => false 
    end

    def create
      @user = User.new(params["user"])
      @user.workspace = current_workspace_member.workspace
      create!
    end
    
    def show  
      @workspace_member = UserWorkspaceMembership.find params["id"]
      @member           = @workspace_member.user
    end
    
    def destroy
      destroy!{ workspace_path(:anchor => 'Membres') }
    end

    # There's no page here to update or destroy a user.  If you add those, be
    # smart -- make sure you check that the visitor is authorized to do so, that they
    # supply their old password along with a new one to update it, etc.
    
  protected
    # Configuration de InheritedRessource
    def begin_of_association_chain
      Workspace.accessible_by_user(current_user)
    end
  
    
    # TODO: Trouver un emplacement plus pertinent.
    def generate_password
      pwd = `pwgen 12 1`
      return pwd
    end
  
end

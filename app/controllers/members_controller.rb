# encoding: utf-8

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

    def new
      @workspace = current_workspace_member.workspace
      @member = User.new
      new!
    end

    def create
      @workspace = current_workspace_member.workspace
      if test_user = User.find(:first, :conditions => {:email => params["user"]["email"]})
          if @workspace.members.exists?(test_user.id)
            redirect_to workspace_path(@workspace, :anchor => 'Membres'), :notice => "Cet utilisateur est déjà membre de ce workspace" # TODO: traduire.
          else
            @workspace.members << test_user
            @current_workspace_member = test_user.user_workspace_memberships.find(:first, :conditions => {:workspace_id =>  @workspace.id} )
            @current_workspace_member.manager = false
            @current_workspace_member.engineer = true
            @current_workspace_member.make_role()
            @current_workspace_member.save
            redirect_to workspace_path(@workspace, :anchor => 'Membres'), :notice => "Un nouveau membre a été ajouté" # TODO: traduire. 
          end
      else
          @new_user = User.create(params["user"])
          @workspace.members << @new_user
          @current_workspace_member = @new_user.user_workspace_memberships.find(:first, :conditions => {:workspace_id =>  @workspace.id} )
          @current_workspace_member.manager = false
          @current_workspace_member.engineer = true
          @current_workspace_member.make_role()
          @current_workspace_member.save
          redirect_to workspace_path(@workspace, :anchor => 'Membres'), :notice => "Un nouvel utilisateur a été crée" # TODO: traduire. 
      end
      
    end
    
    def show  
      @workspace_member = UserWorkspaceMembership.find params["id"]
      @member           = @workspace_member.user
    end
    
    def destroy
      @workspace = current_workspace_member.workspace
      @user = @workspace.members.find(params[:id])
      @current_workspace_member = @user.user_workspace_memberships.find(:first, :conditions => {:workspace_id =>  @workspace.id} )
      @current_workspace_member.destroy
      redirect_to workspace_path(@workspace, :anchor => 'Membres'), :notice => "L'utilisateur n'est plus membre du workspace" # TODO: traduire. 
      #destroy!{ workspace_path(@workspace, :anchor => 'Membres') }
    end

    def manager
      @workspace    = current_workspace_member.workspace
      @user = @workspace.members.find(params[:member_id])
      @current_workspace_member = @user.user_workspace_memberships.find(:first, :conditions => {:workspace_id =>  @workspace.id} )
      @current_workspace_member.manager = true
      @current_workspace_member.engineer = true
      @current_workspace_member.make_role()
      @current_workspace_member.save
      redirect_to workspace_path(@workspace, :anchor => 'Membres'), :notice => "le rôle de l'utilisateur a été modifié" # TODO: traduire. 
    end
    
    def engineer
      @workspace    = current_workspace_member.workspace
      @user = @workspace.members.find(params[:member_id])
      @current_workspace_member = @user.user_workspace_memberships.find(:first, :conditions => {:workspace_id =>  @workspace.id} )
      @current_workspace_member.manager = false
      @current_workspace_member.engineer = true
      @current_workspace_member.make_role()
      @current_workspace_member.save
      redirect_to workspace_path(@workspace, :anchor => 'Membres'), :notice => "le rôle de l'utilisateur a été modifié" # TODO: traduire. 
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

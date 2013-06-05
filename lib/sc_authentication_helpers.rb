
module  SCAuthenticationHelpers
  
  # TODO: fait doublon avec la même procédure dans ApplicationController. 
  # Trouver la "bonne methode".
  def current_workspace_member
    # Si déjà initialisé, on renvoie l'objet existant.
    # Sinon on le recherche.
    if session[:current_workspace_member_id]
      #@current_workspace_member = UserWorkspaceMembership.find(session[:current_workspace_member_id])
      @current_workspace_member = current_user.user_workspace_memberships.find(session[:current_workspace_member_id])
      logger.debug @current_workspace_member.to_s
      return @current_workspace_member 
    else
      @current_workspace_member = current_user.user_workspace_memberships.first
      #si pas de workspace pour cet utilisateur
      if !@current_workspace_member
        @new_workspace = current_user.workspaces.create() 
        @new_workspace.name = "first workspace"
        @new_workspace.init_account
        if @new_workspace 
          @new_workspace.save
          @new_workspace.members << current_user
          @new_workspace.save
          @current_workspace_member = current_user.user_workspace_memberships.find(:first, :conditions => {:workspace_id =>  @new_workspace.id} )
          @current_workspace_member.manager = true
          @current_workspace_member.engineer = true
          @current_workspace_member.save
        end
      end
      return @current_workspace_member 
    end
  end
  
  def current_workspace_sc_model
    # Si déjà initialisé, on renvoie l'objet existant.
    # Sinon on le recherche.
    if session[:current_workspace_sc_model_id]
      @current_workspace_sc_model = current_workspace_member.sc_models.find_by_id(session[:current_workspace_sc_model_id])
      #si ce model ne fait pas parti du workspace
      if !@current_workspace_sc_model 
        @current_workspace_sc_model = current_workspace_member.sc_models.first
        #si ce workspace n'as pas encore de modèle
        if !@current_workspace_sc_model
          @current_workspace_sc_model = current_workspace_member.workspace.sc_models.create() #retrieve_column_fields(params) 
          @current_workspace_sc_model.save
          @current_workspace_sc_model.workspace_members << current_workspace_member
          @current_workspace_sc_model.name = "first project"
          @current_workspace_sc_model.save
        end
      end
      logger.debug @current_workspace_sc_model.to_s
      return @current_workspace_sc_model 
    else
      @current_workspace_sc_model = current_workspace_member.sc_models.first
      #si ce workspace n'as pas encore de modèle
      if !@current_workspace_sc_model
        @current_workspace_sc_model = current_workspace_member.workspace.sc_models.create() #retrieve_column_fields(params) 
        @current_workspace_sc_model.save
        @current_workspace_sc_model.workspace_members << current_workspace_member
        @current_workspace_sc_model.name = "first project"
        @current_workspace_sc_model.save
      end
      return @current_workspace_sc_model 
    end
  end

  # Change le current_workspace_member.
  # TODO : Check que l'on est sur le même user ? Check de droits ?
#   def   current_workspace_member=           new_current_workspace_member
#     session[:current_workspace_member_id] = new_current_workspace_member.id
#     @current_workspace_member             = new_current_workspace_member
#     return @current_workspace_member
#   end

  # Access control. Use as before_filter on actions that require the workspace member to be an engineer 
  def must_be_engineer
    if ! current_workspace_member.engineer?
      render  "static/forbidden", :status => :forbidden 
    end
  end    

  # Access control. Use as before_filter on actions that require the workspace member to be an manager 
  def must_be_manager
    if ! current_workspace_member.manager?
      render  "static/forbidden", :status => :forbidden 
    end
  end
end

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
      return @current_workspace_member 
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
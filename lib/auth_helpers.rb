# TODO: fait doublon avec la même procédure dans ApplicationController. 
# Trouver la "bonne methode".
def current_workspace_member
  # Si déjà initialisé, on renvoie l'objet existant.
  # Sinon on le recherche.
  @current_workspace_member = UserWorkspaceMembership.find(session[:current_workspace_member_id]) unless @current_workspace_member
  @current_workspace_member 
end

# Change le current_workspace_member.
# TODO : Check que l'on est sur le même user ? Check de droits ?
def   current_workspace_member=           new_current_workspace_member
  session[:current_workspace_member_id] = new_current_workspace_member.id
  @current_workspace_member             = new_current_workspace_member
end

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
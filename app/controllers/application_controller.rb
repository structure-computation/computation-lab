class ApplicationController < ActionController::Base
#   protect_from_forgery

  # TODO: Refaire.
  def valid_admin_user
    admin_workspace = ScAdmin.find_by_workspace_id(current_workspace_member.workspace.id)
    admin_user = admin_workspace.user_sc_admins.find(:first, :conditions => {:user_id => current_user.id})
    if !admin_user
      redirect_back_or_default(root_path)
    end
  end
  
  # TODO: fait doublon avec la même procédure dans ApplicationHelper. 
  # Trouver la "bonne methode".
  def current_workspace_member
    current_user.user_workspace_memberships.first
  end    

  
end

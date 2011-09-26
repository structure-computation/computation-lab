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
  
  #Access control. Check if current_worksapce_member is current_sc_model_owner
  def current_sc_model_owner         
    # where(:sc_model_id => sc_model.id  , :workspace_member_id => current_workspace_member.user)  
    # current_workspace_member.
    # @current_sc_model = ScModel.find_by_id(params[:id]) 
    # @workspace_member_to_model_ownership = WorkspaceMemberToModelOwnership.first(params[:sc_model_id => @current_sc_model , :workspace_member_id => current_workspace_member]) 
    # current_workspace_member == @workspace_member_to_model_ownership.workspace_member                                                                                        
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

end
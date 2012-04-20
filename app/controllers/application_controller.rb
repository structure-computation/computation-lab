class ApplicationController < ActionController::Base
  
  include SCAuthenticationHelpers
#   protect_from_forgery

  # TODO: Refaire.
  def valid_admin_user
    admin_workspace = ScAdmin.find_by_workspace_id(current_workspace_member.workspace.id)
    admin_user = admin_workspace.user_sc_admins.find(:first, :conditions => {:user_id => current_user.id})
    if !admin_user
      redirect_back_or_default(root_path)
    end
  end
  

  
  #Access control. Check if current_worksapce_member is current_sc_model_owner
  # TODO: Supprimer si inutile.
  def current_sc_model_owner         
    # where(:sc_model_id => sc_model.id  , :workspace_member_id => current_workspace_member.user)  
    # current_workspace_member.
    # @current_sc_model = ScModel.find_by_id(params[:id]) 
    # @workspace_member_to_model_ownership = WorkspaceMemberToModelOwnership.first(params[:sc_model_id => @current_sc_model , :workspace_member_id => current_workspace_member]) 
    # current_workspace_member == @workspace_member_to_model_ownership.workspace_member                                                                                        
  end        



end
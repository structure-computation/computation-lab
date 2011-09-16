class HomeController < ApplicationController
  before_filter :authenticate_user!  
  before_filter :set_page_name 
  
  layout 'workspace'
  
  def set_page_name
    @page = :accueil
  end
  
  def index     
    # Si UserWorkspaceMembership est un Engineer
    # alors sa homepage est une redirection sur la partie Laboratoire du current workspace 
    # Si UserWorkspaceMembership est un Manager
    # alors sa homepage est une redirection sur la partie financière du current workspace    
    # case role
    # when "Engineer" 
    #   @user_workspace_membership.engineer == true
    #   redirect_to workspace_sc_models_path
    # when "Manager" 
    #   @user_workspace_membership.manager == true
    #   redirect_to workspace_bills_path      
    # when "Engineer and Manager, both"
    #   (@user_workspace_membership.engineer == true) && (@user_workspace_membership.manager == true) 
    #   redirect_to workspace_sc_models_path
    # end                                                     
    @workspace               = current_workspace_member.workspace
    @current_member_engineer = UserWorkspaceMembership.find_by_engineer(true)   
    @current_member_manager  = UserWorkspaceMembership.find_by_manager(true)                    
                   
    if @current_member_engineer == true
      redirect_to workspace_sc_models_path(current_workspace) 
    else
      redirect_to workspace_bills_path(current_workspace) 
    end                                       
                    
    if @current_member_manager == true
      redirect_to workspace_bills_path(current_workspace) 
    else
      redirect_to workspace_sc_models_path(current_workspace) 
    end
       
  end

end

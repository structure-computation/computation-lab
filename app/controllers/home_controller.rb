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

    if current_workspace_member.engineer?  
      redirect_to workspace_sc_models_path(current_workspace)
    elsif current_workspace_member.manager? 
      redirect_to workspace_path(current_workspace)     
    end                                                                                 
  #end of index  
  end
end

class HomeController < ApplicationController
  before_filter :authenticate_user!  
  before_filter :set_page_name 
  
  layout 'workspace'
  
  def set_page_name
    @page = :accueil
  end
  
  def index     
    case 
    when current_workspace_member.engineer?   
      redirect_to workspace_sc_models_path(current_workspace_member.workspace)
    when current_workspace_member.manager? 
      redirect_to workspace_path(current_workspace_member.workspace)    
    when !current_workspace_member.engineer? && !current_workspace_member.manager?  
      render :index
      flash[:notice] = "Vous n'avez pas de statut (ingénieur ou gestionnaire) attribué. Veuillez contacter le service client." 
    end                                                                                 
  #end of index  
  end
end

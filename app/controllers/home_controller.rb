class HomeController < ApplicationController
  before_filter :authenticate_user!  
  before_filter :set_page_name 
  
  layout 'workspace'
  
  def set_page_name
    @page = :accueil
  end
  
  def index     
    case 
    when  current_workspace_member.engineer? && !current_workspace_member.manager?   
      redirect_to workspace_sc_models_path(current_workspace_member.workspace)        
      
    when   current_workspace_member.manager? && !current_workspace_member.engineer? 
      redirect_to workspace_path(current_workspace_member.workspace)                
      
    when  current_workspace_member.engineer? && current_workspace_member.manager?  
      redirect_to workspace_sc_models_path(current_workspace_member.workspace)        
        
    when !current_workspace_member.engineer? && !current_workspace_member.manager?  
      #render :index
      respond_to do |format|
      format.html {redirect_to workspace_path(current_workspace_member.workspace), 
                  :notice => "Vous n'avez pas de statut (ingénieur ou gestionnaire) attribué. Veuillez contacter le service client."}
      format.json {render :status => 404, :json => {}}   
      end   
    end                                                                              
  #end of index  
  end
end
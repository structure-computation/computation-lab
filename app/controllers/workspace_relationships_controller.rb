class WorkspaceRelationshipsController < InheritedResources::Base   
  belongs_to :workspace
  belongs_to :related_workspace, :class_name => "Workspace"
    
  #WorkspaceRelationships Controller : Action create a related workspace
  def create  
    @relationship = current_user.workspace_relationships.build(:related_workspace_id => params[:related_workspace_id])  
    if @relationship.save  
      flash[:notice] = "Added workspace."  
      redirect_to root_url  
    else  
      flash[:notice] = "Unable to add workspace."  
      redirect_to root_url  
    end     
  end   

  #WorkspaceRelationships Controller : Action delete a related workspace
  def destroy  
    @relationship = current_user.workspace_relationships.find(params[:id])  
    @relationship.destroy  
    flash[:notice] = "Removed Workspace."  
    redirect_to current_workspace  
  end   
end

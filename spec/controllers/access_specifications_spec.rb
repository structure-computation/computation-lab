require 'spec_helper'

describe "Access rights on RESTressources" do 
  
  describe WorkspacesController do 
    let :mock_workspace         do mock_model(Workspace).as_null_object end
    let :current_workspace      do FactoryGirl.build(:workspace)        end
    let :mock_workspace_member  do mock_model(UserWorkspaceMembership, :workspace => current_workspace ).as_null_object end    
      
    before(:each) do
      controller.stub(:authenticate_user! => true )                 
      controller.stub(:current_workspace_member => mock_workspace_member ) 
      controller.stub(:current_workspace => mock_workspace)
    end  
    
    describe "workspace can be acces only if current_workspace" do 
      #Workspace.should_receive(:?) 
      get :show, :workspace_id => current_workspace.id
      response.should render_template("workspace/show")
    end
    
    # describe " a manager can access to workspace" do 
    # end
    #   
    # describe " others roles cannot access to Bills and DetailWorkspace " do
    # end             
  end                         
  
  # describe "Access to subworkspaces from current_workspace" do
  # end 
  # describe "Access rights on ScModels"                      do
  # end                                   
  # describe "Access rights on Links"                         do 
  # end
  # describe "Access rights on Materials"                     do 
  # end  
  # describe "Access rights on Bills"                          do 
  # end                           
  
end
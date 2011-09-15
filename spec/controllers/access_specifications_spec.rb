require 'spec_helper'

describe "Access rights on RESTressources" do 
  
  describe WorkspacesController do 
    # NOTE: controller_name :workspace ne fonctionne pas, controller_name n'est pas trouvé.
    let :current_workspace        do FactoryGirl.build(:workspace)        end
    let :other_workspace          do FactoryGirl.build(:workspace)        end                                     
    let :user                     do FactoryGirl.build(:user)             end                                     
    #let :mock_workspace_member  do mock_model(UserWorkspaceMembership, :workspace => current_workspace ).as_null_object end    
    # let :mock_workspace_engineer  do mock_model(UserWorkspaceMembership, :workspace => current_workspace, 
    #                                                                         :role => engineer ).as_null_object 
    #                                  end
    #    let :mock_workspace_manager   do mock_model(UserWorkspaceMembership, :workspace => current_workspace, 
    #                                                                         :role => manager ).as_null_object 
    #                                  end                              
                                 

  before(:each) do
    controller.stub(:authenticate_user!         => true                     )                 
    #controller.stub(:current_workspace_engineer => mock_workspace_engineer  )
    #controller.stub(:current_workspace_manager  => mock_workspace_manager   ) 
    controller.stub(:current_workspace          => current_workspace        )   
    @engineer_member  = FactoryGirl.create(:engineer_member                 )
    @manager_member   = FactoryGirl.create(:manager_member                  )
    
    current_workspace.save
    other_workspace.save
  end  
        
    it "redirect to workspace/sc_models when user is an engineer" do 
      get :show, :id => current_workspace.id    
      assigns(:engineer_member ).should eq( [@engineer_member] )
      response.should render_template("scmodels/index")      
    end
    
    it "redirect to workspace/bills when user is an manager" do 
      get :show, :id => current_workspace.id           
      assigns(:manager_member ).should eq( [@manager_member] )
      response.should render_template("bills/index")      
    end
    
    # it "workspace can be acces if it is current_workspace" do 
    #   #Workspace.should_receive(:?) 
    #   get :show, :id => current_workspace.id
    #   # NOTE: ne fonctionne pas response.should render_template("workspace/show").with(:layout =>'workspace')
    #   response.should render_template(["layouts/workspace", "workspace/show"])      
    # end
    # 
    # it "workspace can not be acces if it is not current_workspace" do 
    #   #Workspace.should_receive(:?) 
    #   get :show, :id => other_workspace.id
    #   # NOTE: ne fonctionne pas response.should render_template("workspace/show").with(:layout =>'workspace')
    #   response.should redirect_to(workspace_path(current_workspace))
    #   flash[:notice].should eq("Vous demandez l'affichage d'une page appartenant à un autre espace de travail.")
    # end
    
    
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
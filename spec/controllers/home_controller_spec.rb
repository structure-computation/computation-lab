require 'spec_helper'

describe "Where will it redirect you when you log in" do         
  let :current_workspace        do FactoryGirl.build(:workspace)                                         end
  let :mock_workspace_member    do mock_model(UserWorkspaceMembership, :workspace => current_workspace)  end
    
  describe HomeController do
    context "Log in as an Engineer and not a Manager" do  
      
      before(:each) do           
        controller.stub(:authenticate_user!       => true                  ) 
        controller.stub(:current_workspace_member => mock_workspace_member )  
        mock_workspace_member.stub(:engineer?     => true                  )  
        mock_workspace_member.stub(:manager?      => false                 )      
        current_workspace.save!               
      end                  
                  
      it "redirect to workspace/X/sc_models" do
        get :index, :workspace_id => current_workspace.id    
        response.should redirect_to(workspace_sc_models_path(current_workspace)) 
      end   
    # enf of context log in as an engineer
    end      
                  
    context " User is a Manager and not an Engineer" do  
      
      before(:each) do  
        controller.stub( :authenticate_user! => true                            ) 
        controller.stub( :current_workspace_member     => mock_workspace_member )  
        mock_workspace_member.stub ( :engineer? => false                        )
        mock_workspace_member.stub ( :manager?  => true                         ) 
        current_workspace.save
      end                            
      
      it "should not redirect to /workspaces/X#Factures" do     
        get :index, :id => current_workspace.id  
        response.should redirect_to(workspace_path(current_workspace))  
        #flash[:notice].should eq("Vous n'avez pas accès à cette partie de l'espace de travail.")
      end                               
      
    #end of context not an engineer         
    end               
    
    context "Log in as an Engineer and a Manager" do  
      
      before(:each) do           
        controller.stub(:authenticate_user!       => true                  ) 
        controller.stub(:current_workspace_member => mock_workspace_member )  
        mock_workspace_member.stub(:engineer?     => true                  )  
        mock_workspace_member.stub(:manager?      => true                  )      
        current_workspace.save!               
      end                  
                  
      it "redirect to workspace/X/sc_models" do
        get :index, :workspace_id => current_workspace.id    
        response.should redirect_to(workspace_sc_models_path(current_workspace)) 
      end   
    # enf of context log in as an engineer and a manager
    end   
    
    context "Log in is not an Engineer and not a Manager" do  
      
      before(:each) do           
        controller.stub(:authenticate_user!       => true                   ) 
        controller.stub(:current_workspace_member => mock_workspace_member  )  
        mock_workspace_member.stub(:engineer?     => false                  )  
        mock_workspace_member.stub(:manager?      => false                  )      
        current_workspace.save!               
      end                  
                  
      it "redirect to workspace/X/sc_models" do
        get :index, :workspace_id => current_workspace.id    
        response.should redirect_to(workspace_path(current_workspace)) 
        flash[:notice] = "Vous n'avez pas de statut (ingénieur ou gestionnaire) attribué. Veuillez contacter le service client."   
    # enf of context log in as an engineer and a manager                                                                                 
      end
    end
  #end of describe HomeController   
  end 
end

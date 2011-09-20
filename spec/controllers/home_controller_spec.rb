require 'spec_helper'

describe "Where will it redirect you when you log in" do         
  let :current_workspace        do FactoryGirl.build(:workspace)                                         end
  let :mock_workspace_member    do mock_model(UserWorkspaceMembership, :workspace => current_workspace)  end
    
  describe HomeController do
    describe "Access to laboratory" do  
      context "Log in as an Engineer" do  
        
        before(:each) do           
          controller.stub(:authenticate_user!       => true                  ) 
          controller.stub(:current_workspace_member => mock_workspace_member )  
          mock_workspace_member.stub(:engineer?     => true                  )    
          current_workspace.save!               
        end                  
                    
        it "redirect to workspace/X/sc_models" do
          get :index, :workspace_id => current_workspace.id    
          #assigns(:workspace ).should eq( [@current_workspace] )
          response.should redirect_to(workspace_sc_models_path(current_workspace)) 
        end   
      # enf of context log in as an engineer
      end      
                    
      context "Not an Engineer" do  
        
        before (:each) do  
          controller.stub            (:authenticate_user! => true                            ) 
          controller.stub            (:current_workspace_member     => mock_workspace_member )  
          mock_workspace_member.stub (:engineer? => false                                    ) 
          current_workspace.save
        end                            
        
        it "should not redirect to /workspaces/X#Factures" do     
          get :index, :id => current_workspace.id  
          response.should redirect_to(workspace_path(current_workspace))  
          flash[:notice].should eq("Vous n'avez pas accès à cette partie de l'espace de travail.")
        end                               
        
      #end of context not an engineer         
      end
    #end of describe access to laboratory 
    end                 
    
    # describe "Access to management space" do  
    #   context "Log in as a Manager" do
    #     before(:each) do  
    #       controller.stub(:authenticate_user!  => true                  ) 
    #       controller.stub(:current_workspace   => mock_workspace_member )  
    #       mock_workspace_member.stub(:manager? => true                  )    
    #       current_workspace.save!
    #     end                            
    #     it "redirect to /workspaces/id/Factures" do
    #       response.should redirect_to(workspace_path(current_workspace)) 
    #     end  
    #   #end of context log in as a manager   
    #   end
    #   
    #   context "Not a Manager" do
    #     before (:each) do    
    #       controller.stub(:authenticate_user!  => true                  ) 
    #       controller.stub(:current_workspace   => mock_workspace_member )  
    #       mock_workspace_member.stub(:manager? => false                 )    
    #       current_workspace.save!
    #     end         
    #                      
    #     it"should not redirect to workspace/X/sc_models"do 
    #     
    #       response.should redirect_to(workspace_bills_path(current_workspace))
    #       flash[:notice].should eq("Vous n'avez pas accès à cette partie de l'espace de travail.")
    #     end  
    #   #end of context not a manager  
    #   end 
    # #end of describe access to finance
    # end 
  #end of describe HomeController 
  end 
end

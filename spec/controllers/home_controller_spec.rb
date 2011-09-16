require 'spec_helper'

describe "Where will it redirect you when you log in" do 
  let :current_workspace        do FactoryGirl.build(:workspace)                                         end
  let :other_workspace          do FactoryGirl.build(:workspace)                                         end                                     
  let :mock_current_member      do mock_model(UserWorkspaceMembership, :workspace => current_workspace)  end
    
  describe HomeController do
    context "You log in as an Engineer" do   
       
      before(:each) do           
        controller.stub(:authenticate_user! => true                                      ) 
        controller.stub(:current_member     => mock_current_member                       )   
        #@engineer_member  = FactoryGirl.create(:member, :workspace =>  current_workspace )   
        
      end                       
      
      it "redirect to workspace/X/sc_models" do
        UserWorkspaceMembership.stub!(:engineer).and_return(1)     
        get :index, :id => current_workspace.id    
        assigns(:workspace ).should eq( [@current_workspace] )
        response.should redirect_to(workspace_sc_models_path(current_workspace)) 
      end   
                          
      # Engineer n'a pas accès aux parties financières
      context "An Engineer want to acces to financiel part" do
        before (:each) do
        # 
        end
        it "should not redirect to /workspaces/X#Factures" do     
          get :index, :id => current_workspace.id              
          UserWorkspaceMembership.stub!(:engineer).and_return(1) 
          response.should redirect_to(workspace_sc_models_path(current_workspace))  
          #response.should_not be_redirect
          flash[:notice].should eq("Vous n'avez pas accès à cette partie de l'espace de travail.")
        end
      #end of forbidden financiel part           
      end
    #end of context Engineer 
    end                 
    
    context"You log in as a Manager" do      
      before(:each) do  
        controller.stub(:authenticate_user! => true                                     ) 
        controller.stub(:current_member     => mock_current_member                      ) 
        #@manager_member  = FactoryGirl.create(:member, :workspace =>  current_workspace )
      end                            
      it "redirect to /workspaces/X#Factures" do
        UserWorkspaceMembership.stub!(:manager).and_return(1)  
        get :index, :id => current_workspace.id    
        assigns(:workspace ).should eq( [@current_workspace] )
        response.should redirect_to(workspace_bills_path(current_workspace))  
      end   
      
      # Manager n'a pas accès aux parties laboratoires    
      context "An Manager want to acces to laboratory part" do   
        before (:each) do    
        #  
        end                          
        
        it"should not redirect to workspace/X/sc_models"do
          UserWorkspaceMembership.stub!(:manager).and_return(1)      
          get :index, :id => current_workspace.id 
          #response.should_not be_redirect   
          response.should redirect_to(workspace_bills_path(current_workspace))
          flash[:notice].should eq("Vous n'avez pas accès à cette partie de l'espace de travail.")
        end  
      #end of forbidden laboratory part  
      end 
    #end of context Manager
    end 
   #end of describe HomeController 
 end 
end

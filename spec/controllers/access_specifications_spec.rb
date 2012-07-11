# require 'spec_helper'
# 
# describe "Access rights on RESTressources" do 
#   
#   describe WorkspacesController do 
#     # NOTE: controller_name :workspace ne fonctionne pas, controller_name n'est pas trouvé.
#     let :current_workspace        do FactoryGirl.build(:workspace)        end
#     let :other_workspace          do FactoryGirl.build(:workspace)        end                                     
#     #let :current_member           do FactoryGirl.build(:user)           end  
#     let :mock_current_member      do mock_model(UserWorkspaceMembership)  end            
#     # let :mock_engineer_member  do mock_model(UserWorkspaceMembership, :workspace => current_workspace, 
#     #                                                                         :role => engineer ).as_null_object 
#     #                                  end
#     # let :mock_manager_member   do mock_model(UserWorkspaceMembership, :workspace => current_workspace, 
#     #                                                                         :role => manager ).as_null_object 
#     #                                  end                              
#                                  
#     # before(:each) do
#     #   controller.stub(:authenticate_user!         => true                                       )                 
#     #   #controller.stub(:current_engineer_manager    => mock_engineer_member  )
#     #   #controller.stub(:current_manager_manager     => mock_manager_member   ) 
#     #   controller.stub(:current_member             => mock_current_member                        )   
#     #   @engineer_member  = FactoryGirl.create(:engineer_member, :workspace =>  current_workspace )
#     #   @manager_member   = FactoryGirl.create(:manager_member , :workspace =>  current_workspace )
#     # end  
#     
#     describe "GET show" do                    
#       
#       context "UserWorkspaceMember is an Engineer" do
#         before (:each) do       
#           controller.stub(:authenticate_user! => true                                               ) 
#           controller.stub(:current_member     => mock_current_member                                )   
#           @engineer_member  = FactoryGirl.create(:member, :workspace =>  current_workspace )
#         end
#         it "redirect to workspace/sc_models" do 
#           get :show, :id => current_workspace.id    
#           assigns(:workspace ).should eq( [@current_workspace] )
#           response.should render_template("scmodels/index")
#           #response.should redirect_to(sc_models_path)   
#         end
#         it "should not redirect to workspace/bills" do 
#           get :show, :id => current_workspace.id           
#           assigns(:workspace ).should eq( [@current_workspace] )
#           response.should render_template("bills/index")  
#           #response.should redirect_to(bills_path)   
#         end    
#       end 
#       
#       context "UserWorkspaceMember is an Engineer" do
#         before (:each) do       
#           controller.stub(:authenticate_user! => true                                               ) 
#           controller.stub(:current_member     => mock_current_member                                )   
#           @manager_member   = FactoryGirl.create(:member , :workspace =>  current_workspace )
#         end
#         it "redirect to workspace/sc_models" do 
#           get :show, :id => current_workspace.id    
#           assigns(:workspace ).should eq( [@current_workspace] )
#           #response.should render_template("scmodels/index")
#           response.should redirect_to(workspace_sc_models_path(current_workspace))
#         end
#         it "should not redirect to workspace/bills" do 
#           get :show, :id => current_workspace.id           
#           assigns(:workspace ).should eq( [@current_workspace] )
#           #response.should render_template("bills/index")  
#           response.should redirect_to(workspace_bills_path(current_workspace))
#         end  
#       end               
#       
#       context "When an Member try to acces to a forbidden workspace or non existant workspace" do     
#         other_workspace             = FactoryGirl.create(:workspace)
#         @link_from_other_workspace  = FactoryGirl.create(:link, :workspace => other_workspace)
# 
#         before(:each) do
#           #not_member_workspace        = FactoryGirl.create(:member)  
#           forbidden_workspace         = FactoryGirl.create(:workspace)
#           #@workspace_not_member       = FactoryGirl.create(:workspace, :member => not_member_workspace) 
#           @workspace_not_member       = FactoryGirl.create(:member, :workspace => forbidden_workspace)
#           # Construction puis destruction d'un workspace pour avoir un workspace.id inexistant
#           tmp_workspace               = FactoryGirl.create(:workspace)
#           @non_existing_workspace_id  = tmp_workspace.id
#           tmp_workspace.destroy
#         end 
#     
#         it "in html, redirect to homepage if the user is not a member of the requested workspace." do
#           get :show, :id => @non_existing_workspace_id
#           assigns(:workspace).should be nil
#           response.should redirect_to("/users/sign_in")
#           flash[:notice].should eq("Vous demandez l'affichage d'une page appartenant à un autre espace de travail.")
#         end 
#       end            
#     end
#  
#     
#     # describe " a manager can access to workspace" do 
#     # end
#     #   
#     # describe " others roles cannot access to Bills and DetailWorkspace " do
#     # end             
#   end                         
#   
#   # describe "Access to subworkspaces from current_workspace" do
#   # end 
#   # describe "Access rights on ScModels"                      do
#   # end                                   
#   # describe "Access rights on Links"                         do 
#   # end
#   # describe "Access rights on Materials"                     do 
#   # end  
#   # describe "Access rights on Bills"                          do 
#   # end 
# end                          
#   
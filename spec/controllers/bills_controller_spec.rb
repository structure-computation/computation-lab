# require 'spec_helper'
# 
# describe BillsController do 
#   
#   let :mock_bills            do mock_model(Bill).as_null_object                                                     end
#   let :current_workspace     do FactoryGirl.build(:workspace)                                                       end
#   let :mock_workspace_member do mock_model(UserWorkspaceMembership,:workspace => current_workspace ).as_null_object end
# 
#   before(:each) do
#     controller.stub(:authenticate_user!       =>  true                  ) 
#     controller.stub(:current_workspace_member =>  mock_workspace_member )    
#     @workspace_bill  = FactoryGirl.create(:bill , :workspace =>  current_workspace )
#   end
# 
#   describe "GET index" do
#     it "ask for bill from workspace library" do
#       Bill.should_receive(:from_workspace)
#       get :index
#       response.should render_template("bills/index")
#     end  
#   end
#                              
# 
#   describe "GET show" do
#     it "assigns the requested bill as @bill if bill is a bill from current workspace." do
#       get :show, :id => @workspace_bills.id
#       assigns(:bill).should eq(@workspace_bills)
#       response.should render_template("bills/show")
#     end
#     
#     context "When a forbidden (outside of current_workspace) or non existant bill is asked" do 
#       before(:each) do
#         other_workspace             = FactoryGirl.create(:workspace)
#         @bill_from_other_workspace  = FactoryGirl.create(:bill, :workspace => other_workspace)
# 
#         # Construction puis destruction d'un matériel pour avoir un id inexistant
#         tmp_bill                   = FactoryGirl.create(:bill)
#         @non_existing_bill_id      = tmp_bill.id
#         tmp_bill.destroy
#       end
#       
#       it "in html, redirect to bills list if the requested bill belongs to an other workspace than current workspace." do
#         get :show, :id => @bill_from_other_workspace.id
#         assigns(:bills).should be nil
#         response.should redirect_to(workspace_bills_path(current_workspace))
#         flash[:notice].should eq("Ce bill n'existe pas ou n'est pas accessible à partir de cet espace de travail.")
#       end    
#     
#       it "in html, redirect to sc_models list if no sc_models is available with this id." do
#         # Get de l'id inexistant.
#         get :show, :id => @non_existing_bill_id
#         assigns(:bill).should be nil
#         response.should redirect_to(workspace_bills_path(current_workspace))
#         flash[:notice].should eq("Ce bill n'existe pas ou n'est pas accessible à partir de cet espace de travail.")
#       end
#       
#       it "in json, send a 404 error if the requested bill belongs to an other workspace than current workspace." do
#         get :show, :format => "json", :id => @bill_from_other_workspace.id
#         assert_response 404
#       end
#       
#       it "in json, send a 404 error if no bill is available with this id." do
#         get :show, :format => "json", :id => @non_existing_bill_id
#         assert_response 404
#       end
#     end
#   end
# end

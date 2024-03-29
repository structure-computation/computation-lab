# require 'spec_helper'
# 
# describe CustomersController do
# 
#   def mock_customer(stubs={})
#     (@mock_customer ||= mock_model(Customer).as_null_object).tap do |customer|
#       customer.stub(stubs) unless stubs.empty?
#     end
#   end
# 
#   describe "GET index" do
#     it "assigns all customers as @customers" do
#       Customer.stub(:all) { [mock_customer] }
#       get :index
#       assigns(:customers).should eq([mock_customer])
#     end
#   end
# 
#   describe "GET show" do
#     it "assigns the requested customer as @customer" do
#       Customer.stub(:find).with("37") { mock_customer }
#       get :show, :id => "37"
#       assigns(:customer).should be(mock_customer)
#     end
#   end
# 
#   describe "GET new" do
#     it "assigns a new customer as @customer" do
#       Customer.stub(:new) { mock_customer }
#       get :new
#       assigns(:customer).should be(mock_customer)
#     end
#   end
# 
#   describe "GET edit" do
#     it "assigns the requested customer as @customer" do
#       Customer.stub(:find).with("37") { mock_customer }
#       get :edit, :id => "37"
#       assigns(:customer).should be(mock_customer)
#     end
#   end
# 
#   describe "POST create" do
# 
#     describe "with valid params" do
#       it "assigns a newly created customer as @customer" do
#         Customer.stub(:new).with({'these' => 'params'}) { mock_customer(:save => true) }
#         post :create, :customer => {'these' => 'params'}
#         assigns(:customer).should be(mock_customer)
#       end
# 
#       it "redirects to the created customer" do
#         Customer.stub(:new) { mock_customer(:save => true) }
#         post :create, :customer => {}
#         response.should redirect_to(customer_url(mock_customer))
#       end
#     end
# 
#     describe "with invalid params" do
#       it "assigns a newly created but unsaved customer as @customer" do
#         Customer.stub(:new).with({'these' => 'params'}) { mock_customer(:save => false) }
#         post :create, :customer => {'these' => 'params'}
#         assigns(:customer).should be(mock_customer)
#       end
# 
#       it "re-renders the 'new' template" do
#         Customer.stub(:new) { mock_customer(:save => false) }
#         post :create, :customer => {}
#         response.should render_template("new")
#       end
#     end
# 
#   end
# 
#   describe "PUT update" do
# 
#     describe "with valid params" do
#       it "updates the requested customer" do
#         Customer.should_receive(:find).with("37") { mock_customer }
#         mock_customer.should_receive(:update_attributes).with({'these' => 'params'})
#         put :update, :id => "37", :customer => {'these' => 'params'}
#       end
# 
#       it "assigns the requested customer as @customer" do
#         Customer.stub(:find) { mock_customer(:update_attributes => true) }
#         put :update, :id => "1"
#         assigns(:customer).should be(mock_customer)
#       end
# 
#       it "redirects to the customer" do
#         Customer.stub(:find) { mock_customer(:update_attributes => true) }
#         put :update, :id => "1"
#         response.should redirect_to(customer_url(mock_customer))
#       end
#     end
# 
#     describe "with invalid params" do
#       it "assigns the customer as @customer" do
#         Customer.stub(:find) { mock_customer(:update_attributes => false) }
#         put :update, :id => "1"
#         assigns(:customer).should be(mock_customer)
#       end
# 
#       it "re-renders the 'edit' template" do
#         Customer.stub(:find) { mock_customer(:update_attributes => false) }
#         put :update, :id => "1"
#         response.should render_template("edit")
#       end
#     end
# 
#   end
# 
#   describe "DELETE destroy" do
#     it "destroys the requested customer" do
#       Customer.should_receive(:find).with("37") { mock_customer }
#       mock_customer.should_receive(:destroy)
#       delete :destroy, :id => "37"
#     end
# 
#     it "redirects to the customers list" do
#       Customer.stub(:find) { mock_customer }
#       delete :destroy, :id => "1"
#       response.should redirect_to(customers_url)
#     end
#   end
# 
# end

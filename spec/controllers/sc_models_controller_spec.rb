# require 'spec_helper'
# 
# describe ScModelsController do
# 
#   def mock_sc_models(stubs={})
#     @mock_sc_models ||= mock_model(ScModel, stubs)
#   end
# 
#   describe "GET index" do 
#     it "assigns all sc_models as @sc_models" do
#       ScModel.stub!(:find).with(:all).and_return([mock_sc_models])
#       get :index
#       assigns[:ScModels].should == [mock_sc_models]
#     end
#   end
# 
#   describe "GET show" do
#     it "assigns the requested ScModels as @ScModels" do
#       ScModel.stub!(:find).with("37").and_return(mock_sc_models)
#       get :show, :id => "37"
#       assigns[:ScModels].should equal(mock_sc_models)
#     end
#   end
# 
#   describe "GET new" do
#     it "assigns a new ScModels as @ScModels" do
#       ScModel.stub!(:new).and_return(mock_sc_models)
#       get :new
#       assigns[:ScModels].should equal(mock_sc_models)
#     end
#   end
# 
#   describe "GET edit" do
#     it "assigns the requested ScModels as @ScModels" do
#       ScModel.stub!(:find).with("37").and_return(mock_sc_models)
#       get :edit, :id => "37"
#       assigns[:ScModels].should equal(mock_sc_models)
#     end
#   end
# 
#   describe "POST create" do
# 
#     describe "with valid params" do
#       it "assigns a newly created ScModels as @ScModels" do
#         ScModel.stub!(:new).with({'these' => 'params'}).and_return(mock_sc_models(:save => true))
#         post :create, :ScModels => {:these => 'params'}
#         assigns[:ScModels].should equal(mock_sc_models)
#       end
# 
#       it "redirects to the created ScModels" do
#         ScModel.stub!(:new).and_return(mock_sc_models(:save => true))
#         post :create, :ScModels => {}
#         response.should redirect_to(ScModels_url(mock_sc_models))
#       end
#     end
# 
#     describe "with invalid params" do
#       it "assigns a newly created but unsaved ScModels as @ScModels" do
#         ScModel.stub!(:new).with({'these' => 'params'}).and_return(mock_sc_models(:save => false))
#         post :create, :ScModels => {:these => 'params'}
#         assigns[:ScModels].should equal(mock_sc_models)
#       end
# 
#       it "re-renders the 'new' template" do
#         ScModel.stub!(:new).and_return(mock_sc_models(:save => false))
#         post :create, :ScModels => {}
#         response.should render_template('new')
#       end
#     end
# 
#   end
# 
#   describe "PUT update" do
# 
#     describe "with valid params" do
#       it "updates the requested ScModels" do
#         ScModel.should_receive(:find).with("37").and_return(mock_sc_models)
#         mock_sc_models.should_receive(:update_attributes).with({'these' => 'params'})
#         put :update, :id => "37", :ScModels => {:these => 'params'}
#       end
# 
#       it "assigns the requested ScModels as @ScModels" do
#         ScModel.stub!(:find).and_return(mock_sc_models(:update_attributes => true))
#         put :update, :id => "1"
#         assigns[:ScModels].should equal(mock_sc_models)
#       end
# 
#       it "redirects to the ScModels" do
#         ScModel.stub!(:find).and_return(mock_sc_models(:update_attributes => true))
#         put :update, :id => "1"
#         response.should redirect_to(ScModels_url(mock_sc_models))
#       end
#     end
# 
#     describe "with invalid params" do
#       it "updates the requested ScModels" do
#         ScModel.should_receive(:find).with("37").and_return(mock_sc_models)
#         mock_sc_models.should_receive(:update_attributes).with({'these' => 'params'})
#         put :update, :id => "37", :ScModels => {:these => 'params'}
#       end
# 
#       it "assigns the ScModels as @ScModels" do
#         ScModel.stub!(:find).and_return(mock_sc_models(:update_attributes => false))
#         put :update, :id => "1"
#         assigns[:ScModels].should equal(mock_sc_models)
#       end
# 
#       it "re-renders the 'edit' template" do
#         ScModel.stub!(:find).and_return(mock_sc_models(:update_attributes => false))
#         put :update, :id => "1"
#         response.should render_template('edit')
#       end
#     end
# 
#   end
# 
#   describe "DELETE destroy" do
#     it "destroys the requested ScModels" do
#       ScModel.should_receive(:find).with("37").and_return(mock_sc_models)
#       mock_sc_models.should_receive(:destroy)
#       delete :destroy, :id => "37"
#     end
# 
#     it "redirects to the ScModelss list" do
#       ScModel.stub!(:find).and_return(mock_sc_models(:destroy => true))
#       delete :destroy, :id => "1"
#       response.should redirect_to(ScModelss_url)
#     end
#   end                            
# 
# end   
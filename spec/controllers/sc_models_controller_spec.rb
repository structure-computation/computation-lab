require 'spec_helper'

describe ScModelsController do
  let :mock_sc_model            do mock_model(ScModel, :destroy => true).as_null_object end
  let :current_sc_model         do FactoryGirl.build(:sc_model)                         end
  let :current_workspace        do FactoryGirl.build(:workspace)                        end   
  let :mock_workspace_member    do 
    mock_model(UserWorkspaceMembership, :workspace    => current_workspace ).as_null_object 
  end
   
  before(:each) do
    controller.stub(:authenticate_user!       =>  true                   ) 
    controller.stub(:current_workspace_member =>  mock_workspace_member  )    
    @sc_model  = FactoryGirl.create(:sc_model , :workspace =>  current_workspace )
    @sc_model.save 
  end

  describe "Access for managers roles" do
    before(:each) do mock_workspace_member.stub(:engineer? => true) end
    context "When accessing scmodels" do     
      it "can access index" do get :index  , :workspace_id => current_workspace.id;                        should respond_with(:success)   end
      it "can access show"  do get :show   , :workspace_id => current_workspace.id, :id => @sc_model.id ;  should respond_with(:success)   end
    end   
  end     
  
  describe "Acces for non-managers roles" do
    before(:each) do mock_workspace_member.stub(:engineer? => false) end
    context "When accessing to scmodels" do                                                              
      it "can NOT access index" do get :index , :workspace_id => current_workspace.id;                        should respond_with(:forbidden) end 
      it "can NOT access show"  do get :show  , :workspace_id => current_workspace.id, :id => @sc_model.id ;  should respond_with(:forbidden) end   
    end    
  end   
  
  describe "Assign current_workspace member as workspace_member_to_model_ownership" do
    before(:each) do 
      mock_workspace_member.stub(:engineer? => true) 
    end  
    it "should assign current_workspace_member as the owner of the new sc_model"    do
    end     
  end
    
  describe "Only sc model's owner can destroy its sc models" do         
    
    let :mock_sc_model_owner do mock_model(WorkspaceMemberToModelOwnership, 
                                          :sc_model => current_sc_model, 
                                          :current_workspace_member =>  mock_workspace_member ) 
    end
       
    before(:each) do 
      mock_workspace_member.stub(:engineer? => true)  
      mock_workspace_member.stub(:right => "all"   )
    end                                             
    
    it "should destroy the required model if current_user == sc_model_owner" do   
      post :destroy, :workspace_id => current_workspace.id, :id => current_sc_model.id
      response.should redirect_to(workspace_sc_models_path(current_workspace))  
      flash[:notice].should eq("Le modèle a bien été détruit")    
    end
  end 
  
  describe "You can NOT destroy a scmodel that you are not the owner"        do  
     
    let :other_sc_model          do FactoryGirl.build(:sc_model)             end   
    let :mock_not_sc_model_owner do 
      mock_model(WorkspaceMemberToModelOwnership, 
                 :sc_model => other_sc_model, 
                 :current_workspace_member =>  mock_workspace_member) 
    end
   
    before(:each) do 
      mock_workspace_member.stub(:engineer? => true  )
      mock_workspace_member.stub(:right => "readonly")          
    end                                             
    
    it "should destroy the required model if current_user == sc_model_owner" do
      response.should redirect_to(workspace_sc_models_path(current_workspace))  
      flash[:notice].should eq("Vous ne pouvez pas détruire ce modèle")    
    end
  end
  
end





# require 'spec_helper'
# 
# describe ScModelsController do 
#   
#   let :mock_sc_models           do mock_model(ScModel).as_null_object              end
#   let :current_workspace        do FactoryGirl.build(:workspace)                   end
#   let :mock_workspace_member    do 
#     mock_model(UserWorkspaceMembership, #:workspace_id => current_workspace.id 
#                                         :workspace    => current_workspace ).as_null_object 
#   end
# 
#   before(:each) do
#     controller.stub(:authenticate_user!       =>  true              ) # .and_return(true)
#     controller.stub(:current_workspace_member =>  mock_workspace_member )    
#     @workspace_sc_model  = FactoryGirl.create(:sc_model , :workspace =>  current_workspace )     
#   end
# 
#   describe "GET index" do
#     it "ask for scmodels from std scmodels library and from workspace library" do
#       ScModel.should_receive(:from_workspace)
#       get :index
#       response.should render_template("sc_models/index")
#     end  
#   end
#                              
# 
#   describe "GET show" do
#     it "assigns the requested scmodel as @sc_model if sc_model is a sc_model from current workspace." do
#       get :show, :id => @workspace_sc_model.id
#       assigns(:sc_model).should eq(@workspace_sc_model)
#       response.should render_template("sc_models/show")       
#     end
#     
#     context "When a forbidden (outside of current_workspace) or non existant material is asked" do 
#       before(:each) do
#         other_workspace                 = FactoryGirl.create(:workspace)
#         @sc_model_from_other_workspace  = FactoryGirl.create(:sc_model, :workspace => other_workspace)
# 
#         # Construction puis destruction d'un matériel pour avoir un id inexistant
#         tmp_sc_model                    = FactoryGirl.create(:sc_model)
#         @non_existing_sc_model_id       = tmp_sc_model.id
#         tmp_sc_model.destroy
#       end
#       
#       it "in html, redirect to sc_models list if the requested sc_model belongs to an other workspace than current workspace." do
#         get :show, :id => @sc_model_from_other_workspace.id
#         assigns(:sc_models).should be nil
#         response.should redirect_to(workspace_sc_models_path(current_workspace))
#         flash[:notice].should eq("Ce modèle n'existe pas ou n'est pas accessible à partir de cet espace de travail.")
#       end    
#     
#       it "in html, redirect to sc_models list if no sc_models is available with this id." do
#         # Get de l'id inexistant.
#         get :show, :id => @non_existing_sc_model_id
#         assigns(:sc_models).should be nil
#         response.should redirect_to(workspace_sc_models_path(current_workspace))
#         flash[:notice].should eq("Ce modèle n'existe pas ou n'est pas accessible à partir de cet espace de travail.")
#       end
#       
#       it "in json, send a 404 error if the requested material belongs to an other workspace than current workspace." do
#         get :show, :format => "json", :id => @sc_model_from_other_workspace.id
#         assert_response 404
#       end
#       
#       it "in json, send a 404 error if no scmodel is available with this id." do
#         get :show, :format => "json", :id => @non_existing_sc_model_id
#         assert_response 404
#       end
#     end
#   end

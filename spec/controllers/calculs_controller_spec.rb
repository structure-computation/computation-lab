require 'spec_helper'

describe CalculsController do
  let :mock_link                do mock_model(Link).as_null_object                      end
  let :mock_material            do mock_model(Material).as_null_object                  end     
  let :mock_calcul_result       do mock_model(CalculResult).as_null_object              end
  let :current_sc_model         do FactoryGirl.build(:sc_model)                         end 
  let :current_workspace        do FactoryGirl.build(:workspace)                        end
  let :mock_workspace_member    do                                              
    mock_model(UserWorkspaceMembership, :workspace    => current_workspace ).as_null_object 
  end
   
  before(:each) do
    controller.stub(:authenticate_user!       =>  true                   ) 
    controller.stub(:current_workspace_member =>  mock_workspace_member  )    
    @standard_link      = FactoryGirl.create(:standard_link                                     )
    @workspace_link     = FactoryGirl.create(:link ,           :workspace =>  current_workspace )  
    @standard_material  = FactoryGirl.create(:standard_material                                 )
    @workspace_material = FactoryGirl.create(:link ,           :workspace =>  current_workspace )
    @calcul_result      = FactoryGirl.create(:calcul_result ,  :workspace =>  current_workspace )
  
  end

  describe "Access for managers roles" do
    before(:each) do mock_workspace_member.stub(:engineer? => true) end
    context "When accessing to calculs" do     
      it "can access index" do get :index  , :sc_model_id => current_sc_model.id;  should respond_with(:success) end
      it "can access show"  do get :show   , :sc_model_id => current_sc_model.id;  should respond_with(:success) end
    end   
  end     
  
  describe "Acces for non-managers roles" do
    before(:each) do mock_workspace_member.stub(:engineer? => false) end
    context "When accessing to calculs" do                                                              
      it "can NOT access index" do get :index , :sc_model_id => current_sc_model.id;                        should respond_with(:forbidden) end 
      it "can NOT access show"  do get :show  , :sc_model_id => current_sc_model.id, :id => @sc_model.id ;  should respond_with(:forbidden) end   
    end    
  end
end



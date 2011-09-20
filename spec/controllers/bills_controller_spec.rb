require 'spec_helper'

describe BillsController do 
  let :mock_bill                do mock_model(Bill).as_null_object                      end
  let :current_workspace        do FactoryGirl.build(:workspace)                        end
  let :mock_workspace_member    do 
    mock_model(UserWorkspaceMembership, :workspace    => current_workspace ).as_null_object 
  end
   
  before(:each) do
    controller.stub(:authenticate_user!       =>  true                   ) 
    controller.stub(:current_workspace_member =>  mock_workspace_member  )    
    @bill  = FactoryGirl.create(:bill , :workspace =>  current_workspace )
    @bill.save 
        
  end

  describe "Access for managers roles" do
    before(:each) do mock_workspace_member.stub(:manager? => true) end
    context "When accessing bills" do     
      it "can access index" do get :index  , :workspace_id => current_workspace.id;                    should respond_with(:success)   end
      it "can access show"  do get :show   , :workspace_id => current_workspace.id, :id => @bill.id ;  should respond_with(:success)    end
    end   
  end     
  
  describe "Acces for non-managers roles" do
    before(:each) do mock_workspace_member.stub(:manager? => false) end
    context "When accessing to bills" do
      it "can NOT access index" do get :index , :workspace_id => current_workspace.id;                    should respond_with(:forbidden) end 
      it "can NOT access show"  do get :show  , :workspace_id => current_workspace.id, :id => @bill.id ;  should respond_with(:forbidden) end   
    end    
  end  
  
end



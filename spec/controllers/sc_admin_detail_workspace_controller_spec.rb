require 'spec_helper' 

describe ScAdminDetailWorkspaceController do 
  let :mock_forfait          do mock_model(Forfait).as_null_object                 end  
  let :mock_abonnement       do mock_model(Abonnement).as_null_object             end
  let :mock_workspace_member do mock_model(UserWorkspaceMembership).as_null_object end 
  
  before(:each) do
    controller.stub(:authenticate_user!       =>  true                  ) 
    @forfait     = FactoryGirl.create(:forfait                          )                                
    @abonnement  = FactoryGirl.create(:abonnement                       )
    @forfait.save 
    @abonnement.save      
  end

  describe "Access for managers roles" do
    before(:each) do mock_workspace_member.stub(:manager? => true) end
    context "When accessing details : forfaits and abonnements" do     
      it "can access index" do get :index  ;                          should respond_with(:success)   end
      it "can access show"  do get :show   ,  :id => @forfait.id ;    should respond_with(:success)   end
      it "can access show"  do get :show   ,  :id => @abonnement.id ; should respond_with(:success)   end
                                             
    end   
  end     
  
  describe "Acces for non-managers roles" do
    before(:each) do mock_workspace_member.stub(:manager? => false) end
    context "When accessing to details" do
      it "can NOT access index" do get :index ;                         should respond_with(:forbidden) end 
      it "can NOT access show"  do get :show  , :id => @forfait.id ;    should respond_with(:forbidden) end   
      it "can NOT access show"  do get :show  , :id => @abonnement.id ; should respond_with(:forbidden) end   
    end                                        
  end                                          
end
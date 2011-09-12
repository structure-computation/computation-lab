# require 'spec_helper'
# 
# describe MaterialsController do  
#   def mock_resource(stubs={})
#     @mock_resource ||= mock_model(Material, stubs).as_null_object
#   end
# 
#   describe "DELETE destroy" do
#     it "destroys the requested resource" do
#       Material.stub(:find).with("980190962") { mock_resource }
#       mock_resource.should_receive(:destroy)
#       delete :destroy, :id => "980190962"
#     end
# 
#     it "redirects to the resources list" do
#       Material.stub(:find) { mock_resource }
#       delete :destroy, :id => "1"
#       response.should redirect_to(resources_url)
#     end
#   end
# end   
# 
#                     

require 'spec_helper'

describe MaterialsController do
  describe "POST create" do
    it "creates a new Material" do
      Material.should_receive(:new).with("text" => "test matériaux")
      post :create, :message => { "text" => "text matériaux" }
    end

    it "saves the Material" do
      material = mock_model(Material)
      Material.stub(:new).and_return(material)
      material.should_receive(:save)
      post :create
    end

    it "redirects to the Material index" do
      post :create
      response.should redirect_to(:action => "index")
    end
  end
end


require 'spec_helper'

describe LinksController do 
  # Crée une variable membre @mock_link ou la reprend si elle existe puis la renvoie APRES 
  # avoir ajouté (ou remplacé) tous les stubs passés en paramètres. Ex :
  # mock_link(:id => 37) 
  # ajoute la fonction id qui renverra 37 à l'objet @mock_link
  # def mock_link(stubs={})
  #   (@mock_link ||= mock_model(Link).as_null_object).tap do |link|
  #     link.stub(stubs) unless stubs.empty?
  #   end
  # end
  
  # NOTE: Il semble important d'adopter une convention de nommage : mock_ pour les objet mock, un nom non préfixé
  # pour les objets issus des factories.
  let :mock_link                do mock_model(Link).as_null_object                    end
  let :current_workspace        do FactoryGirl.build(:workspace)                     end
  let :mock_workspace_member do 
    mock_model(UserWorkspaceMembership, :workspace => current_workspace).as_null_object 
  end
  
  # NOTE: pour screencast : before != begin... et before(:all) ne marche pas pour cela : controller n'est pas 
  # encore défini !
  before(:each) do
    controller.stub(:authenticate_user!       =>  true              ) # .and_return(true)
    controller.stub(:current_workspace_member =>  mock_workspace_member )    
  end


  describe "GET index" do
    before(:each) do 
      @standard_links   = FactoryGirl.create(:standard_link )
      @workspace_links  = FactoryGirl.create(:link , :workspace =>  current_workspace )
    end
    
    
    it "ask for links from std links slibrary and from workspace library" do
      Link.should_receive(:standard)
      Link.should_receive(:from_workspace)
      get :index
    end
    
    it "assigns all links for standard links library as @standard_links" do
      # NOTE: Je n'ai pas réussi à faire un stub sur un objet.
      # Link.stub(:standard_links) { [mock_link] }    
      get :index
      assigns(:standard_links).should eq( [@standard_links] )
    end
    
    it "assigns all links for workspace links library as @standard_links" do
      get :index
      assigns(:workspace_links).should eq( [@workspace_links] )
    end
    
  end

  # describe "GET show" do
  #   it "assigns the requested link as @link" do
  #     Link.stub(:find).with("37") { mock_link }
  #     get :show, :id => "37"
  #     assigns(:link).should be(mock_link)     
  #   end
  # end
  # 
  # describe "GET new" do
  #   it "assigns a new link as @link" do
  #     Link.stub(:new) { mock_link }
  #     get :new
  #     assigns(:link).should be(mock_link)
  #   end
  # end
  # 
  # describe "GET edit" do
  #   it "assigns the requested link as @link" do
  #     Link.stub(:find).with("37") { mock_link }
  #     get :edit, :id => "37"
  #     assigns(:link).should be(mock_link)
  #   end
  # end
  # 
  # describe "POST create" do
  # 
  #   describe "with valid params" do
  #     it "assigns a newly created link as @link" do
  #       Link.stub(:new).with({'these' => 'params'}) { mock_link(:save => true) }
  #       post :create, :link => {'these' => 'params'}
  #       assigns(:link).should be(mock_link)
  #     end
  # 
  #     it "redirects to the created link" do
  #       Link.stub(:new) { mock_link(:save => true) }
  #       post :create, :link => {}
  #       response.should redirect_to(link_url(mock_link))
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "assigns a newly created but unsaved link as @link" do
  #       Link.stub(:new).with({'these' => 'params'}) { mock_link(:save => false) }
  #       post :create, :link => {'these' => 'params'}
  #       assigns(:link).should be(mock_link)
  #     end
  # 
  #     it "re-renders the 'new' template" do
  #       Link.stub(:new) { mock_link(:save => false) }
  #       post :create, :link => {}
  #       response.should render_template("new")
  #     end
  #   end
  # 
  # end
  # 
  # describe "PUT update" do
  # 
  #   describe "with valid params" do
  #     it "updates the requested link" do
  #       Link.should_receive(:find).with("37") { mock_link }
  #       mock_link.should_receive(:update_attributes).with({'these' => 'params'})
  #       put :update, :id => "37", :link => {'these' => 'params'}
  #     end
  # 
  #     it "assigns the requested link as @link" do
  #       Link.stub(:find) { mock_link(:update_attributes => true) }
  #       put :update, :id => "51848956"
  #       assigns(:link).should be(mock_link)
  #     end
  # 
  #     it "redirects to the link" do
  #       Link.stub(:find) { mock_link(:update_attributes => true) }
  #       put :update, :id => "51848956"
  #       response.should redirect_to(link_url(mock_link))
  #     end
  #   end
  # 
  #   describe "with invalid params" do
  #     it "assigns the link as @link" do
  #       Link.stub(:find) { mock_link(:update_attributes => false) }
  #       put :update, :id => "51848956"
  #       assigns(:link).should be(mock_link)
  #     end
  # 
  #     it "re-renders the 'edit' template" do
  #       Link.stub(:find) { mock_link(:update_attributes => false) }
  #       put :update, :id => "51848956"
  #       response.should render_template("edit")
  #     end
  #   end
  # 
  # end
  # 
  # describe "DELETE destroy" do
  #   it "destroys the requested link" do
  #     Link.should_receive(:find).with("37") { mock_link }
  #     mock_link.should_receive(:destroy)
  #     delete :destroy, :id => "37"
  #   end
  # 
  #   it "redirects to the links list" do
  #     Link.stub(:find) { mock_link }
  #     delete :destroy, :id => "51848956"
  #     response.should redirect_to(links_url)
  #   end
  # end

end

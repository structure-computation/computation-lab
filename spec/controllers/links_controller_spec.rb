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
  let :mock_link                do mock_model(Link).as_null_object                  end
  let :current_workspace        do FactoryGirl.build(:workspace)                    end
  let :mock_workspace_member    do 
    mock_model(UserWorkspaceMembership, #:workspace_id => current_workspace.id 
                                        :workspace    => current_workspace ).as_null_object 
  end
  
  # NOTE: pour screencast : before != begin... et before(:all) ne marche pas pour cela : controller n'est pas 
  # encore défini !
  # NOTE: Attention, seul before each est placé dans une transaction pour la BDD. 
  before(:each) do
    controller.stub(:authenticate_user!       =>  true              ) # .and_return(true)
    controller.stub(:current_workspace_member =>  mock_workspace_member )    
    @standard_link   = FactoryGirl.create(:standard_link )
    @workspace_link  = FactoryGirl.create(:link , :workspace =>  current_workspace )
  end


  describe "GET index" do
    it "ask for links from std links slibrary and from workspace library" do
      Link.should_receive(:standard)
      Link.should_receive(:from_workspace)
      get :index
      response.should render_template("links/index")
    end
    
    it "assigns all links for standard links library as @standard_links" do
      # NOTE: Je n'ai pas réussi à faire un stub sur un objet.
      # Link.stub(:standard_links) { [mock_link] }  
      # NOTE: cela utilise la BDD, on peut aussi faire ce choix au final.  
      get :index
      assigns(:standard_links ).should eq( [@standard_link] )
    end
    
    it "assigns all links for workspace links library as @standard_links" do
      get :index
      assigns(:workspace_links).should eq( [@workspace_link] )
    end
  end

  describe "GET show" do
    
    it "assigns the requested link as @link if link is a standard link" do
      get :show, :id => @standard_link.id 
      assigns(:link).should eq(@standard_link)    
      response.should render_template("links/show") 
    end
    
    it "assigns the requested link as @link if link is a a link from current workspace." do
      get :show, :id => @workspace_link.id
      assigns(:link).should eq(@workspace_link)
      response.should render_template("links/show")
    end

    #TODO: Ecrire plutôt "redirect to" une page d'erreur.
    it "send an error if the requested link belongs to an other workspace than current workspace." do
      tmp_workspace   = FactoryGirl.create(:workspace)
      tmp_link        = FactoryGirl.create(:link, :workspace => tmp_workspace)
      get :show, :id => tmp_link.id
      assigns(:link).should be nil
      response.should redirect_to(workspace_links_path(current_workspace))
      flash[:notice].should eq("Ce lien n'existe pas ou n'est pas accessible à partir de cet espace de travail.")
    end    
    
    it "send an error if no link is available with this id." do
      # Construction puis destruction d'un lien pour avoir un id inexistant
      tmp_link        = FactoryGirl.create(:link)
      tmp_id          = tmp_link.id
      tmp_link.destroy
      
      # Get de l'id inexistant.
      get :show, :id => tmp_link.id
      assigns(:link).should be nil
      response.should redirect_to(workspace_links_path(current_workspace))
      flash[:notice].should eq("Ce lien n'existe pas ou n'est pas accessible à partir de cet espace de travail.")
    end
    
  end
  
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

require 'spec_helper'

describe LinksController do 
  def mock_link(stubs={})
    (@mock_link ||= mock_model(Link).as_null_object).tap do |link|
      link.stub(stubs) unless stubs.empty?
    end
  end   
  

  describe "GET index" do  
    before do
      controller.stub!(:authenticated_user!).and_return(:true)    
    end
    
    it "assigns all links as @links" do
      Link.stub(:all) { [mock_link] }    
      Link.stub!(:find).with(:all).and_return([mock_link])
      
      get :index
      assigns(:links).should eq([mock_link])
    end
  end

  describe "GET show" do
    it "assigns the requested link as @link" do
      Link.stub(:find).with("37") { mock_link }
      get :show, :id => "37"
      assigns(:link).should be(mock_link)     
    end
  end
  
  #test de la création d'un objet Link vide et de l'affichage du formulaire de création
  describe "GET new" do
    it "create a new nil Link " do 
      #Link.stub(:new) { mock_link }  
      #get :new
      Link.should_receive(new) 
    end
    it "show a form to create a link" do
      response.should render_template("new")
    end 
  end          

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

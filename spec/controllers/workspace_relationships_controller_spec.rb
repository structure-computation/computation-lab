require 'spec_helper'

describe WorkspaceRelationshipsController do

  def mock_workspace_relationship(stubs={})
    (@mock_workspace_relationship ||= mock_model(WorkspaceRelationship).as_null_object).tap do |workspace_relationship|
      workspace_relationship.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all workspace_relationships as @workspace_relationships" do
      WorkspaceRelationship.stub(:all) { [mock_workspace_relationship] }
      get :index
      assigns(:workspace_relationships).should eq([mock_workspace_relationship])
    end
  end

  describe "GET show" do
    it "assigns the requested workspace_relationship as @workspace_relationship" do
      WorkspaceRelationship.stub(:find).with("37") { mock_workspace_relationship }
      get :show, :id => "37"
      assigns(:workspace_relationship).should be(mock_workspace_relationship)
    end
  end

  describe "GET new" do
    it "assigns a new workspace_relationship as @workspace_relationship" do
      WorkspaceRelationship.stub(:new) { mock_workspace_relationship }
      get :new
      assigns(:workspace_relationship).should be(mock_workspace_relationship)
    end
  end

  describe "GET edit" do
    it "assigns the requested workspace_relationship as @workspace_relationship" do
      WorkspaceRelationship.stub(:find).with("37") { mock_workspace_relationship }
      get :edit, :id => "37"
      assigns(:workspace_relationship).should be(mock_workspace_relationship)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created workspace_relationship as @workspace_relationship" do
        WorkspaceRelationship.stub(:new).with({'these' => 'params'}) { mock_workspace_relationship(:save => true) }
        post :create, :workspace_relationship => {'these' => 'params'}
        assigns(:workspace_relationship).should be(mock_workspace_relationship)
      end

      it "redirects to the created workspace_relationship" do
        WorkspaceRelationship.stub(:new) { mock_workspace_relationship(:save => true) }
        post :create, :workspace_relationship => {}
        response.should redirect_to(workspace_relationship_url(mock_workspace_relationship))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved workspace_relationship as @workspace_relationship" do
        WorkspaceRelationship.stub(:new).with({'these' => 'params'}) { mock_workspace_relationship(:save => false) }
        post :create, :workspace_relationship => {'these' => 'params'}
        assigns(:workspace_relationship).should be(mock_workspace_relationship)
      end

      it "re-renders the 'new' template" do
        WorkspaceRelationship.stub(:new) { mock_workspace_relationship(:save => false) }
        post :create, :workspace_relationship => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested workspace_relationship" do
        WorkspaceRelationship.should_receive(:find).with("37") { mock_workspace_relationship }
        mock_workspace_relationship.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :workspace_relationship => {'these' => 'params'}
      end

      it "assigns the requested workspace_relationship as @workspace_relationship" do
        WorkspaceRelationship.stub(:find) { mock_workspace_relationship(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:workspace_relationship).should be(mock_workspace_relationship)
      end

      it "redirects to the workspace_relationship" do
        WorkspaceRelationship.stub(:find) { mock_workspace_relationship(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(workspace_relationship_url(mock_workspace_relationship))
      end
    end

    describe "with invalid params" do
      it "assigns the workspace_relationship as @workspace_relationship" do
        WorkspaceRelationship.stub(:find) { mock_workspace_relationship(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:workspace_relationship).should be(mock_workspace_relationship)
      end

      it "re-renders the 'edit' template" do
        WorkspaceRelationship.stub(:find) { mock_workspace_relationship(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested workspace_relationship" do
      WorkspaceRelationship.should_receive(:find).with("37") { mock_workspace_relationship }
      mock_workspace_relationship.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the workspace_relationships list" do
      WorkspaceRelationship.stub(:find) { mock_workspace_relationship }
      delete :destroy, :id => "1"
      response.should redirect_to(workspace_relationships_url)
    end
  end

end

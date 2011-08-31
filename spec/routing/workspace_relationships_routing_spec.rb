require "spec_helper"

describe WorkspaceRelationshipsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/workspace_relationships" }.should route_to(:controller => "workspace_relationships", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/workspace_relationships/new" }.should route_to(:controller => "workspace_relationships", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/workspace_relationships/1" }.should route_to(:controller => "workspace_relationships", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/workspace_relationships/1/edit" }.should route_to(:controller => "workspace_relationships", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/workspace_relationships" }.should route_to(:controller => "workspace_relationships", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/workspace_relationships/1" }.should route_to(:controller => "workspace_relationships", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/workspace_relationships/1" }.should route_to(:controller => "workspace_relationships", :action => "destroy", :id => "1")
    end

  end
end





require "spec_helper"
                    





describe CustomersController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/customers" }.should route_to(:controller => "customers", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/customers/new" }.should route_to(:controller => "customers", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/customers/1" }.should route_to(:controller => "customers", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/customers/1/edit" }.should route_to(:controller => "customers", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/customers" }.should route_to(:controller => "customers", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/customers/1" }.should route_to(:controller => "customers", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/customers/1" }.should route_to(:controller => "customers", :action => "destroy", :id => "1")
    end

  end
end



describe MembersController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/members" }.should route_to(:controller => "members", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/members/new" }.should route_to(:controller => "members", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/members/1" }.should route_to(:controller => "members", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/members/1/edit" }.should route_to(:controller => "members", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/members" }.should route_to(:controller => "members", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/members/1" }.should route_to(:controller => "members", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/members/1" }.should route_to(:controller => "members", :action => "destroy", :id => "1")
    end

  end
end



describe WorkspacesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/workspaces" }.should route_to(:controller => "workspaces", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/workspaces/new" }.should route_to(:controller => "workspaces", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/workspaces/1" }.should route_to(:controller => "workspaces", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/workspaces/1/edit" }.should route_to(:controller => "workspaces", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/workspaces" }.should route_to(:controller => "workspaces", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/workspaces/1" }.should route_to(:controller => "workspaces", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/workspaces/1" }.should route_to(:controller => "workspaces", :action => "destroy", :id => "1")
    end

  end
end



describe BillsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/bills" }.should route_to(:controller => "bills", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/bills/new" }.should route_to(:controller => "bills", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/bills/1" }.should route_to(:controller => "bills", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/bills/1/edit" }.should route_to(:controller => "bills", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/bills" }.should route_to(:controller => "bills", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/bills/1" }.should route_to(:controller => "bills", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/bills/1" }.should route_to(:controller => "bills", :action => "destroy", :id => "1")
    end

  end
end



describe MaterialsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/workspaces/materials" }.should route_to(:controller => "materials", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/workspaces/materials/new" }.should route_to(:controller => "materials", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/workspaces/materials/1" }.should route_to(:controller => "materials", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/workspaces/materials/1/edit" }.should route_to(:controller => "materials", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/workspaces/materials" }.should route_to(:controller => "materials", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/workspaces/materials/1" }.should route_to(:controller => "materials", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/workspaces/materials/1" }.should route_to(:controller => "materials", :action => "destroy", :id => "1")
    end

  end
end



describe ScModelsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/workspaces/sc_models" }.should route_to(:controller => "sc_models", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/workspaces/sc_models/new" }.should route_to(:controller => "sc_models", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/workspaces/sc_models/1" }.should route_to(:controller => "sc_models", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/workspaces/sc_models/1/edit" }.should route_to(:controller => "sc_models", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/workspaces/sc_models" }.should route_to(:controller => "sc_models", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/workspaces/sc_models/1" }.should route_to(:controller => "sc_models", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/workspaces/sc_models/1" }.should route_to(:controller => "sc_models", :action => "destroy", :id => "1")
    end

  end
end



describe LinksController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/workspaces/links" }.should route_to(:controller => "links", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/workspaces/links/new" }.should route_to(:controller => "links", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/workspaces/links/1" }.should route_to(:controller => "links", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/workspaces/links/1/edit" }.should route_to(:controller => "links", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/workspaces/links" }.should route_to(:controller => "links", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/workspaces/links/1" }.should route_to(:controller => "links", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/workspaces/links/1" }.should route_to(:controller => "links", :action => "destroy", :id => "1")
    end

  end
end


require 'spec_helper'

describe "WorkspaceRelationships" do
  describe "GET /workspace_relationships" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get workspace_relationships_path
      response.status.should be(200)
    end
  end
end

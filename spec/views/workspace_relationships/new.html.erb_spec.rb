require 'spec_helper'

describe "workspace_relationships/new.html.erb" do
  before(:each) do
    assign(:workspace_relationship, stub_model(WorkspaceRelationship,
      :workspace1_id => 1,
      :workspace2_id => 1
    ).as_new_record)
  end

  it "renders new workspace_relationship form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => workspace_relationships_path, :method => "post" do
      assert_select "input#workspace_relationship_workspace1_id", :name => "workspace_relationship[workspace1_id]"
      assert_select "input#workspace_relationship_workspace2_id", :name => "workspace_relationship[workspace2_id]"
    end
  end
end

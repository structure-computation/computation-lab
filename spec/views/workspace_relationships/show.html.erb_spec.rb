require 'spec_helper'

describe "workspace_relationships/show.html.erb" do
  before(:each) do
    @workspace_relationship = assign(:workspace_relationship, stub_model(WorkspaceRelationship,
      :workspace1_id => 1,
      :workspace2_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end

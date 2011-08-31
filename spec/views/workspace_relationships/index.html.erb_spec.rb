require 'spec_helper'

describe "workspace_relationships/index.html.erb" do
  before(:each) do
    assign(:workspace_relationships, [
      stub_model(WorkspaceRelationship,
        :workspace1_id => 1,
        :workspace2_id => 1
      ),
      stub_model(WorkspaceRelationship,
        :workspace1_id => 1,
        :workspace2_id => 1
      )
    ])
  end

  it "renders a list of workspace_relationships" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end

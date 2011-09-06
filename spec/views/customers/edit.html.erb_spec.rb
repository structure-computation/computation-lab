require 'spec_helper'

describe "customers/edit.html.erb" do
  before(:each) do
    @customer = assign(:customer, stub_model(Customer,
      :name => "MyString",
      :mail => "MyString",
      :phonenumber => 1,
      :workspacename => "MyString"
    ))
  end

  it "renders the edit customer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => customer_path(@customer), :method => "post" do
      assert_select "input#customer_name", :name => "customer[name]"
      assert_select "input#customer_mail", :name => "customer[mail]"
      assert_select "input#customer_phonenumber", :name => "customer[phonenumber]"
      assert_select "input#customer_workspacename", :name => "customer[workspacename]"
    end
  end
end

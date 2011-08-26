require 'spec_helper'

describe "customers/new.html.erb" do
  before(:each) do
    assign(:customer, stub_model(Customer,
      :name => "MyString",
      :mail => "MyString",
      :phonenumber => 1,
      :companyname => "MyString"
    ).as_new_record)
  end

  it "renders new customer form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => customers_path, :method => "post" do
      assert_select "input#customer_name", :name => "customer[name]"
      assert_select "input#customer_mail", :name => "customer[mail]"
      assert_select "input#customer_phonenumber", :name => "customer[phonenumber]"
      assert_select "input#customer_companyname", :name => "customer[companyname]"
    end
  end
end

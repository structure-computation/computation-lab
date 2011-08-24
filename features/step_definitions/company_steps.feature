class Company 
  def companySuccess
  "You've juste created a new company and its manager"   
  end
end

Given /^I am logged in as "([^"]*)" with password "([^"]*)"$/ do |email, password|
  unless email.blank?
    visit new_user_session_path
    fill_in "Email", :with => email
    fill_in "Password", :with => password
  end
end

When /^I create a company$/ do
  @company = CucumberCompany.new
end

And /^I should create a manager for this company$/ do
  @user = User.new 
  @user.role = manager
end

Then /^I should see "([^"]*)"$/ do |com|
  @companySuccess.should == com
end
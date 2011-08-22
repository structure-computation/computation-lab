#---
# Excerpted from "The RSpec Book",
# published by The Pragmatic Bookshelf.
# Copyrights apply to this code. It may not be used to create training material, 
# courses, books, articles, and the like. Contact us if you are in doubt.
# We make no guarantees that this code is fit for any purpose. 
# Visit http://www.pragmaticprogrammer.com/titles/achbd for more book information.
#--- 

class Company 
  def companySuccess
  "You just created a new Company !"
  end
end

Given /^I create a company$/ do
  @company = CucumberCompany.new
end

When /^I should create a User for this company$/ do
  @user = User.new 
  @user.role = manager
end

Then /^I should see "([^"]*)"$/ do |companyy|
  @companySuccess.should == companyy
end

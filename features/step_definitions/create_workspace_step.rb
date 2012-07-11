Given /^I am logged in as an AdminSC$/ do
  UserScAdmin.first 
end    

Given /^I am logged in as an manager$/ do 
  User.find_by_role('manager').first
end

When /^I create a Workspace with name "([^\"]*)"$/ do |name|
  w = Workspace.create :name => name  
  w.save!
end     

When /^I sign up with "([^\"]*)"$/ do |first_name|  
  user = User.create(:firstname => first_name)
  user.role = 'manager'
  user.save!
end

And /^I create a User with firstname "([^\"]*)"$/ do |first_name|
  user = User.create(:firstname => first_name)
  user.role = 'manager'
  user.save!
end

And /^I see a User with firstname "([^\"]*)"$/ do |first_name|  
  User.find_by_firstname(first_name)
end

And /^ I associate user "([^\"]*)" to workspace "([^\"]*)" $/ do |user, workspace|  
   assos = UserCompanyMembership.create :user => user, :workspace => workspace 
   assos.save!                               
end

Then /^ I should see manager with first_name "([^\"]*)"$/ do |first_name| 
  User.find_by_firstname(first_name).exists?            
end         

And /^ I should see workspace with name "([^\"]*)"$/ do |name| 
   !Workspace.find_by_name(name).nil?
end      


Given /^I am logged in as an AdminSC$/ do
  UserScAdmin.first 
end    

Given /^I am logged in as an manager$/ do 
  User.find_by_role('manager').first
end

When /^I create a Workspace with name "([^\"]*)" with kind (company|project|fillial) "([^\"]*)"$/ do |name, action|
  @w = Workspace.create(:name => name)  
  case action
    when "company"
      Workspace.kind = "company"
    when "project"
      Workspace.kind = "project"  
    when "fillial"
      Workspace.kind = "fillial" 
  end  
  @w.save!
end  

And /^I create a User with firstname "([^\"]*)"$/ do |first_name|
  @user = User.create(:firstname => first_name)
  @user.role = 'manager'
  @user.save!
end

And /^I see a User with firstname "([^\"]*)"$/ do |first_name|  
  User.find_by_firstname(first_name)
end

And /^ I associate user "([^\"]*)" to workspace "([^\"]*)" $/ do |user, workspace|  
   @association = UserCompanyMembership.create :user => user, :workspace => workspace
   @association.save!
end

Then /^ I should see this manager with first_name "([^\"]*)"$/ do |first_name| 
  score = User.find_by_firstname(first_name).exists?            
  #!User.find_by_firstname( :firstname => firstname ).nil?
end         

And /^ I should see this workspace with name "([^\"]*)"$/ do |name| 
   score = !Workspace.find_by_name(name).nil?
end                         

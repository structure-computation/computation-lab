Given /^I am logged in as an AdminSC$/ do 
end   

When /^I create a Workspace with name "([^\"]*)"$/ do |name|
  w = Workspace.new :name => name
  w.save
end

And /^I see a User with firstname "([^\"]*)"$/ do |firstname|
  User.find_user_with_name(firstname)
end
      
And /^I create a User with firstname "([^\"]*)"$/ do |first_name|
  user = User.new :firstname => first_name
  user.role = manager
end                         

And /^ I associate user to workspace$/ do  
   UserCompanyMembership.create :user => user, :workspace => workspace, :status => "en cours"
end

Then /^ I should see this manager with firstname "([^\"]*)"$/ do |firstname| 
  User.find_user_with_firstname(firstname)  
end

And  /^ I should see this workspace with name "([^\"]*)"$/ do |name| 
   Workspace.find_workspace_with_name(name)
end        

class ScModels 
  def scmodelsSuccess
  "You are the owner of the new scmodels !"   
  end
end

Given /^I am logged in as "([^"]*)" with password "([^"]*)"$/ do |name, password|
  unless name.blank?
    visit new_user_session_path
    fill_in "name", :with => name
    fill_in "Password", :with => password
  end
end

When /^I create a new scmodel$/ do 
  @scmodel= ScModels.new    
  @scmodel. ScModels.successfull
end                                                        

An /^I press the button "ok" $/ do  
  @message = ScModels.scmodel
end

Then /^I should see "([^"]*)"$/ do |scmodels|
  @message.should == scmodels
end         
              

Feature: Manage ScModels 
  In order to manage scmodels            
  As an owner
  I want to restrict right on the scmodels
  
	Scenario: Create scModel as an ownerScModels
	 Given that I am logged in as "Engineer" with password "changeme"
	 When I create a new scmodel     
	 Then I should see "You are the owner of the new scmodels !"     




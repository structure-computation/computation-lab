Feature:Create a company
  In order to create a company that at least has one user
  As an admin
  I want to create an user when I create a company 

	Scenario: Create a Company when you logged in as an admin
	  Given I am logged in as "Admin" with email "j.bellec@structure-computation.com"  
	  When I create a company
	  And I should create a manager for this company 
	  Then I should see "You've juste created a new company and its manager"        
	

	                       
	

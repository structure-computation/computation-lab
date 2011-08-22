Feature:Create a company
  In order to create a company that at least has one user
  As an admin
  I want to create an user when I create a company 

	Scenario: Create a Company when you logged in as an admin with no user assigned
	  Given I am logged in as an admin
	  When I create a Company
	  Then I should create a User for this company 
	  And this User has the role of Manager
	  And I should see this company

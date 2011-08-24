#Histoire principale
Feature: Manage Rights on Application
  In order to create a staff in a company with roles
  As AdminSC
  I want to create an user and assign to it a role     

#Créer une Company par un administrateur de Structure Computation si un User existe 
Scenario: Create a company by an AdminSC
  Background: the following activated users exists
    | name         | email                    | role    |
    | Alice Hunter | alice.hunter@example.com | AdminSC |
    | Bob Hunter   | bob.hunter@example.com   | Manager | 
  Given I am logged in as "Alice Hunter"
	When I create a company named "StarCompany" 
	And I associate this company to "Bob Hunter"
	Then I should find "StarCompany" in companies list  
	And I should find "Bob Hunter" in StarCompanyMembership
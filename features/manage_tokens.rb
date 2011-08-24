Feature:    
  In order to prevent engeneers viewing my scModel
  As a Manager
  I want to manage my account
  
#C'est le manager qui redistribue les jetons restant quand un project est fini
Scenario: A project is finished, but Tokens are left
  Given I am logged in as an Manager
  And There is Account.Company1, Account.Company2, Account.Company3
  When I give the Tokens left to Account.Company1
  Then I should see  Account.Company+LeftTokens
      
Scenario: Upgrade Abonnements
	Given I am logged in as an Manager   
	And
	When I go to the Abonnements page
	And I 
	Then I should see	
	
Scenario: Upgrade credits
	Background: I am logged as an Manager
	Given                                  
	
Scenario: Access to Bills List
  Background: I am logged in as an Manager
  And specific company
  Given I have bills named as bill0001
  Then I should find "bill0001" in bills list
  
Scenario: Acces to Bills List
  Background: I am logged in as an Engeneer
  And a specific company
  Given I
  Then I should find "You're not allowed to see this page"


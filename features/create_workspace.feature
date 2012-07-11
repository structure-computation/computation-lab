Feature: Create a workspace
  In order to create a staff and seperate ressources
  As an SCadmin 
  I want to create workshops with one assigned kind companies, filliales and projects                        
         
  #Créer un new Workspace et définir son genre Company, Fillial, Project et un new User par un AdminSC                       
  Scenario: Create a Workspace by an AdminSC 
    Given I am logged in as an AdminSC   
    And   I associate user "Jérémy" to workspace "Structure Computation"
    And   I associate user "Jérémy" to workspace "Structure Computation" 
    And   I create a User with firstname "Jérémy"
    Then  I should see this manager with firstname "Jérémy"  
    And   I should see this workspace with name "Structure Computation"      
  
  #Créer un new Workspace par un AdminSC et l'associer à un User existant
  Scenario: Create a Workspace by an User
    Given I am logged in as an AdminSC             
    And   I see a User with firstname "Jérémy"
    When  I create a Workspace with name "Structure Computation"   
    And   I associate user "Jérémy" to workspace "Structure Computation"
    Then  I should see manager with firstname "Jérémy"  
    And   I should see workspace with name "Structure Computation"    
    
  #Un user veut créer un nouveau Workspace (à partir de l'application web)
  Scenario: a User want to create a new Workspace
   Given I am logged in as an manager
   When  I create a Workspace with name "Structure Computation"
   And   I associate user "Jérémy" to workspace "Structure Computation"
   Then  I should see this manager with firstname "Jérémy"  
   And   I should see this workspace with name "Structure Computation"    

  #Un nouvel utilisateur se connecte et créer un compte    , il reçoit un mail pr valider la création
  Scenario: a new User want to sign up and create a workspace 
    Given I am on the homepage
    When I sign up with "My Name"
    And I create a Workspace with name "MyCompany"
    Then I should be signed in
    And I should see this workspace with name "MyCompany"        
     
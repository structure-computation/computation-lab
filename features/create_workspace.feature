Feature: Create a workspace
  In order to create a staff and seperate ressources
  As an SCadmin 
  I want to create workshops with one assigned kind companies, filliales and projects                        
         
  #Créer un new Workspace et un new User par un AdminSC                       
  Scenario: Create a Workspace by an AdminSC 
    Given I am logged in as an AdminSC   
    And   I see a User with firstname "Jérémy"
    When  I create a Workspace with name "Structure Computation"  
    And   I associate user to workspace
    And   I create a User with firstname "Jérémy"
    Then  I should see this manager with firstname "Jérémy"  
    And   I should see this workspace with name "Structure Computation"    
  
  #Créer un new Workspace par un AdminSC et l'associer à un User existant
  Scenario: Create a Workspace by an User
    Given I am logged in as an AdminSC
    When  I create a Workspace with name #{workspace}  
    And   I associate user to workspace
    Then  I should see this workspace with name 
    And   I should see this manager with firstname "Jérémy"  
    
                                                              


     

                                                                                                                                                                                                                 

  



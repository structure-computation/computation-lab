#Attention, pensez au cas où si on delete un user qui possède des droits, il ne faut pas perdre accès à certaines ressources                                                       
#Attention, au cas où le Manager essaye de se supprimer => forbidden
#tables: user, company, memberCompany (spécifie les droits, pas de rôles)
###########################################                                                    
Background:
    Given that the role "Admin" exists
    And that the role "User" exists   
    
#Step definition
 When /^the role "Admin" exist $/ do |admin|
   user = User.new
   user.role = admin
 end  
    
#Step definition
When /^the role "Manager" exist $/ do |admin|
  user = User.new
  user.role = manager
end 
  
#Step definition
When /^the role "Engineer" exist $/ do |admin|
  user = User.new
  user.role = engineer
end           

#Step definition
 When /^the role "Accoutent" exist $/ do |admin|
   user = User.new
   user.role = accountent
 end


Feature: A Manager can add others Companies to a Project
 In order to compose a team project 
 As a Manager
 I want to add engineer to the team
 
#Ajout d'un ingénieur dans un projet existant
Scenario: Adding a new EngineerA to a existing project   
 Given I am logged in as a Manager
 And there is Project named projectAugust 
 When I add EngineerA to projectAugust.team
 And I go to projectAugust team
 Then I should see EngineerA
 And I should delete EngineerA  
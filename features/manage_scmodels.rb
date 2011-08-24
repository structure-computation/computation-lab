Feature: User Manegement
  In order to manage Engineers
  As an Manager 
  I want to see a engineers list and change engineers rights
                                                                                                                                                                                                                 
Background:
Given the following activated users exists
id | name          | email                              | 
 1 | Jérémy Bellec | j.bellec@structure-computation.com |
 2 | Alice Bob     | alicebob@starcompany.com           |
And the following user records
 id | company           | manager(name_id)        | 
  1 | star company Doe | jonh.doe@example.com     |        

#Partie Laboratoire  
Scenario: Add an engineer to a project
	Given I am logged in as a Manager
	When I add an Engineer to project named "Bob"
	Then I should find "Bob" in the project team   

#un engineer travaille sur son model, on spécifie le droit model par model
#il peut distribuer des droits avec d'autres engineers
#un model appartient a un workspace	    
#(quand un project)

	
#Gestion : Partie Labo  
Scenario: scModels List
  Given I am logged in as an Engeneer
  When I go to the articles page
  Then I should see my 
  And I should see "simpleEngeneer"   
  
Scenario: Create scModel as an ownerScModels
  Given that I have created a scModels
  When I go to the list of articles
  Then I should see my scModels 
  And I should destroy my scModels     
  
Scenario: Share scModels
  Background: I am logged in as a scModelOwner 
  Given I have a scModel named "Roue"
  When I go to the scModels list      
  Then I should see "Roue"  
  And I should share               

#test method share
 When /^I should share $/ do
 
   
 end
 
  
Scenario: Edit one of my scModels     
                                 
Scenario: Archive a scModels when you are the scModelOwner  
  Background: I am logged in as a scModelOwner
  Given I have scModels statused In progress
  When I archive a scModels
  Then this scModel should not appear in the scModels list   
  And this scModel status should be "Archived"
  
#Pending Step Definition   
  Given /^I have scModels statused (.+)$/ do |scModels|
    scModels.split(' ').each do |status|
      ScModels.update!(:status => status)
    end
  end
 
#Un Engineer lance un calcul
Scenario: Allow to consumn tokens  
  Given I am logged as a Engineer 
  And I am the owner of the ScModel
  And I am allowed to consumn tokens
  When I start a calcul   
  Then tokenSold should be < tokenSold-n1

#You can not delete a ScModel 
Scenario: Someone try to destroy a ScModel or a User
  Given I am logged in as an Anyone
  When I click on destroy a ScModel
  It should pass the ScModel Status in "Archived"
  And It should not appear in the ScModels.inprogress list      
#Cucumber : Gestion des droits - Les scénarios  
describe Workspace do 
  it "should have a type" do
    Workspace.new.colors.should include('black')
  end
  it "should be white" do 
    Workspace.new.type.should include('white')
  end
  it "should be read all over"
end
        should_not include('')



Feature: Creata a company
  In order to separate ressources
  As an SCadmin                         
  
  Scenario: I visit the website
   Given I am logged in "jerem" with r            

Then /^I should get a response with status (\d+)$/ do |status|
 page.driver.status_code.should == status.to_i
end           

################################
Background: Login User
  Given the following user records
    | email          | password |
    | test@email.com | password |
  Given I am logged in as "test@email.com" with password "password"

Scenario: Edit existing note
  #Given I have already created a note that belongs to current_user
  Given I have already created a note that is owned by the user with email "test@email.com"
 
Given /^the following (.+) records?$/ do |factory, table|
  table.hashes.each do |hash|
    Factory(factory, hash)
  end
end

Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |email, password|
  unless email.blank?
    visit new_user_session_path
    fill_in "Email", :with => email
    fill_in "Password", :with => password
    click_button "Sign In"
  end
end  

Given /^I have already created a (.+) that belongs to (.+)$/ do |factory, resource|
  model = Factory(factory)
  resource.send(model.class.to_s.downcase.pluralize) << model
end


Scenario outline: Evaluating for current straights
  Given I am a logged in with <role>
  When the board is <board>
  Then the current right straights should be <rights>

  Examples:                                              
    | user         | role       | owmner     |    rights_sc_models          |   rights_manager_user        |    rights_account             | 
    | current_user | admin      | undefined  | create, update, read, delete | create, update, read, delete |  create, update, read, delete | 
    | current_user | manager    | manager    |                              | create, update, read, delete |  create, update, read, delete |  
    | current_user | accountant | accountant |                              |                              |  create, update, read, delete | 
    | current_user | engineer   | engineer   | create, update, read, delete |                              |                               | 

#Lancement d'un calcul par un Engineer
Scenario: An Engineer want to start a calcul
  Given I am logged in as en Engineer
  And I have ScModel
  
  
#spec
require 'spec_helper'

describe "CreateCompany" do
  it "create a new company when i'm logged in as an AdminSC" do
  company = Factory(:user)
  visit new_company_path
  fill_in "Name", :with=> company.name
  fill_in "Phone", :with => company.phonr
  click_button "Reset Password"
  current_path
  end
end             
  
  
  describe Company do
    it { should validate_presence_of :name }
    it { should have_one :address, :phone }
    it { should has_many :manager }
  end                            
  
  describe User do
    it { should validate_presence_of :name, :email }
    it { should have_one :role}
  end                                        
  
  describe ScModels do
    it { should validate_presence_of :owner }
    it { should have_one :forum }
  end
  




describe "Control Archive" do
  it "should not appear in scModel when status is archive" do
    scmodel = scModel.new(:name => "roue)"
    scmodel = 
    scmodel.status == inprogress
  end
end



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
	
#Créer une Company par un AdminSC et pas de User existant
Scenario: Create a Company by an AdminSC 
  Given I am logged in as an AdminSC
  When I create a Company
  Then I should create a User  for this company 
  And this User has the role of Manager
  And I should see this company
  
# Créer une Company par un utilisateur existant
Scenario: Create a Company by an User
   Given I am logged in as a Manager or as a Engineer 
   When I create a Company named "StarCompany" 
   Then I should see "StarCompany" in my Companies list  
   And CurrentUser should be a member of StarCompany 
   
#Création d'un Project par un Manager
Scenario: Create a Project between Companies
  Given I am logged in as a Manager
  When I create a Project
  And I specify the MainCompany
  Then I should see the Project
  And the MainCompany
  
#Création d'une Filliale par un Manager/SC_Admin
Scenario: Create a Fillial between Companies
  Given I am logged in as a Manager
  When I create a Fillial
  And I specify the MainCompany
  Then I should see "You assigned #{@maincompany}"
  
  #Step definitions
  class Fillial 
    def fillialSuccess
    "You've juste created a new company and its manager"   
    end
  end
  When /^I create a Fillial$/ do 
    @fillial = Workspace.new
    @fillial.type = fillial
  end
  And /^I specify who is the MainCompany$/
    @maincompany = Company.first
    @maincompany.main = true 
  end   
  Then /^I should see "([^"]*)"$/ do |i|
    @fillialCompany.should == i
  end    
  
# Créer une Fillial par un utilisateur existant
Scenario: Create a Fillial by an User
  Given I am logged in as a Manager or as a Engineer 
  When I create a Workspace named "FillialA" 
  And I specified "StarCompany" as a MainCompany
  Then I should see "FillialA" in my Fillials list
  And  I should see "StarCompany" in MainCompany of "FillialA"    
   
# Créer un Project par un utilisateur existant
Scenario: Create a Project by an User
   Given I am logged in as a Manager or as a Engineer 
   When I create a Workspace named "WorkspaceStarCompany" 
   And I specified "WorkspaceStarCompany" as a MainCompany
   Then I should see "WorkspaceStarCompany" in my Companies list
   And  I should see "WorkspaceStarCompany" in MainCompany list         
  
# Créer une Company via le site 
Scenario: Create a Company through the website
  Given I am a new user
  And I am on the subscription page
  When I register a new Company account
  And I register a new User account    
  Then I should receive a confirmation email
  
Scenario: Create a Company through the website
  Given I am a new user
  And I am on the subscription page
  When I fill the email "manager@starcompany.com"
  And I fill the Company name "StarCompany"    
  And I fill the phone number  "0164408989"
  Then I should receive a confirmation email
  And I should log in
  And I should see "manager@starcompany.com" and "StarCompany" and "0164408989" on my homepage
  
 
Scenario: Manager

Feature: A Manager can add others Companies to a Project
 In order to  
 As a Manager
 I want    
 
 #Création d'une filliale (plusieurs Companies font parties d'un même Projet)
 "validation de faire partie d'un groupe projet" 
 ou "rejoindre un groupe project et faire valider par le Manager de la CompanyMother" 
  
#Attention, pensez au cas où si on delete un user qui possède des droits, il ne faut pas perdre accès à certaines ressources                                                       
#Attention, au cas où le Manager essaye de se supprimer => forbidden
tables: user, company, memberCompany (spécifie les droits, pas de rôles) 
#workspace (company, user) , un compte, un ensemble de modeles, un jeu de droit                                                      

Scenario: A Manager delete himself
  Given I am logged as a Manager
  When I delete my account
  Then I can't delete my account'
                                                        
Scenario: Create a company through the website  
  Given I have nothing
  When  I fill all the fields from the registration page                    
  Then  I can access to a trial

 When I create a Company
 And I create a Company's Manager '  
 
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
  
#You can not delete an User
Scenario: Someone try to destroy an User
  Given I am logged in as an Anyone
  When I click on destroy a User
  It should pass the User Status in "Inactiv"
  And It should not appear in the User.inactivity list 
 
#Est ce que dans une filliale il y a une Company principale ?
#qui a plus de droit qu'une autre ?'

Feature: Create a Fillial  
  In order to create a Fillial
  As an admin(SC)
  I want to create a Fillial
  
Feature: Create a workspaceCompany 
  In order to create a Company
  As an admin(SC)
  I want to create a company
  
  Scenario:
    Given I have created a Company
    When I create workspaceProject named "Alpha"
    Then I go to workspaceProject list of the Company
    And I should see "Alpha"
  
 
#Qui crée le workspace?
Feature: Create a workspaceProject   
  In order to create a Project
  As an Manager
  I want to constitute a team project with Engineers
  
 

Feature: User Manegement
  In order to manage Engineers
  As an Manager 
  I want to see a engineers list and change engineers rights
                                                                                                                                                                                                                 
Background:
Given the following activated users exists
  | name          | email                              | 
  | Jérémy Bellec | j.bellec@structure-computation.com |
  | Bob Hunter    | bob.hunter@example.com             |
And the following user records
  | name     | email                    | 
  | Jonh Doe | jonh.doe@example.com     |

    Scenario: I delete a user from the table
      Given I am logged in as admin
      When I follow "Administration"
      And I follow "User Management"
      And I delete "Alice Hunter"
      Then I should not see "Alice Hunter"  
      
      And /I delete "(.*)"/ do |person|
        # Use webrat or capybara to find row based on 'person' text... then find 'delete' link in row and click it
        # example (untested, pseudo code)
        within(:xpath, "//table/tr[contains(#{person})") do
          find('.deleteLink').click
        end
      end
      
#Partie Laboratoire  
Scenario: Add an engineer to a project
	Given I am logged in as a Manager
	When I add an Engineer to project named "Bob"
	Then I should find "Bob" in the project team   

#un engineer travaille sur son model, on spécifie le droit model par model
#il peut distribuer des droits avec d'autres engineers
#un model appartient a un workspace	    
#(quand un project)
Scenario: Create a scModel
	Background: I am logged in as an Engeneer 
	Given I am part of the workspace
	When I create a scModel
	Then I should had the role scModelOwner
	And I should share my scModel to other engineers'workspace'
	And I should archive my scModel
	

#Partie Finance                    

#C'est le manager qui redistribue les jetons restant quand un project est fini
Scenario: A project is finished, but LeftTokens
  Given I am logged in as an Manager
  And There is Account.Company1, Account.Company2, Account.
  Company3
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
  Then I should find "You're not allowed"
  
 Feature: 
  As an scModelOwner
  I want to restrict access to my scModels
  In order to prevent engeneers viewing my scModel

Scenario: Logging in
Given I am not logged in as an administrator
When I go to the administrative page
And I fill in the fields
  | Username | admin  |
  | Password | secret |
And I press "Log in"
Then I should be on the administrative page
And I should see "Log out"

Feature: Manage user in right system
 In order to


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
  And I should share my scModels   
  And I should destroy my scModels     
  
Scenario: Share scModels
  Background: I am logged in as a scModelOwner 
  Given I have a scModel named "Roue"
  When I go to the scModels list      
  Then I should see "Roue"  
  And I should share
  
  
Scenario: Edit a scModels   
  Given I have a scModels where owner is me
  When I click on "delete"
  
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

#Gestion : Partie Finance
Scenario: Upgrade Credits
  Given that I am a Manager
  Then I could see Finance part
  And I could add Credits
  And 
  
Scenario: Create a company
  Given that I am logged in
  When I create a Company named MyCompany
  Then I should see that a company named MyCompany exists   
  
  
#Gestion d'un sous partie company: filliale ou projet
Feature: Management of a fillial or a company
  In order to manage the finance part: my account, distribute tokens between Companies
  As an manager or an accountent
  I want to distribute tokens between account in a project or a fillial
  
#Un comptable d'une compagnie A donne n jetons au compte de CompanyB 
 Scenario: CompanyA give tokens to CompanyB
  Given I am logged in as ManagerA
  And My account has 10 tokens
  And AccountB has 5 tokens
  When I give 5 tokens to AccountB
  Then AccountB should be at 10 tokens
  And CompanyB should recevie an email "You receveid 5 tokens from CompanyA"     
  
Given %{I send "$amountToken" to "$accountCompanyB" from my "$accountCompanyA"} do |amount, accountCompanyB, accountCompanyA|
  Given %{I follow "Give tokens"}
  When %{I fill in "accountCompanyB" with "#{accountCompanyB}"}
  And %{I fill in "amountToken" with "#{amountToken.delete('$')}"}
  And %{I select "#{accountCompanyA}" from "accountCompanyA"}
  And %{I press "Give"}
  Then %{I should see "You've sent $#{amountToken} to #{accountCompanyB}"}
end 

#Un comptable achète x jetons  
Scenario: Manager.StarCompany buy 10 tokens for Account.StarCompany
  Given I am logged in as Manager.StarCompany
  And Account.StarCompany equal 0 tokens
  When Manager.StarCompany buy 10 tokens
  And give it to Account.StarCompany
  Then Account.StarCompany should equal 10 tokens
  
#Un comptable 
Scenario: 
  Given I am logged in as Accountent.StarCompany  
  And Accountent.StarCompany has 20 tokens 
  When I give 10 tokens
  Then Accountent should have 10 tokens
  And Accountent.StarCompany should have 10 tokens 
   
#Gestion des ajouts des différents utilisateurs

#Ajout d'un ingénieur dans un projet existant
Scenario: Adding a new EngineerA to a existing project   
  Given I am logged in as a Manager
  And there is Project named projectAugust 
  When I add EngineerA to projectAugust.team
  And I go to projectAugust team
  Then I should see EngineerA
  And I should delete EngineerA 
  
Scenario outline: Adding a new user

Scenario Outline: Add invalid object displays inline errors
  Given I am logged in 
  When I am on the "<Object> list"
  And I press "Delete"
  And <Object> should be in <Archive> "<Status>" for "<Object>"
    
  Examples:                 
    | Object  | Status       | Archive   |
    | User    |  Activ       | InActiv   |
    | ScModel |  InProgress  | Archived |   
                      
  
Feature: Add Tokens to an account
  As an Accountent I can add a new tokens

  Scenario Outline: Add tokens
    Given I am logged in
    When I create an <content type>
    Then I should see 10 tokens
    
    Then /^(?:|I )should see "([^"]*)"$/ do |toys|
      page.should have_content(toys)
    end
    
 
#Example code with cucumber/factory-girl  
  Given"I am logged in"  do
    user = Factory(:user)  #Factory Girl
    visits new_session path
    fills_in 'Login', :with => user.login 
    fills_in 'Password', :with => user.password
    click_button 'Login'   
 end    

 Factory.sequence(:email){|n| user#{n}@example.com; } 
 Factory.define :user do |user| 
   user.name 'User' 
   user.email { Factory.next(:email) } 
   user.login {|u| u.email } 
   user.password 'password' 
   user.password_confirmation 'password' 
 end                    
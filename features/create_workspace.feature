Feature: Creata a company
  In order to separate ressources
  As an SCadmin                         
  
  Scenario: I visit the website
   Given I am logged in "jerem" with r            


################################
Background: Login User
  Given the following user records
    | email          | password |
    | test@email.com | password |
  Given I am logged in as "test@email.com" with password "password"

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

Background:
    Given that the role "Admin" exists
    And that the role "User" exists   
    
Scenario outline: Evaluating for current straights
  Given I am a logged in with <role>
  When the board is <board>
  Then the current right straights should be <rights>

  Examples:                                              
    | user         | role       | owner      |    rights_sc_models          |   rights_manager_user        |    rights_account             | 
    | current_user | admin      | undefined  | create, update, read, delete | create, update, read, delete |  create, update, read, delete | 
    | current_user | manager    | manager    |                              | create, update, read, delete |  create, update, read, delete |  
    | current_user | accountant | accountant |                              |                              |  create, update, read, delete | 
    | current_user | engineer   | engineer   | create, update, read, delete |                              |                               | 


  
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
  
  require 'spec_helper'

describe Engineer do
  set(:engineer) do
    Engineer.create!
  end

  it "should be add on_project" do
    engineer.should add_on_project
  end

  it "should create a ScModel" do
    engineer.create_scmodel
    engineer.should create_scmodel
  end

  it "should share his scmodel" do
    engineer.share
    engineer.should share_scmodel
  end
end     

describe "Control Archive" do
  it "should not appear in scModel when status is archive" do
    scmodel = scModel.new(:name => "roue)"
    scmodel = 
    scmodel.status == inprogress
  end
end

#Main goal
Feature: Create workspace 
  In order to create a staff in a company with roles
  As AdminSC
  I want to create workspace with related assign

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
   
#Création d'un Project par un utilisateur
Scenario: Create a Project between Companies
  Given I am logged in as a Manager
  When I create a Project
  And I specify the MainCompany
  Then I should see the Project
  And the MainCompany
  
#Création d'une Filliale par un utilisateur
Scenario: Create a Fillial between Companies
  Given I am logged in as a Manager
  When I create a Fillial
  And I specify the MainCompany
  Then I should see "You assigned #{maincompany}"
  
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
  


 
 #Création d'une filliale (plusieurs Companies font parties d'un même Projet)
 "validation de faire partie d'un groupe projet" 
 ou "rejoindre un groupe project et faire valider par le Manager de la CompanyMother" 
  

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

#Partie Finance                    

#C'est le manager qui redistribue les jetons restant quand un project est fini
Scenario: A project is finished, but LeftTokens
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
  
Scenario: Access to Bills List
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
  
  
#Gestion d'un sous partie company: filliale ou projet
Feature: Management of a fillial or a Project 
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
FactoryGirl.define do
  sequence :member_name do |n|
    "member_#{n}"
  end

  factory :member, :class => UserWorkspaceMembership do 
    #name {FactoryGirl.generate(:member_name)}
    factory :engineer_member do
      engineer 1
    end 
    factory :manager_member do
      manager 1
    end  
    factory :not_engineer_member do
      engineer 0
    end
    factory :not_manager_member do
      manager 0
    end        
    
    # Ces membres sont des utilisateurs avec un mail et un mdp (fixé par défaut dans la factory user) destiné à être utilisés pour les tests de
    # login
    factory :test_manager do
      engineer 0
      manager  1
      association :user, :factory => :test_user, :email => 'manager@test.com'
    end
    
    factory :test_engineer do
      engineer 1
      manager  0
      association :user, :factory => :test_user, :email => 'engineer@test.com'
    end
    
    factory :test_manager_engineer do
      engineer 1
      manager  1
      association :user, :factory => :test_user, :email => 'manager_engineer@test.com'
    end
    
              
  end
  
end
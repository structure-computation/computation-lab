FactoryGirl.define do
  sequence :user_name do |n|
    "name_#{n}"
  end

  factory :user, :class => UserWorkspaceMembership do 
    name {FactoryGirl.generate(:user_name)}
     
    factory :engineer_member do
      engineer 1
    end 
    
    factory :manager_member do
      manager 1
    end                    
    
  end
  
end
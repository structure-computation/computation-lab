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
  end
  
end
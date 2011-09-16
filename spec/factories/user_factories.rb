FactoryGirl.define do
  sequence :user_name do |n|
    "user_#{n}"
  end

  factory :user, :class => User do 
    name {FactoryGirl.generate(:user_name)}
  end
  
end                   
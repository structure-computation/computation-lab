FactoryGirl.define do
  sequence :user_name do |n|
    "user_#{n}"
  end

  factory :user, :class => User do 
    firstname {FactoryGirl.generate(:user_name)}
    lastname  "test"
    
    factory :test_user, :class => User do 
      password              "password"
      password_confirmation "password"
    end
    
  end
  
end                   
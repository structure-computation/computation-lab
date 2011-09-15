FactoryGirl.define do
  sequence :bill_name do |n|
    "bill_#{n}"
  end

  factory :bill, :class => Bill do 
    name "demo bill" #{bill_name}    

  end
  
end
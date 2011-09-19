FactoryGirl.define do
  sequence :bill_id do |n|
    "bill_#{id}"
  end

  factory :bill, :class => Bill do 
    id "demo bill" 
    
  end
  
end
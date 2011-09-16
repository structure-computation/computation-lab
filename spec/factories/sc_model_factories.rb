FactoryGirl.define do
  sequence :sc_model_name do |n|
    "sc_model_#{n}"
  end

  factory :sc_model, :class => ScModel do 
    name "demo scmodel" #{link_name}    

  end
  
end

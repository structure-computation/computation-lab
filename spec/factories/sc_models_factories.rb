FactoryGirl.define do
  sequence :sc_model_name do |n|
    "link_#{n}"
  end

  factory :sc_models, :class => ScModels do 
    name "demo scmodels" #{link_name}
    
  end
  
end

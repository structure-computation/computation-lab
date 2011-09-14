FactoryGirl.define do
  sequence :material_name do |n|
    "material_#{n}"
  end
  
  factory :material, :class => Link do 
    name "demo material" #{material_name}
    
    factory :standard_material do
      workspace_id -1
    end
    
  end
  
end
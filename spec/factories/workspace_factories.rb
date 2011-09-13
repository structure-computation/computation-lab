FactoryGirl.define do
  sequence :workspace_name do |n|
    "workspace_#{n}"
  end
  
  factory :workspace, :class => Workspace do 
    name {FactoryGirl.generate(:workspace_name)}
  end
  
end

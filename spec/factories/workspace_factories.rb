FactoryGirl.define do
  sequence :workspace_name do |n|
    "workspace_#{n}"
  end
  
  #TODO: fixer un kind par défaut ?
  
  factory :workspace, :class => Workspace do 
    name {FactoryGirl.generate(:workspace_name)}
    
    # Un workspace complet "minimum" avec un admin et 2 ingénieurs.
    factory :complete_workspace, :class => Workspace do 
      user_workspace_memberships { 
                                    members =   []
                                    members <<  Factory.build(:test_manager )
                                    members <<  Factory.build(:test_engineer)
                                    members
                                  }
    end
    
  end
  
  
  
end

class ScModel < ActiveRecord::Base
  
  belongs_to  :user
  belongs_to  :project
  
  has_many    :calcul_results
  
  
  
end

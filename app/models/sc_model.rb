class ScModel < ActiveRecord::Base
  
  belongs_to  :user
  belongs_to  :project
  
  has_many    :calcul_results
  
  def has_result? 
    return (rand(1) > 0.5)
  end
  
end

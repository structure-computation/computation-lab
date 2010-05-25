class CalculResult < ActiveRecord::Base
  
  belongs_to  :user         # utilisateur ayant lance le calcul
  belongs_to  :sc_model
  has_one    :log_calculs
end

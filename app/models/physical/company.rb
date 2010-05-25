class Company < ActiveRecord::Base
  has_many  :users
  
  has_one   :calcul_account
  has_one   :memory_account
  
  has_many  :projects
  has_many  :sc_models
  has_many  :log_calculs
end

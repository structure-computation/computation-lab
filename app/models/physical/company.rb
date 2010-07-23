class Company < ActiveRecord::Base
  has_many  :users
  
  has_one   :calcul_account
  has_one   :memory_account
  
  has_many  :projects
  has_many  :sc_models
  has_many  :materials
  has_many  :links
  has_many  :solde_calcul_accounts,  :through => :calcul_account
  
  belongs_to  :user_sc_admin
  
  
  def init_account()
    current_calcul_account = self.create_calcul_account
    current_calcul_account.init
    
    current_memory_account = self.create_memory_account
    current_memory_account.init
  end
  
  
end

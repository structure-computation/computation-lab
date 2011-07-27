class Company < ActiveRecord::Base
  has_many  :users
  
  has_one   :calcul_account	, :readonly => false
  has_one   :memory_account	, :readonly => false
  
  has_many  :projects		, :readonly => false
  has_many  :sc_models		, :readonly => false
  has_many  :materials		, :readonly => false
  has_many  :links		, :readonly => false
  has_many  :solde_calcul_accounts,  :through => :calcul_account		, :readonly => false
  has_many  :bills		, :readonly => false
  
  belongs_to  :user_sc_admin
  
  
  def init_account()
    current_calcul_account = self.create_calcul_account
    current_calcul_account.init
    
    current_memory_account = self.create_memory_account
    current_memory_account.init
  end
  
  
end

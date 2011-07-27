class Company < ActiveRecord::Base
  has_many  :users
  # has_many  :managers , :conditions => {:role => "gestionnaire"} # TODO: Appliquer un filtre.
  
  has_one   :calcul_account	, :readonly => false
  has_one   :memory_account	, :readonly => false
  
  has_many  :projects		    , :readonly => false
  has_many  :sc_models		  , :readonly => false
  has_many  :materials		  , :readonly => false
  has_many  :links		      , :readonly => false
  has_many  :factures		    , :readonly => false
  
  has_many  :solde_calcul_accounts,  :through => :calcul_account		, :readonly => false

  has_many  :bills		, :readonly => false
  
  belongs_to  :user_sc_admin
  
  
  def managers
    users.where(:role => "gestionnaire")
  end
  
  def init_account()
    current_calcul_account = self.create_calcul_account
    current_calcul_account.init
    
    current_memory_account = self.create_memory_account
    current_memory_account.init
  end
  
  
  
end

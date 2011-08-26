class Workspace < ActiveRecord::Base
  
  # Un workspace peut posséder plusieurs workspaces grâce à la table :workspace_relationship
  has_many  :workspace_relationship 
  has_many  :companies, :through => :workspace_relationship
  
  #Un workspace possède un seul unique :account
  has_one :account   
                                    
  has_many  :user_company_memberships
  has_many  :users, :through => :user_company_memberships
  # has_many  :managers , :conditions => {:role => "gestionnaire"} # TODO: Appliquer un filtre.
  
  has_one   :calcul_account	, :readonly => false
  has_one   :memory_account	, :readonly => false
  
  has_many  :projects		    , :readonly => false
  has_many  :sc_models      , :readonly => false
  has_many  :materials		  , :readonly => false
  has_many  :links		      , :readonly => false
  has_many  :factures		    , :readonly => false    

  
  has_many  :solde_calcul_accounts,  :through => :calcul_account		, :readonly => false

  has_many  :bills		, :readonly => false
  
  belongs_to  :user_sc_admin
  
  # TODO: Placé en prévision du moment ou un utilisateur pourra acceder à plusieurs entreprise 
  # ET pour faire fonctionner inherited ressource qui fait un current_user.companies.find(...)
  scope :accessible_by_user, lambda { |user| 
          joins(:users).where("users.id = ?", user.id)
  }
  
  # TODO: pour faire foncitonner la chaine d'association Inherited ressource. 
  # Trouver une meilleure solution à terme.
  scope :companies
  
  
  def members
    users
  end
  
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

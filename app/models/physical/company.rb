class Company < ActiveRecord::Base
  
  
  
  # has_many  :managers , :conditions => {:role => "gestionnaire"} # TODO: Appliquer un filtre.
  has_many  :company_workspace_memberships
  has_many  :workspaces, :through => :company_workspace_memberships
  
  has_many  :company_user_memberships
  has_many  :users, :through =>  :company_user_memberships 
  
  has_many  :bills
  
  belongs_to  :user_sc_admin
  
  # TODO: Placé en prévision du moment ou un utilisateur pourra acceder à plusieurs entreprise 
  # ET pour faire fonctionner inherited ressource qui fait un current_user.companies.find(...)
  #   scope :accessible_by_user, lambda { |user| 
  #           joins(:users).where("users.id = ?", user.id)
  #   }
  
  
  
  def members
    users
  end
  
  def managers
    users.where(:role => "gestionnaire")
  end
  
  def percent_of(n)
    self.to_f/n.to_f * 100.0
    nbr jeton
    nbr consommer
    
    abonnement valeur gloabal
    taille memoire
  end
  
  def percent_of(n)
    self.to_f/n.to_f * 100.0
  end
  
end

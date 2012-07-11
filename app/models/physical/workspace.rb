class Workspace < ActiveRecord::Base
  
  # Un workspace peut posséder plusieurs workspaces grâce à la table :workspace_relationship 
  has_many  :workspace_relationships
  # TODO: Les appeller "sub-workspace" au moins ou tout autre nom reflétant la hiérarchie.
  has_many  :sub_workspaces, :through => :workspace_relationships
  
  
  #Un workspace possède un seul unique :account
  has_one   :account   
                                    
  has_many  :user_workspace_memberships
  has_many  :users, :through => :user_workspace_memberships
  # has_many  :managers , :conditions => {:role => "gestionnaire"} # TODO: Appliquer un filtre.
  has_many  :company_workspace_memberships
  has_many  :companies, :through => :company_workspace_memberships
  
  has_one   :token_account              , :readonly => false
  
  has_many  :sc_models                  , :readonly => false
  has_many  :materials		        , :readonly => false
  has_many  :links		        , :readonly => false 

  has_many  :bills		        , :readonly => false
  
  belongs_to  :user_sc_admin
  
  # TODO: Placé en prévision du moment ou un utilisateur pourra acceder à plusieurs entreprise 
  # ET pour faire fonctionner inherited ressource qui fait un current_user.companies.find(...)
  scope :accessible_by_user, lambda { |user| 
          joins(:users).where("users.id = ?", user.id)
  }
  
                          
  # si on passe en multi tenant,  companies devint workspaces
  #scope :workspace_relationship                    
  
  def members
    users
  end
  
  #def managers
  #  users.where(:role => "gestionnaire")
  #end
  
  def managers
    @members = self.user_workspace_memberships.where({:manager => 1})
    @users = []
    @members.each do |member|
      @users.push member.user if member.user
    end
    return @users
  end
  
  def engineers
    @members = self.user_workspace_memberships.where({:engineer => 1, :manager => 0})
    @users = []
    @members.each do |member|
      @users.push member.user if member.user
    end
    return @users
  end
  
  def init_account()
    current_token_account = self.create_token_account
    current_token_account.init
  end
end

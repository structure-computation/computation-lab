# encoding: utf-8

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
  
  has_many  :workspace_application_ownerships
  has_many  :applications, :through => :workspace_application_ownerships
  
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
  
  
  def init_account()
    current_token_account = self.create_token_account
    current_token_account.init
  end
  
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
  
  def tool_in_use(name_tool, current_workspace_member)
    #name_tool = "scills, sceen, score..."
    log_type = "use_" + name_tool
    log_tool_in_use = self.token_account.log_tools.find(:last, :conditions => {:log_type => log_type})
    if !log_tool_in_use.nil? and log_tool_in_use.in_use?
      #heure déja facturée sur cet outil
      return true
    else
      @new_log_tool_in_use = self.token_account.log_tools.build()
      @new_log_tool_in_use.token_account = self.token_account
      @new_log_tool_in_use.workspace_member = current_workspace_member
      return @new_log_tool_in_use.use_tool_for_one_hour(name_tool)
    end
  end
  
  def use_scwal_tool(params)
    #name_tool = "scills, sceen, score..."
    #"App=TestItem&typeApp=1&time=10&proc=2&wmid=2&sc_model_id=200"
    log_type = params[:app_type]
    log_type_app = 2 #params[:typeApp]
    log_time = params[:app_time]
    log_nbproc = params[:app_cpu]
    
    @new_log_tool = self.token_account.log_tools.build()
    @new_log_tool.token_account = self.token_account
    @new_log_tool.workspace_member = self.user_workspace_memberships.find(:first)
    @new_log_tool.log_type = log_type
    @new_log_tool.cpu_allocated = log_nbproc
    @new_log_tool.real_time = log_time
    @new_log_tool.use_tool_type(log_type_app)
  end
  
  
end

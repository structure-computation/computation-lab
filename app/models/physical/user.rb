# encoding: utf-8

class User < ActiveRecord::Base
  
  # Configuration de devise
  devise :database_authenticatable  , :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  # acts_as_api

  attr_accessible   :email,     :password, :password_confirmation, :remember_me,
                    :firstname, :lastname, :role
  
  scope       :managers     ,   where(:role => "gestionnaire")
  
  # Relations
  # belongs_to  :workspace
  has_many    :user_workspace_memberships, :dependent => :delete_all
  has_many    :workspaces, :through => :user_workspace_memberships
  
  # Relations
  has_many    :company_user_memberships, :dependent => :delete_all
  has_many    :companies, :through => :company_user_memberships
  
  
  # Relations sur les modèles.
  has_many    :model_ownerships, :through => :user_workspace_memberships, :class_name => "WorkspaceMemberToModelOwnership", :foreign_key => "workspace_member_id", :dependent => :delete_all
  
  
  # TODO: Ancienne relation !
  #has_many    :old_user_model_ownerships, :class_name => "UserModelOwnership", :foreign_key => "user_id"
  # has_many    :old_relation_sc_models, :through => :old_user_model_ownerships, :class_name => "ScModel", :foreign_key => "sc_model_id"
  #has_many    :sc_models, :through => :old_user_model_ownerships #, :class_name => "ScModel", :foreign_key => "sc_model_id"
  
  
  
  # has_many    :user_projects , :dependent => :destroy # Pour les gestionnaires, reattribuer ce projet.
  # has_many    :projects      , :through   => :user_projects
  # has_many    :owned_projects, :through   => :user_projects, :source => :task , :conditions => { "user_projects.is_admin"     => true }
  

  has_many    :calcul_results  
  has_many    :log_calculs
  has_many    :files_sc_models
  
  
  # TODO: La validation de format n'est plus disponible (suppr du module Authentication)
  # validates_presence_of     :firstname
  # validates_format_of       :firstname,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :firstname,     :maximum => 100
  
  # TODO: La validation de format n'est plus disponible (suppr du module Authentication)
  # validates_presence_of     :lastname
  # validates_format_of       :lastname,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :lastname,     :maximum => 100

  
  # TODO: Supprimer à la fin de la migration vers le multi tenant :
  # def workspace
  #   companies.first    
  # end
  
  def all_models
    model_ownerships.map &:sc_model
    
  end


  # Voir documentation devise : 
  # https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-edit-their-account-without-providing-a-password
  def password_required?
    new_record?
  end


  def full_name
    self.firstname + " " + self.lastname
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  # Pour éviter toute erreur...
  def as_json(options = {})
    super( :only => [ :id, :firstname, :lastname, :telephone, :email, :role  ] )
  end

  # TODO: Valider les procédure suivantes qui me semble non adaptées aux noms ou prénoms composés.
  # def firstname=(value)
  #   write_attribute :firstname, (value ? value.downcase : nil)
  # end
  # 
  # def lastname=(value)
  #   write_attribute :lastname, (value ? value.downcase : nil)
  # end
  
  def change_detail(params)
    self.firstname  = params[:firstname]
    self.lastname   = params[:lastname]
    self.save
  end
  
  def change_mdp?(params)
    logger.debug params
    logger.debug self.password 
    if self.password == params[:password] && !params[:new_password].blank? && params[:new_password] == params[:password_confirmation]
      return true
    else 
      return false
    end
  end
  


  protected
    
    # Idem
    # def make_activation_code
    #     self.deleted_at = nil
    #     self.activation_code = self.class.make_token
    # end


end

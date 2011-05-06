


# Intégration de devise 
# class User < ActiveRecord::Base
#   # Include default devise modules. Others available are:
#   # :token_authenticatable, :confirmable, :lockable and :timeoutable
#   devise :database_authenticatable, :registerable,
#          :recoverable, :rememberable, :trackable, :validatable
# 
#   # Setup accessible (or protected) attributes for your model
#   attr_accessible :email, :password, :password_confirmation, :remember_me
# end





class User < ActiveRecord::Base
  
  # Configuration de devise
  devise :database_authenticatable  , :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable


  attr_accessible   :email,     :password, :password_confirmation, :remember_me,
                    :firstname, :lastname, :role
  
  
  # Relations
  belongs_to  :company
  
  
  has_many    :user_sc_models 
  has_many    :sc_models    ,  :through => :user_sc_models

  has_many    :user_projects,  :dependent => :destroy # Pour les gestionnaires, reattribuer ce projet.
  has_many    :projects,       :through => :user_projects
  has_many    :owned_projects, :through => :user_projects, :source => :task , :conditions => { "user_projects.is_admin"     => true }
  
  # Gestion des tâches. 2 types de tâches + toutes les tâches : 3 relations + la relation de jointure.
  has_many    :user_tasks
  has_many    :tasks         , :through => :user_tasks,                   :dependent => :destroy
  has_many    :created_tasks , :through => :user_tasks, :source => :task    , :conditions => { "user_tasks.is_creator"      => true }
  has_many    :assigned_tasks, :through => :user_tasks, :source => :task    , :conditions => { "user_tasks.is_assigned_to"  => true }

  has_many    :log_calculs
  
  
  # TODO: La validation de format n'est plus disponible (suppr du module Authentication)
  # validates_presence_of     :firstname
  # validates_format_of       :firstname,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :firstname,     :maximum => 100
  
  # TODO: La validation de format n'est plus disponible (suppr du module Authentication)
  # validates_presence_of     :lastname
  # validates_format_of       :lastname,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :lastname,     :maximum => 100

  # Normalement pris en compte par Devise
  # validates_presence_of     :email
  # validates_length_of       :email,    :within => 6..100 #r@a.wk
  # validates_uniqueness_of   :email
  # validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  # validates_format_of       :password, :with => /^(?=.\d)(?=.([a-z]|[A-Z]))([\x20-\x7E]){6,40}$/, :if => :require_password?, :message => "must include one number, one letter and be between 6 and 40 characters"  

  # TODO: Ajouter des validation d'association avec une entreprise.

  # Voir documentation devise : https://github.com/plataformatec/devise/wiki/How-To%3a-Allow-users-to-edit-their-account-without-providing-a-password
  def password_required?
    new_record?
  end


  def full_name
    self.firstname + " " + self.lastname
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  
  # def serializable_hash(options = nil)
  #   options ||= {}
  #   options[:only] ||= []
  #   options[:only] += PUBLIC_FIELDS
  #   options[:only].uniq!
  #   super(options)
  # end
  
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
  
  def change_mdp(params)
    user = current_user.authenticated?(params[:password]) && !params[:new_password].blank? && params[:new_password] == params[:password_confirmation]
    return true
  end
  
  # Le mot de passe n'est necessaire que si l'utilisateur est "actif".
  # TODO: A supprimer au passage à devise.
  # def password_required?
  #   if (self.active?)
  #     crypted_password.blank? || !password.blank?
  #   else
  #     false
  #   end
  # end

  protected
    
    # Idem
    # def make_activation_code
    #     self.deleted_at = nil
    #     self.activation_code = self.class.make_token
    # end


end

require 'digest/sha1'

class User < ActiveRecord::Base
  # Inclusions, nottament pour Restfull Auth.
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include  Authorization::AasmRoles

  
  # Relations
  belongs_to  :company
  
  
  has_many    :user_sc_models 
  has_many    :sc_models    ,  :through => "user_sc_models"

  has_many    :user_projects,                                             :dependent => :destroy # Pour les gestionnaires, reattribuer ce projet.
  has_many    :projects,       :through => :user_projects
  has_many    :owned_projects, :through => :user_projects, :source => :task , :conditions => { "user_projects.is_admin"     => true }
  
  # Gestion des tâches. 2 types de tâches + toutes les tâches : 3 relations + la relation de jointure.
  has_many    :user_tasks
  has_many    :tasks         , :through => :user_tasks,                   :dependent => :destroy
  has_many    :created_tasks , :through => :user_tasks, :source => :task    , :conditions => { "user_tasks.is_creator"      => true }
  has_many    :assigned_tasks, :through => :user_tasks, :source => :task    , :conditions => { "user_tasks.is_assigned_to"  => true }

  has_many    :log_calculs
  
  
  # Validations

  # validates_presence_of     :login
  # validates_length_of       :login,    :within => 3..40
  # validates_uniqueness_of   :login
  # validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible  :email, :name, :password, :password_confirmation



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(email, password)
    return nil if email.blank? || password.blank?
    u = find_in_state :first, :active, :conditions => {:email => email.downcase} # need to get the salt
    #u && u.authenticated?(password) ? u : nil
  end


  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end

  protected
    
    def make_activation_code
        self.deleted_at = nil
        self.activation_code = self.class.make_token
    end


end

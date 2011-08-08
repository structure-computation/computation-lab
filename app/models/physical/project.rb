class Project < ActiveRecord::Base
  
  belongs_to  :company
  
  has_many    :user_projects
  has_many    :users , :through => :user_projects
  has_many    :admins, :through => :user_projects, :source => :users, :conditions => {"user_projects.is_admin"     => true}
              
  has_many    :sc_models
  #has_many    :log_calculs
  
  # has_many :forums
end

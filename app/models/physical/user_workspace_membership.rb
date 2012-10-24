# encoding: utf-8

class UserWorkspaceMembership < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :workspace
  
  has_many    :model_ownerships, :class_name => "WorkspaceMemberToModelOwnership", :foreign_key => "workspace_member_id", :dependent => :delete_all
  has_many    :sc_models,                 :through => :model_ownerships

  
  def make_role
    if self.manager and self.engineer
      self.role = "all"
    elsif self.manager and !self.engineer
      self.role = "manager"
    elsif !self.manager and self.engineer
      self.role = "engineer"
    end
    self.save
  end
  
  def is_manager?
    result = false
    if self.manager
      result = true
    end
    return result
  end
  
  # TODO: exemple pour mise en place des scopes.
  # scope :manager, where(Member.manager_condition_sql)
  # 
  # def self.manager_condition_sql
  #   " members.role LIKE '%manager%' OR  members.role LIKE '%all%' "
  # end
  # 

end

class UserCompanyMembership < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :company
  
  has_many    :model_ownerships, :class_name => "UserModelOwnership", :foreign_key => "company_member_id"
  has_many    :sc_models,                 :through => :model_ownerships

  # TODO: exemple pour mise en place des scopes.
  # scope :manager, where(Member.manager_condition_sql)
  # 
  # def self.manager_condition_sql
  #   " members.role LIKE '%manager%' OR  members.role LIKE '%all%' "
  # end
  # 



end

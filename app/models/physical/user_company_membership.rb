class UserCompanyMembership < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :company
  
  has_many    :model_ownerships, :class_name => "UserModelOwnership", :foreign_key => "company_member_id"
  has_many    :sc_models,                 :through => :model_ownerships

end

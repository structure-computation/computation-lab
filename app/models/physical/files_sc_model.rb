class FilesScModel < ActiveRecord::Base
  
  belongs_to  :sc_model
  belongs_to  :user
  belongs_to  :company_member, :class_name => "UserCompanyMembership", :foreign_key => "company_member_id"
  
  
end

class FilesScModel < ActiveRecord::Base
  
  belongs_to  :sc_model
  belongs_to  :user
  belongs_to  :workspace_member, :class_name => "UserCompanyMembership", :foreign_key => "workspace_member_id"
  
  
end

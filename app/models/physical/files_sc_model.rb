# encoding: utf-8

class FilesScModel < ActiveRecord::Base
  
  belongs_to  :sc_model
  belongs_to  :user
  belongs_to  :workspace_member, :class_name => "UserWorkspaceMembership", :foreign_key => "workspace_member_id"
  
  
end

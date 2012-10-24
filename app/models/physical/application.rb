# encoding: utf-8

class Application < ActiveRecord::Base
  has_many  :workspace_application_ownerships
  has_many  :workspaces, :through => :workspace_application_ownerships
  
  has_many   :log_tools
end

# encoding: utf-8

class Application < ActiveRecord::Base
  has_many  :workspace_application_ownerships
  has_many  :workspaces, :through => :workspace_application_ownerships
  
  has_many   :log_tools
  
  def activate()
    self.state = "active"
    self.save
  end
  
  def pause()
    self.state = "pause"
    self.save
  end
  
  
  
end

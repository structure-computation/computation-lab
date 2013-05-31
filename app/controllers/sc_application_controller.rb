# encoding: utf-8


class ScApplicationController < InheritedResources::Base
  before_filter :authenticate_user!  
  before_filter :must_be_manager
  before_filter :set_page_name
  
  layout 'workspace'
  
  def set_page_name
    @page = :manage
  end
  
  def index
    @workspace      = current_workspace_member.workspace
    @applications   = Application.find(:all, :conditions => {:state => "active"})
  end
  
  
end

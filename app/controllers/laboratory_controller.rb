# encoding: utf-8

class LaboratoryController < InheritedResources::Base
  before_filter :authenticate_user!  
  before_filter :must_be_engineer
  before_filter :set_page_name
  belongs_to :workspace
  
  layout 'workspace'
#  belongs_to :member
  
  def set_page_name
    @page = :lab
  end
  
  def index
    @workspace                  = current_workspace_member.workspace
    @sc_models                  = current_workspace_member.sc_models
    #@sc_models                  = ScModel.from_workspace @workspace.id
    @standard_materials         = Material.standard  
    @workspace_materials        = Material.from_workspace @workspace.id
    @standard_links             = Link.standard
    @workspace_links            = Link.from_workspace @workspace.id
    
  end
  
end

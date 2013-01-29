# encoding: utf-8

class ScAdminJobController < InheritedResources::Base
  before_filter :authenticate_user!
  before_filter :valid_admin_user
  
  layout 'sc_admin'
  
  
  def index 
    @page = :sc_admin_company
    @jobs = LogTool.find(:all, :conditions => {:launch_state => "in_process"})
    if params[:notice] 
      flash[:notice] = params[:notice]
    end
  end
  
  def end_job
    @current_log_tools = LogTool.find(params[:id])
    @current_log_tools.echec
    redirect_to :action => :index, :notice => "Le job a été annulée" # TODO traduire 
  end
end

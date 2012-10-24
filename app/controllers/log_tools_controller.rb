# encoding: utf-8

class LogToolsController < ApplicationController
  require 'json'
  
  # scult -----------------------------------------------------------------------------------
  def scult_launch
    @current_log_tools = LogTool.find(params[:log_id])
    @current_model = @current_log_tools.sc_model
    @current_workspace_member = @current_log_tools.workspace_member
    @workspace    = @current_workspace_member.workspace
    @current_user = @current_workspace_member.user
    
    logger.debug "@current_model.id : " + @current_model.id.to_s
    logger.debug "@workspace.id : " + @workspace.id.to_s
    logger.debug "@current_user.id : " + @current_user.id.to_s
    
    @current_log_tools.in_process()
    render :text => 'success'
  end
  
  
  def scult_finish
    @current_log_tools = LogTool.find(params[:log_id])
    @current_log_tools.scult_valid(params)
    render :text => 'success'
  end
  
  # scills -----------------------------------------------------------------------------------
  def scills_launch
    @current_log_tools = LogTool.find(params[:log_id])
    @current_model = @current_log_tools.sc_model
    @current_calcul = @current_log_tools.calcul_result
    @current_workspace_member = @current_log_tools.workspace_member
    @workspace    = @current_workspace_member.workspace
    @current_user = @current_workspace_member.user
    
    logger.debug "@current_model.id : " + @current_model.id.to_s
    logger.debug "@workspace.id : " + @workspace.id.to_s
    logger.debug "@current_user.id : " + @current_user.id.to_s
    
    @current_log_tools.in_process()
    render :text => 'success'
  end
  
  def scills_finish
    @current_log_tools = LogTool.find(params[:log_id])
    @current_log_tools.scills_valid(params)
    render :text => 'success'
  end
  
end

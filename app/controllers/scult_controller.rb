# encoding: utf-8

class ScultController < InheritedResources::Base 
  before_filter :authenticate_user!  
  layout 'workspace'
  before_filter :must_be_engineer 
  before_filter :set_page_name
  
  def set_page_name
    @page = :lab
  end
  
  def index
    @workspace  = current_workspace_member.workspace
    @sc_model  = ScModel.from_workspace(current_workspace_member.workspace.id).find_by_id(params[:sc_model_id])
    logger.debug 'void = ' + @sc_model.void_state().to_s
    if !@sc_model.void_state() 
      @current_log_tool_scult = @sc_model.log_tools.find(:last)
      @current_log_tool_scult.get_launch_autorisation()
      render :create
    end
  end
  
  def create
    @workspace  = current_workspace_member.workspace
    @sc_model = ScModel.find(params[:sc_model_id])
    if params[:sc_model][:file].nil?
      flash[:error] = "Vous n'avez pas séléctionné de fichier !" # TODO, traduire
      render :index
    else
      res = @sc_model.load_mesh(params, current_workspace_member) unless params[:sc_model][:file].nil?
      @current_log_tool_scult = @sc_model.log_tools.find(:last)
      @current_log_tool_scult.get_launch_autorisation()
      render :create
    end
  end 
  
  def update
    @workspace  = current_workspace_member.workspace
    @sc_model = ScModel.find(params[:sc_model_id])
    @current_log_tool_scult = @sc_model.log_tools.find(:last)
    if @current_log_tool_scult.get_launch_autorisation()
      res = @sc_model.create_mesh(current_workspace_member, @current_log_tool_scult)
      redirect_to workspace_sc_model_path(@workspace, @sc_model), :notice => res # TODO: traduire.
    else
      flash[:error] = "Vous n'avez pas assez de jetons !" # TODO, traduire
      render :create
    end
  end 
  
  def destroy
    @workspace  = current_workspace_member.workspace
    @sc_model = ScModel.find(params[:sc_model_id])
    @sc_model.delete_mesh()
    redirect_to :action => :index, :sc_model_id => @sc_model.id, :notice => "le modèle est vide !"
  end
end

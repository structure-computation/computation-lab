# encoding: utf-8

class CalculsController < ApplicationController
  require 'json'
  require 'socket'
  include Socket::Constants
  before_filter :authenticate_user! , :except => :calcul_valid     
  before_filter :must_be_engineer   
  layout 'calcul'
  
  def index
    @current_model = current_workspace_member.sc_models.find(params[:sc_model_id])
    @current_model.tool_in_use("scills", current_workspace_member)
    if @current_model.state != "active"
      redirect_to workspace_sc_model_path(current_workspace_member.workspace.id, @current_model), :notice => "Pour accéder à cet outils, vous devez d'abord charger un maillage ou une géometrie."
    else
      @standard_links      = Link.standard
      @workspace_links     = Link.from_workspace(current_workspace_member.workspace)
      @standard_materials  = Material.standard
      @workspace_materials = Material.from_workspace(current_workspace_member.workspace)
      @material            = Material.new
      @link                = Link.new
      @model_id            = params[:sc_model_id]
      @workspace           = current_workspace_member.workspace
      @calculs             = CalculResult.find_all_by_sc_model_id(params[:sc_model_id])
    end
  end
  
  def show
    @current_model = current_workspace_member.sc_models.find(params[:sc_model_id])
    @current_calcul = @current_model.calcul_results.find(params[:id])
    send_data = @current_calcul.get_brouillon(params,current_workspace_member)
    pretty_json = JSON.pretty_generate(send_data)
    render :json => pretty_json
  end
 
  # Enregistre les informations du calcul dans un fichier brouillon
  def update
    @current_model = current_workspace_member.sc_models.find(params[:sc_model_id])
    @current_calcul = @current_model.calcul_results.find(params[:id])
    if params[:name] and params[:update_db_info]
      @current_calcul.name = params[:name]
      @current_calcul.description = params[:description]
      @current_calcul.save
    else
      results = @current_calcul.save_brouillon(params)
    end
    render :json => @current_calcul
  end
  
  def create
    @current_model              = current_workspace_member.sc_models.find(params[:sc_model_id])
    @current_calcul             = CalculResult.new
    @current_calcul.name        = "brouillon_" + (CalculResult.find_all_by_sc_model_id(@current_model).length + 1).to_s
    @current_calcul.sc_model_id = @current_model.id
    @current_calcul.user_id     = current_workspace_member.user_id
    @current_calcul.state       = "temp"
    @current_calcul.save!
    results = @current_calcul.save_new_brouillon(params)
    render :json => @current_calcul.to_json
  end
  
  def duplicate
    @current_model              = current_workspace_member.sc_models.find(params[:sc_model_id])
    @current_calcul             = CalculResult.new
    @current_calcul.name        = "brouillon_" + (CalculResult.find_all_by_sc_model_id(@current_model).length + 1).to_s
    @current_calcul.sc_model_id = @current_model.id
    @current_calcul.user_id     = current_workspace_member.user_id
    @current_calcul.state       = "temp"
    @current_calcul.save!
    results = @current_calcul.duplicate_brouillon(params)
    render :json => @current_calcul.to_json
  end
  
  def new
    @id_model = params[:id_model]
    @current_model = current_workspace_member.sc_models.find(@id_model)
    @id_calcul = params[:id_calcul]
    @current_calcul = @current_model.calcul_results.create(
      :name => params[:name],
      :description => params[:description], 
      :state => 'temp', 
      :ctype =>params[:ctype], 
      :D2type => params[:D2type], 
      :log_type => 'compute'
    )
    @current_calcul.workspace_member = current_workspace_member
    @current_calcul.name = "brouillon_#{@current_calcul.id}"
    @current_calcul.save
    render :json => @current_calcul.to_json
  end

  #TODO: Supprimer le fichier calcul après X jours
  def destroy
    @current_model = current_workspace_member.sc_models.find(params[:sc_model_id])
    @current_calcul = @current_model.calcul_results.find(params[:id]) 
    @current_calcul.destroy
    render :json => @current_calcul.to_json
  end
  
  def compute_forcast
    @current_model = current_workspace_member.sc_models.find(params[:sc_model_id])
    @current_calcul = @current_model.calcul_results.find(params[:id])
    @log_tool = @current_calcul.compute_forcast(current_workspace_member)
    logger.debug @log_tool.to_json
    # envoie de la reponse au client
    render :json => @log_tool.to_json
  end
  
  def send_calcul
    @current_model = current_workspace_member.sc_models.find(params[:sc_model_id])
    @current_calcul = @current_model.calcul_results.find(params[:id])
    @current_log_tool_scills = @current_calcul.compute_forcast(current_workspace_member)
    send_data = {}
    if @current_log_tool_scills.get_launch_autorisation()
      @current_calcul.send_calcul(current_workspace_member, @current_log_tool_scills)
      send_data[:message] = "calcul envoyé"
    else
      send_data[:message] = "Vous n'avez pas assez de jetons !" # TODO, traduire
    end
    # envoie de la reponse au client
    render :json => send_data.to_json
  end
  
end

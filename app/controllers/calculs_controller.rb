class CalculsController < ApplicationController
  require 'json'
  require 'socket'
  include Socket::Constants
  before_filter :authenticate_user! , :except => :calcul_valid
  layout 'calcul'
  
  def index
    @standard_links     = Link.standard
    @workspace_links    = Link.from_workspace(current_workspace_member.workspace)
    @standard_materials = Material.standard
    @workspace_materials  = Material.from_workspace(current_workspace_member.workspace)
    @material           = Material.new
    @link               = Link.new
    @workspace          = current_workspace_member.workspace
    @calculs            = CalculResult.find_all_by_sc_model_id(params[:sc_model_id])
  end
  
  def show
    @current_model = current_workspace_member.sc_models.find(params[:sc_model_id])
    @current_calcul = @current_model.calcul_results.find(params[:id])
    send_data = @current_calcul.get_brouillon(params,current_workspace_member)
    render :json => send_data.to_json
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
    render :text => results
  end
  
  def create
    @current_model              = current_workspace_member.sc_models.find(params[:sc_model_id])
    @current_calcul             = CalculResult.new
    @current_calcul.name        = "brouillon_" + (CalculResult.find_all_by_sc_model_id(@current_model).length + 1).to_s
    @current_calcul.sc_model_id = @current_model.id
    @current_calcul.user_id     = current_workspace_member.user_id
    @current_calcul.state       = "temp"
    @current_calcul.save!
    results = @current_calcul.save_brouillon(params)
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
    @current_model = current_user.sc_models.find(params[:sc_model_id])
    @current_calcul = @current_model.calcul_results.find(params[:id]) 
    @current_calcul.destroy
    render :json => @current_calcul.to_json
  end
end

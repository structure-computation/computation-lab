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
    @workspace            = current_workspace_member.workspace
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
    results = @current_calcul.save_brouillon(params)
    render :text => results
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

end

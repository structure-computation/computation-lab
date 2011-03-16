class VisualisationController < ApplicationController
  require 'json'
  require 'socket'
  include Socket::Constants
  before_filter :authenticate_user! , :except => :calcul_valid
  
  def index
    @page = 'SCcompute'
    @id_model = params[:id_model]
    current_model = @current_user.sc_models.find(@id_model)
    @dim_model = current_model.dimension
    respond_to do |format|
      format.html {render :layout => false }
    end 
  end
  
  def info_model
    @id_model = params[:id_model]  
    
    # lecture du fichier sur le disque
    path_to_file = "#{SC_MODEL_ROOT}/model_#{@id_model}/MESH/mesh.txt"
    results = File.read(path_to_file)
    
    render :json => results
  end
  
end

class CalculsController < ApplicationController
  require 'json'
  require 'socket'
  include Socket::Constants
  before_filter :authenticate_user! , :except => :calcul_valid
  
  def index
    # @page = 'SCcompute'
    # @model_id = params[:model_id]
    # current_model = current_user.sc_models.find(@model_id)
    # @dim_model = current_model.dimension
    # respond_to do |format|
    #   format.html {render :layout => false }
    # end 
  end
  
  def info_model
    @id_model = params[:id_model]  
    
    # lecture du fichier sur le disque
    path_to_file = "#{SC_MODEL_ROOT}/model_#{@id_model}/MESH/mesh.txt"
    results = File.read(path_to_file)
    
    render :json => results
  end
  
  def calculs
    @id_model = params[:id_model]
    current_model = current_user.sc_models.find(@id_model)
    @calculs = current_model.calcul_results.find(:all, :conditions => ["log_type = ? AND state != ?", "compute", "deleted"])
    #:all, :conditions => ["log_type = ? AND state != ?", "compute", "deleted"])
    respond_to do |format|
      format.js   {render :json => @calculs.to_json}
    end
  end
  
  def materiaux
    @current_company = current_user.company
    all_materials = Material.find(:all, :conditions => {:reference => 1, :company_id => -1})
    company_materials = @current_company.materials.find(:all)
    @materials = all_materials.concat( company_materials )
    respond_to do |format|
      format.js   {render :json => @materials.to_json}
    end
  end
  
  def liaisons
    @liaisons = Link.find(:all, :conditions => {:reference => 1})
    respond_to do |format|
      format.js   {render :json => @liaisons.to_json}
    end
  end
  
  def CLs
    @CLs = []
    @CLs[0] = BoundaryCondition.new(:ref=>'v0', :type_picto=>'poids',        :bctype=>'volume', :name=>'poids')
    @CLs[1] = BoundaryCondition.new(:ref=>'v1', :type_picto=>'acceleration', :bctype=>'volume', :name=>'effort d\'accélération')
    @CLs[2] = BoundaryCondition.new(:ref=>'v2', :type_picto=>'centrifuge',   :bctype=>'volume', :name=>'effort centrifuge')
	
	@CLs[3] = BoundaryCondition.new(:ref=>'e0', :type_picto=>'effort',   :bctype=>'effort', :name=>"densité d'effort")
	@CLs[4] = BoundaryCondition.new(:ref=>'e1', :type_picto=>'effort',   :bctype=>'effort_normal', :name=>"densité d'effort normal")
	@CLs[5] = BoundaryCondition.new(:ref=>'e2', :type_picto=>'effort',   :bctype=>'pression', :name=>'pression')
	
	@CLs[6] = BoundaryCondition.new(:ref=>'d0', :type_picto=>'depl',   :bctype=>'depl_nul', :name=>'déplacement nul')
	@CLs[7] = BoundaryCondition.new(:ref=>'d1', :type_picto=>'depl',   :bctype=>'depl', :name=>'déplacement imposé')
	@CLs[8] = BoundaryCondition.new(:ref=>'d2', :type_picto=>'depl',   :bctype=>'depl_normal', :name=>'déplacement normal imposé')
	@CLs[9] = BoundaryCondition.new(:ref=>'d3', :type_picto=>'depl',   :bctype=>'sym', :name=>'symétrie')
	    
    respond_to do |format|
      format.js   {render :json => @CLs.to_json}
    end
  end
  
  def new
    @id_model = params[:id_model]
    @current_model = current_user.sc_models.find(@id_model)
    @id_calcul = params[:id_calcul]
    @current_calcul = @current_model.calcul_results.create(:name => params[:name], :description => params[:description], :state => 'temp', :ctype =>params[:ctype], :D2type => params[:D2type], :log_type => 'compute')
    @current_calcul.user = current_user
    @current_calcul.name = "brouillon_#{@current_calcul.id}"
    @current_calcul.save
    render :json => @current_calcul.to_json
  end
  
  def get_brouillon
    @current_model = current_user.sc_models.find(params[:id_model])
    @current_calcul = @current_model.calcul_results.find(params[:id_calcul])
    send_data = @current_calcul.get_brouillon(params,current_user)
    # envoie de la reponse au client
    render :json => send_data.to_json
  end

  def load_brouillon_from_ext_file
    @current_model = current_user.sc_models.find(params[:id_model])
    @current_calcul = @current_model.calcul_results.new( :state => 'temp', :ctype =>'statique', :log_type => 'compute', :D2type => 'DP')
    results = @current_calcul.load_brouillon_from_ext_file(params,current_user)
    if !results
      @current_calcul.delete
    end
    # envoie de la reponse au client
    render :text => results
  end
  
  def send_brouillon
    @current_model = current_user.sc_models.find(params[:id_model])
    @current_calcul = @current_model.calcul_results.find(params[:id_calcul])
    results = @current_calcul.save_brouillon(params)
    # envoie de la reponse au client
    render :text => results
  end
  
  def send_calcul
    @current_model = current_user.sc_models.find(params[:id_model])
    @current_calcul = @current_model.calcul_results.find(params[:id_calcul])
    results = @current_calcul.send_calcul(params)
    # envoie de la reponse au client
    render :text => results
  end
  
  def compute_previsions
    @current_model = current_user.sc_models.find(params[:id_model])
    @current_calcul = @current_model.calcul_results.find(params[:id_calcul])
    send_data = @current_calcul.compute_previsions()
    # envoie de la reponse au client
    render :text => send_data.to_json
  end
  
  def calcul_valid
    @id_model = params[:id_model]
    @id_calcul = params[:id_calcul]

    @current_model = ScModel.find(@id_model)
    @current_calcul = @current_model.calcul_results.find(@id_calcul)
    
    @current_calcul.calcul_valid(params) 
    
    render :text => { :result => 'success' }
  end
  
end

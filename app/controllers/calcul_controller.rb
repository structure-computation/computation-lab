class CalculController < ApplicationController
  require 'json'
  require 'socket'
  include Socket::Constants
  before_filter :login_required , :except => :calcul_valid
  
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
    path_to_file = "/home/scproduction/MODEL/model_#{@id_model}/MESH/mesh.txt"
    results = File.read(path_to_file)
    
    render :json => results
  end
  
  def calculs
    @id_model = params[:id_model]
    current_model = @current_user.sc_models.find(@id_model)
    @calculs = current_model.calcul_results.find(:all, :conditions => {:log_type => "compute"})
    respond_to do |format|
      format.js   {render :json => @calculs.to_json}
    end
  end
  
  def materiaux
    @materiaux = Material.find(:all)
    respond_to do |format|
      format.js   {render :json => @materiaux.to_json}
    end
  end
  
  def liaisons
    @liaisons = Link.find(:all)
    respond_to do |format|
      format.js   {render :json => @liaisons.to_json}
    end
  end
  
  def CLs
    @CLs = []
    @CLs[0] = BoundaryCondition.new(:ref=>'v0', :type_picto=>'poids',        :bctype=>'volume', :name=>'poids')
    @CLs[1] = BoundaryCondition.new(:ref=>'v1', :type_picto=>'acceleration', :bctype=>'volume', :name=>'effort d\'accélération')
    @CLs[2] = BoundaryCondition.new(:ref=>'v2', :type_picto=>'centrifuge',   :bctype=>'volume', :name=>'effort centrifuge')
	
	@CLs[3] = BoundaryCondition.new(:ref=>'e0', :type_picto=>'effort',   :bctype=>'effort', :name=>'force')
	@CLs[4] = BoundaryCondition.new(:ref=>'e1', :type_picto=>'effort',   :bctype=>'effort', :name=>'force normale')
	@CLs[5] = BoundaryCondition.new(:ref=>'e2', :type_picto=>'effort',   :bctype=>'effort', :name=>'pression')
	
	@CLs[6] = BoundaryCondition.new(:ref=>'d0', :type_picto=>'depl',   :bctype=>'depl', :name=>'déplacement nul')
	@CLs[7] = BoundaryCondition.new(:ref=>'d1', :type_picto=>'depl',   :bctype=>'depl', :name=>'déplacement imposé')
	@CLs[8] = BoundaryCondition.new(:ref=>'d2', :type_picto=>'depl',   :bctype=>'depl', :name=>'déplacement normal imposé')
	@CLs[9] = BoundaryCondition.new(:ref=>'d3', :type_picto=>'depl',   :bctype=>'depl', :name=>'symétrie')
	    
    respond_to do |format|
      format.js   {render :json => @CLs.to_json}
    end
  end
  
  def new
    @id_model = params[:id_model]
    @current_model = @current_user.sc_models.find(@id_model)
    @id_calcul = params[:id_calcul]
    @current_calcul = @current_model.calcul_results.create(:name => params[:name], :description => params[:description], :state => 'temp', :ctype => 'statique', :log_type => 'compute')
    @current_calcul.user = @current_user
    @current_calcul.save
    render :json => @current_calcul.to_json
  end
  
  def get_brouillon
    @id_model = params[:id_model]
    @current_model = @current_user.sc_models.find(@id_model)
    @id_calcul = params[:id_calcul]
    
    # lecture du fichier sur le disque
    path_to_file = "/home/scproduction/MODEL/model_#{@id_model}/calcul_#{@id_calcul}/brouillon.json"
    results = File.read(path_to_file)
    
    render :json => results
  end

  def send_brouillon
    @id_model = params[:id_model]
    @id_calcul = params[:id_calcul]
    current_model = @current_user.sc_models.find(@id_model)
#     file = params[:file]
    jsonobject = JSON.parse(params[:file])
    file = JSON.pretty_generate(jsonobject)
    
    # on enregistre le fichier sur le disque et on change les droit pour que le serveur de calcul y ait acces
    path_to_model = "/home/scproduction/MODEL/model_#{@id_model}"
    path_to_calcul = "/home/scproduction/MODEL/model_#{@id_model}/calcul_#{@id_calcul}"
 
    Dir.mkdir(path_to_model, 0777) unless File.exists?(path_to_model)
    Dir.mkdir(path_to_calcul, 0777) unless File.exists?(path_to_calcul)

    path_to_file = path_to_calcul + "/brouillon.json"
    File.open(path_to_file, 'w+') do |f|
        f.write(file)
    end
    File.chmod 0777, path_to_calcul
    results = "brouillon sauvegardé"
    
    # envoie de la reponse au client
    render :text => results
  end
  
  def send_calcul
    @id_model = params[:id_model]
    @id_calcul = params[:id_calcul]
    current_model = @current_user.sc_models.find(@id_model)
    current_calcul = current_model.calcul_results.find(@id_calcul)
    #file = params[:file]
    jsonobject = JSON.parse(params[:file])
    file = JSON.pretty_generate(jsonobject)
    
    # on enregistre le fichier sur le disque et on change les droit pour que le serveur de calcul y ait acces
    path_to_model = "/home/scproduction/MODEL/model_#{@id_model}"
    path_to_calcul = "/home/scproduction/MODEL/model_#{@id_model}/calcul_#{@id_calcul}"
 
    Dir.mkdir(path_to_model, 0777) unless File.exists?(path_to_model)
    Dir.mkdir(path_to_calcul, 0777) unless File.exists?(path_to_calcul)

    path_to_file = path_to_calcul + "/calcul.json"
    File.open(path_to_file, 'w+') do |f|
        f.write(file)
    end
    File.chmod 0777, path_to_calcul
    
    # création des elements a envoyer au calculateur
    send_data  = { :id_model => @id_model, :id_calcul => @id_calcul, :dimension => current_model.dimension , :mode => "compute"};
    
#     # socket d'envoie au serveur
#     socket    = Socket.new( AF_INET, SOCK_STREAM, 0 )
#     sockaddr  = Socket.pack_sockaddr_in( 12346, 'localhost' )
#     #sockaddr  = Socket.pack_sockaddr_in( 12346, 'sc2.ens-cachan.fr' )
#     socket.connect( sockaddr )
#     socket.write( send_data.to_json )
#     #socket.write( file.read )
#     
#     # reponse du calculateur
#     results = socket.read
#     current_calcul.state = 'in_process'
#     current_calcul.save
#     
#     # envoie de la reponse au client
#     render :text => results
    render :text => "fichier calcul enregistré"
  end
  
  def calcul_valid
    @id_model = params[:id_model]
    @id_calcul = params[:id_calcul]

    @current_model = ScModel.find(@id_model)
    @current_calcul = @current_model.calcul_results.find(@id_calcul)
    
    @current_calcul.calcul_valid(params[:time]) 
    
    render :text => { :result => 'success' }
  end
  
end

class ScModel < ActiveRecord::Base
  require 'json'
  require 'find'
  require 'socket'
  include Socket::Constants
  
  belongs_to  :company
  belongs_to  :project
  
  has_many    :user_sc_models 
  has_many    :files_sc_models 
  has_many    :users    ,  :through => :user_sc_models
  
  has_many    :calcul_results
  has_many    :forum_sc_models
  
  #state possibles : void, in_process, active, deleted, 
  
  def has_result? 
    return (rand(1) > 0.5)
  end
  
  def send_mesh(params,current_user)
    # on enregistre les fichier sur le disque et on change les droit pour que le serveur de calcul y ai acces
    file = params[:fichier] 
    name = file.original_filename
    if name.match(/.bdf/)
      extension = ".bdf"
    elsif name.match(/.avs/)
      extension = ".avs"
    else
      results = "type de fichier de maillage non reconnu"
      return results
    end
    
    path_to_model = "#{SC_MODEL_ROOT}/model_#{self.id}"
    path_to_mesh = "#{SC_MODEL_ROOT}/model_#{self.id}/MESH"
    Dir.mkdir(path_to_model, 0777) unless File.exists?(path_to_model)
    Dir.mkdir(path_to_mesh, 0777) unless File.exists?(path_to_mesh)
    path_to_file = path_to_mesh + "/mesh" + extension
    File.chmod 0777, path_to_model
    File.chmod 0777, path_to_mesh
    
    File.open(path_to_file, 'w+') do |f|
        f.write(file.read)
    end
    
    # création du fichier json_model 
    identite_calcul = { :id_societe => self.company.id, :id_user => current_user.id, :id_projet => '', :id_model => self.id, :id_calcul => '', :dimension  => self.dimension};
    priorite_calcul = { :priorite => 0 };                               
    mesh = { :mesh_directory => "MESH", :mesh_name  => "mesh", :extension  => extension};
    json_model = { :identite_calcul => identite_calcul, :priorite_calcul => priorite_calcul, :mesh => mesh}; 
    
    # enregistrement sur le disque
    path_to_json_model = path_to_mesh + "/model_id.json"
    File.open(path_to_json_model, 'w+') do |f|
        f.write(JSON.pretty_generate(json_model))
    end
    
#     # envoi de la requette de création de model au serveur de calcul
#     send_data = { :id_user => current_user.id, :mode => "create", :identite_calcul => identite_calcul };   
#     # socket d'envoie au serveur
#     socket    = Socket.new( AF_INET, SOCK_STREAM, 0 )
#     sockaddr  = Socket.pack_sockaddr_in( SC_CALCUL_PORT, SC_CALCUL_SERVER )
#     socket.connect( sockaddr )
#     socket.write( send_data.to_json )
#     
#     # reponse du calculateur
#     results = socket.read
    self.change_state('uploaded')
    self.save
    
    # on retourne le resultats
    return results
    
  end
  
  
  #def mesh_valid(id_user,calcul_time,json)
  def mesh_valid(id_user,calcul_time)
    current_user = User.find(id_user)
    path_to_file = "#{SC_MODEL_ROOT}/model_#{self.id}/MESH/mesh.txt"
    results = File.read(path_to_file)
    jsonobject = JSON.parse(results)
    #jsonobject = JSON.parse(json)
    
    #mise à jour des infos modèle
    self.parts = jsonobject[0]['mesh']['nb_groups_elem']
    self.interfaces = jsonobject[0]['mesh']['nb_groups_inter']
    self.sst_number = jsonobject[0]['mesh']['nb_sst']
    self.change_state('active')
    self.get_used_memory()
    #self.save
    
    #mise à jour du résultat de calcul
    @calcul_result = self.calcul_results.build(:calcul_time => calcul_time, :ctype => 'create', :state => 'uploaded', :gpu_allocated => 1) 
    @calcul_result.user = current_user
    @calcul_result.result_date = Time.now
    @calcul_result.save
    
    #mise à jour du compte de calcul
    self.company.calcul_account.log_model(@calcul_result.id)
    
  end
  
  def get_used_memory()
    dirsize =0
    path_to_model = "#{SC_MODEL_ROOT}/model_#{self.id}"
    Find.find(path_to_model) do |f| 
      dirsize += File.stat(f).size 
    end 
    self.used_memory = dirsize
    self.save
    self.company.memory_account.get_used_memory()
  end
  
  def self.save_mesh_file(upload)
    name        =  upload['upload'].original_filename
    directory   = "public/test"
    # create the file path
    path        = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end

  def request_mesh_analysis
    # TODO: Ecrire l'objet CalculatorInterface qui appellera la bonne ligne de commande (entre autre) dans une lib.
    CalculatorInterface.delay.analyse_mesh_for_model self
    # A ce stade la demande est placee dans la file des demande en attente.
  end
  
  def test_delete?
    list_result = self.calcul_results.find(:all)
    value_to_return = true
    list_result.each{ |result_i| 
      if(result_i.state == 'finish' || result_i.state == 'in_process')
         value_to_return = false
      end
    }
    return value_to_return
  end
  
  def delete_model()
    self.users.clear
    self.change_state('deleted')
    self.deleted_at = Time.now
    #self.used_memory = 0
    self.save
  end
  
   def change_state(state)
    #mise à jour dde l'état du sc_model
    #state possibles : void, in_process, active, deleted, 
    self.state = state
    #self.save
  end
  
end

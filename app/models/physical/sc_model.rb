class ScModel < ActiveRecord::Base
  require 'json'
  require 'find'
  require 'socket'
  include Socket::Constants
  
  belongs_to  :workspace
  
  has_many    :files_sc_models 

  has_many    :model_ownerships, :class_name => "WorkspaceMemberToModelOwnership"
  has_many    :workspace_members,                  :through => :model_ownerships

  has_many    :log_tools
  has_many    :calcul_results
  has_many    :forum_sc_models  
  
  scope :from_workspace , lambda { |workspace_id|
     where(:workspace_id => workspace_id)
   }
  
  #state possibles : void, in_process, active, deleted, 
  
  def has_result? 
    return (rand(1) > 0.5)
  end
  
  def add_repository()
    # on crée le repertoir du modele
    path_to_sc_model = "#{SC_MODEL_ROOT}/model_#{self.id}"
    Dir.mkdir(path_to_sc_model, 0777) unless File.exists?(path_to_sc_model)
    File.chmod 0777, path_to_sc_model
  end
  
  def load_mesh(params, current_workspace_member)
    # on enregistre les fichier sur le disque et on change les droit réaliser une analyse
    file = params[:sc_model][:file]
    logger.debug file.size()
    self.dimension = params[:sc_model][:dimension]
    self.units = params[:sc_model][:units]
    result = ''
    self.original_filename = file.original_filename
    name = self.original_filename
    
    to_decomp = 0
    extension = ""
    if name.match(/.bz2/)
      extension = ".bz2"
      self.change_state('to_decompress')
      to_decomp = 1
    elsif name.match(/.gz/)
      extension = ".gz"
      self.change_state('to_decompress')
      to_decomp = 1
    elsif name.match(/.zip/)
      extension = ".zip"
      self.change_state('to_decompress')
      to_decomp = 1
    elsif name.match(/.tgz/)
      extension = ".tgz"
      self.change_state('to_decompress')
      to_decomp = 1
    elsif name.match(/.iges/) or name.match(/.igs/)
      extension = ".iges"
      self.change_state('to_salome')
    elsif name.match(/.step/) or name.match(/.stp/)
      extension = ".step"
      self.change_state('to_salome')
    elsif name.match(/.bdf/)
      extension = ".bdf"
      self.change_state('to_create')
    elsif name.match(/.avs/)
      extension = ".avs"
      self.change_state('to_create')
    elsif name.match(/.unv/)
      extension = ".unv"
      self.change_state('to_create')
    else
      results = "type de fichier de maillage non reconnu"
      return results
    end

    path_to_model = "#{SC_MODEL_ROOT}/model_#{self.id}"
    path_to_mesh = "#{SC_MODEL_ROOT}/model_#{self.id}/MESH"
    Dir.mkdir(path_to_model, 0777) unless File.exists?(path_to_model)
    Dir.mkdir(path_to_mesh, 0777) unless File.exists?(path_to_mesh)
    
    logger.debug path_to_mesh
    logger.debug extension
    if to_decomp == 1
       path_to_file = path_to_mesh + "/"+ name
    else
       path_to_file = path_to_mesh + "/mesh" + extension
    end
    File.chmod 0777, path_to_model
    File.chmod 0777, path_to_mesh
    
    self.change_state('void')
    File.open(path_to_file, 'w+') do |f|
        if f.write(file.read) 
          self.change_state('to_analyse')
        end
    end
    self.save
    
    # analyse et création du log_tools_scult
    @nb_token = self.mesh_file_analysis
    @log_tool_scult = []
    if log_tool_scult = self.log_tools.find(:last)
      if log_tool_scult.pending?
        @log_tool_scult = log_tool_scult
      else
        @log_tool_scult = self.log_tools.build()
      end
    else
      @log_tool_scult = self.log_tools.build()
    end
    @log_tool_scult.token_account = self.workspace.token_account
    @log_tool_scult.log_type = "scult"
    @log_tool_scult.state = "pending"
    @log_tool_scult.nb_token = @nb_token
    @log_tool_scult.cpu_allocated = 1
    @log_tool_scult.workspace_member = current_workspace_member
    @log_tool_scult.pending()
    @log_tool_scult.save
    
    # on retourne le resultats
    return true
  end
  
  def create_mesh(current_workspace_member, current_log_tool_scult)
    # on enregistre les fichier sur le disque et on change les droit pour que le serveur de calcul y ai acces
    result = ''
    name = self.original_filename
    to_decomp = 0
    if name.match(/.bz2/)
      extension = ".bz2"
      self.change_state('to_decompress')
      to_decomp = 1
    elsif name.match(/.gz/)
      extension = ".gz"
      self.change_state('to_decompress')
      to_decomp = 1
    elsif name.match(/.zip/)
      extension = ".zip"
      self.change_state('to_decompress')
      to_decomp = 1
    elsif name.match(/.tgz/)
      extension = ".tgz"
      self.change_state('to_decompress')
      to_decomp = 1
    elsif name.match(/.iges/) or name.match(/.igs/)
      extension = ".iges"
      self.change_state('to_salome')
    elsif name.match(/.step/) or name.match(/.stp/)
      extension = ".step"
      self.change_state('to_salome')
    elsif name.match(/.bdf/)
      extension = ".bdf"
      self.change_state('to_create')
    elsif name.match(/.avs/)
      extension = ".avs"
      self.change_state('to_create')
    elsif name.match(/.unv/)
      extension = ".unv"
      self.change_state('to_create')
    else
      results = "type de fichier de maillage non reconnu"
      return results
    end
    
    path_to_model = "#{SC_MODEL_ROOT}/model_#{self.id}"
    path_to_mesh = "#{SC_MODEL_ROOT}/model_#{self.id}/MESH"
    # création du fichier json_model 
    identite_calcul = { :id_workspace => self.workspace_id, :id_user => current_workspace_member.user_id, :id_projet => '', :id_model => self.id, :id_calcul => '', :dimension  => self.dimension};
    priorite_calcul = { :priorite => 0 };                               
    mesh = { :mesh_directory => "MESH", :mesh_name  => "mesh", :extension  => extension};
    json_model = { :identite_calcul => identite_calcul, :priorite_calcul => priorite_calcul, :mesh => mesh}; 
    
    # enregistrement sur le disque
    path_to_json_model = path_to_mesh + "/model_id.json"
    File.open(path_to_json_model, 'w+') do |f|
        f.write(JSON.pretty_generate(json_model))
    end
    
    current_log_tool_scult.state = self.state
    current_log_tool_scult.ready()
    current_log_tool_scult.save
    current_log_tool_scult.reserve_token()
    
    results = "Demande de dépot envoyée"
    self.save
    
    # on retourne le resultats
    return results
    
  end
  
  def void_state()
    # on enregistre les fichier sur le disque et on change les droit pour que le serveur de calcul y ai acces
    self.state
    void = false
    if self.state == "void" or self.state == "echec"
      void = true
    else
      void = false
    end
    return void
  end
  
  def valid_state()
    # on enregistre les fichier sur le disque et on change les droit pour que le serveur de calcul y ai acces
    self.state
    void = false
    if self.state == "in_process" or self.state == "to_create" or self.state == "to_decomp" or self.state == "to_decompress" or self.state == "to_salome" or self.state == "active"
      void = true
    else
      void = false
    end
    return void
  end
  
  def mesh_valid()
    path_to_file = "#{SC_MODEL_ROOT}/model_#{self.id}/MESH/mesh.txt"
    results = File.read(path_to_file)
    jsonobject = JSON.parse(results)
    
    #mise à jour des infos modèle
    self.parts = jsonobject[0]['mesh']['nb_groups_elem']
    self.interfaces = jsonobject[0]['mesh']['nb_groups_inter']
    self.sst_number = jsonobject[0]['mesh']['nb_sst']
    self.change_state('active')
    self.save 
  end
  
  def send_file(params,current_workspace_member)
    # on enregistre les fichier sur le disque et on change les droit pour que le serveur de calcul y ai acces
    file = params[:file] 
    name = file.original_filename
    
    path_to_sc_model = "#{SC_MODEL_ROOT}/model_#{self.id}"
    path_to_dir_file = "#{SC_MODEL_ROOT}/model_#{self.id}/FILE"
    Dir.mkdir(path_to_sc_model, 0777) unless File.exists?(path_to_sc_model)
    Dir.mkdir(path_to_dir_file, 0777) unless File.exists?(path_to_dir_file)
    path_to_file = path_to_dir_file + '/' + name
    File.chmod 0777, path_to_sc_model
    File.chmod 0777, path_to_dir_file
    
    File.open(path_to_file, 'w+') do |f|
        f.write(file.read)
    end
    
    self.files_sc_models.create(:name => name, :user_id => current_workspace_member.id, :state =>'uploaded', :size => File.stat(path_to_file).size)
    self.save
    
    # on retourne le resultats
    return results
  end

  def self.save_mesh_file(upload)
    name        =  upload['upload'].original_filename
    directory   = "public/test"
    # create the file path
    path        = File.join(directory, name)
    # write the file
    File.open(path, "wb") { |f| f.write(upload['datafile'].read) }
  end

  def mesh_file_analysis
    dirsize =0
    path_to_sc_model = "#{SC_MODEL_ROOT}/model_#{self.id}/MESH"
    Find.find(path_to_sc_model) do |f| 
      dirsize += File.stat(f).size 
    end 
    self.used_memory = dirsize
    nb_token = (dirsize/10000000).ceil+1
    return nb_token
  end
  
  
  def delete_mesh
    path_to_sc_model = "#{SC_MODEL_ROOT}/model_#{self.id}/MESH/mesh"
    logger.debug path_to_sc_model
    #     Dir["#{File.dirname(path_to_sc_model)}/*"].each do |file|
    #       logger.debug file
    #       next if File.basename(file) == File.basename(path_to_sc_model)
    #       FileUtils.rm_rf file, :noop => true, :verbose => true
    #     end
    self.state = "void"
    self.save
  end
  
  
  def request_mesh_analysis
    # TODO: Ecrire l'objet CalculatorInterface qui appellera la bonne ligne de commande (entre autre) dans une lib.
    nb_token = CalculatorInterface.delay.analyse_mesh_for_model self
    return nb_token
    # A ce stade la demande est placee dans la file des demande en attente.
  end
  
  def delete_model()
    self.users.clear
    self.change_state('deleted')
    self.deleted_at = Time.now
    #self.used_memory = 0
    self.save
  end
  
   def change_state(state)
    self.state = state
    self.save
  end
  
end

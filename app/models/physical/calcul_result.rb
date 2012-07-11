class CalculResult < ActiveRecord::Base
  require 'find'
  require 'json'
  require 'socket'
  require 'fileutils'
  

  
  include Socket::Constants
  
  belongs_to  :user         # utilisateur ayant lance le calcul
  belongs_to  :workspace_member, :class_name => "UserWorkspaceMembership", :foreign_key => "workspace_member_id"
  belongs_to  :sc_model
  has_one     :log_tool
  has_one     :solde_token_account
  
  before_destroy :delete_calcul
  
  #state = ['temp', 'in_process', 'finish','downloaded']
  #log_type = ['create', 'compute']
  
  def send_calcul(current_workspace_member, current_log_tool_scills) #enregistrement du fichier calcul et envoie du calcul
    self.change_state('uploaded') 
    self.save
    current_log_tool_scills.state = self.state
    current_log_tool_scills.ready()
    current_log_tool_scills.save
    current_log_tool_scills.reserve_token()
  end
  
  def save_new_brouillon(params)
    path_to_file = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}/MESH/mesh_v2.txt"
    results      = File.read(path_to_file)
    jsonobject   = JSON.parse(results)
    jsonobject["sc_model_id"]                = params["sc_model_id"].to_i
    jsonobject["time_steps"]                 = params["time_steps"]
    jsonobject["multiresolution_parameters"] = params["multiresolution_parameters"]
    save_brouillon(jsonobject)
  end
  
  def duplicate_brouillon(params)
    path_to_file = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}/calcul_#{params[:id]}/results/calcul.txt"
    results      = File.read(path_to_file)
    jsonobject   = JSON.parse(results)
    save_brouillon(jsonobject)
  end

  def save_brouillon(params) #enregistrement du fichier brouillon
    jsonobject = JSON.parse(params.to_json)
    file = JSON.pretty_generate(jsonobject)
    #file = params.to_json
    # on enregistre le fichier sur le disque et on change les droit pour que le serveur de calcul y ait acces
    path_to_model = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}"
    path_to_calcul = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}/calcul_#{self.id}"
    path_to_result = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}/calcul_#{self.id}/results"
 
    Dir.mkdir(path_to_model, 0777) unless File.exists?(path_to_model)
    Dir.mkdir(path_to_calcul, 0777) unless File.exists?(path_to_calcul)
    Dir.mkdir(path_to_result, 0777) unless File.exists?(path_to_result)
    File.chmod 0777, path_to_calcul
    File.chmod 0777, path_to_result
    
    path_to_file = path_to_result + "/calcul.txt"
    
    File.open(path_to_file, 'w+') do |f|
        f.write(file)
    end
    File.chmod 0777, path_to_file
    
    results = "brouillon sauvegardé"
    return results
  end
  
  def load_brouillon_from_ext_file(params,current_workspace_member) # verification et enregistrement du brouillon envoyé par l'utilisateur
    file = params[:file]
    path_to_mesh = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}/MESH/mesh.txt"
    mesh = File.read(path_to_mesh)
    jsonmesh = JSON.parse(mesh)
    jsonmesh = jsonmesh[0]
    jsonbrouillon = JSON.parse(file.read)
    
    results = false
    #verification
    if (jsonbrouillon['mesh']['nb_sst'] == jsonmesh['mesh']['nb_sst'] && jsonbrouillon['mesh']['nb_inter'] == jsonmesh['mesh']['nb_inter'] && jsonbrouillon['mesh']['nb_groups_elem'] == jsonmesh['mesh']['nb_groups_elem'] && jsonbrouillon['mesh']['nb_groups_inter'] == jsonmesh['mesh']['nb_groups_inter'])
      results = true
    end
    
    #enregistrement
    if results
      file_save           = JSON.pretty_generate(jsonbrouillon)
      self.save 
      self.workspace_member = current_workspace_member
      self.name           = "brouillon_#{self.id}"
      self.save
      
      # on enregistre le fichier sur le disque et on change les droit pour que le serveur de calcul y ait acces
      path_to_model = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}"
      path_to_calcul = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}/calcul_#{self.id}"
  
      Dir.mkdir(path_to_model, 0777) unless File.exists?(path_to_model)
      Dir.mkdir(path_to_calcul, 0777) unless File.exists?(path_to_calcul)
      File.chmod 0777, path_to_calcul
      
      path_to_file = path_to_calcul + "/calcul.txt"
      
      File.open(path_to_file, 'w+') do |f|
          f.write(file_save)
      end
      File.chmod 0777, path_to_file
    end

    return results
  end
  
  def get_brouillon(params,current_workspace_member) # lecture du fichier brouillon sur le disque
    path_to_file = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}/calcul_#{self.id}/results/calcul.txt"
    results = File.read(path_to_file)
    jsonobject = JSON.parse(results)
    

    # if(self.state == 'temp') 	#si on prend le brouillon d'un calcul non effectué
#       self.description = params[:description]
#       self.save
#       send_data  = {:calcul => self, :brouillon => jsonobject}
#     else			#si on prend le brouillon d'un calcul effectué
#       @new_calcul = self.sc_model.calcul_results.create(
#         :name => params[:name],
#         :description => params[:description],
#         :state => 'temp',
#         :ctype =>params[:ctype],
#         :D2type => params[:D2type],
#         :log_type => 'compute'
#       )
#       @new_calcul.user = current_workspace_member
#       if (@new_calcul.name == self.name)
#         @new_calcul.name = "brouillon_#{@new_calcul.id}" 
#       end
#       @new_calcul.save
#       send_data  = {:calcul => @new_calcul, :brouillon => jsonobject}
#     end
    
    return jsonobject 
  end
  
  def compute_forcast(current_workspace_member) # calcul des prevision de temps de calcul et autorisation de calcul
    # récupération du brouillon
    path_to_file = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}/calcul_#{self.id}/results/calcul.txt"
    results = File.read(path_to_file)
    jsonobject = JSON.parse(results)
    #logger.debug results
    
    #calcul des prévisions
    
    
    #calcul du nombre de pas de temps
    nb_steps = jsonobject['time_steps']['collection'].length
    nb_pdt = 0
    logger.debug "nb_steps = " + nb_steps.to_s
    for i in 0..nb_steps-1
      logger.debug i
      nb_pdt += jsonobject['time_steps']['collection'][i]["nb_time_steps"]
    end
    logger.debug "nb_steps = " + nb_pdt.to_s
    
    #calcul du nombre de résolutions
    nb_resolution = jsonobject['multiresolution_parameters']['resolution_number']
    logger.debug "nb_resolution = " + nb_resolution.to_s
    
    #correction si on est en statique ou sans multiresolution
    nb_pdt = 1 if jsonobject['time_steps']['time_scheme'] == "static"
    nb_resolution = 1 if jsonobject['multiresolution_parameters']['multiresolution_type'] == "off"
    logger.debug "nb_resolution = " + nb_resolution.to_s
    logger.debug "nb_steps = " + nb_pdt.to_s
    
    nb_resolution = nb_resolution.to_s.to_i
    
    #autres grandeur utils
    sst_number = jsonobject['mesh']['nb_sst'].to_i
    ddl_number = jsonobject['mesh']['nb_ddl'].to_i
    max_iteration = jsonobject['options']['convergence_method_LATIN']['max_iteration'].to_i
    
    @estimated_calcul_points = self.sc_model.dimension * self.sc_model.dimension * ddl_number * max_iteration * nb_pdt * nb_resolution
    @estimated_load_data = @estimated_calcul_points / (nb_pdt * nb_resolution)
    @estimated_save_data = @estimated_calcul_points / (nb_pdt * nb_resolution)
    logger.debug "estimated_calcul_points = " + @estimated_calcul_points.to_s
    #self.gpu_allocated = (self.sc_model.dimension * self.sc_model.dimension * sst_number * 0.001).ceil
    self.gpu_allocated = 1
    if(jsonobject['mesh']['nb_groups_elem'] > 8)
      self.gpu_allocated = 3
    end
    
    if(jsonobject['options']['mode'] == "test")
      self.gpu_allocated = 1
    end
    
    self.estimated_calcul_time = @estimated_load_data * 0.000001 + (@estimated_calcul_points + @estimated_save_data) * 0.000001 / self.gpu_allocated
    self.save
    
    # analyse et création du log_tools_scult
    @nb_token = ((self.estimated_calcul_time * self.gpu_allocated)/30).ceil+1
    @log_tool_scills = []
    if log_tool_scills = self.log_tool
      @log_tool_scills = log_tool_scills
    else
      @log_tool_scills = self.build_log_tool()
    end
    @log_tool_scills.sc_model = self.sc_model
    @log_tool_scills.token_account = self.sc_model.workspace.token_account
    @log_tool_scills.log_type = "scills"
    @log_tool_scills.state = "pending"
    @log_tool_scills.estimated_time = self.estimated_calcul_time
    @log_tool_scills.nb_token = @nb_token
    @log_tool_scills.cpu_allocated = self.gpu_allocated
    @log_tool_scills.workspace_member = current_workspace_member
    @log_tool_scills.pending()
    @log_tool_scills.save
    @log_tool_scills.get_launch_autorisation()
    # on retourne le resultats
    return @log_tool_scills
  end
  
  def calcul_in_process()  
    self.change_state('in_process')
  end
  
  def calcul_valid(params) 
    calcul_time = params[:time]
    calcul_state = Integer(params[:state])
    #mise à jour du résultat de calcul
    self.calcul_time = calcul_time
    self.result_date = Time.now 
    self.change_state('finish')
  end
  
  def calcul_echec(params) 
    calcul_time = params[:time]
    calcul_state = Integer(params[:state])
    #mise à jour du résultat de calcul
    self.calcul_time = calcul_time
    self.result_date = Time.now 
    self.change_state('echec')
  end
  
  def get_used_memory()
    dirsize =0
    if(self.ctype == 'create')
      path_to_calcul = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}/MESH"
    else
      path_to_calcul = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}/calcul_#{self.id}"
    end
    Find.find(path_to_calcul) do |f| 
      dirsize += File.stat(f).size 
    end 
    self.used_memory = dirsize/100
    self.save
    self.sc_model.get_used_memory()
  end
  
  def test_delete?
    value_to_return = true
    #if(self.state == 'finish' || self.state == 'in_process')
    if(self.state == 'finish') # || self.state == 'in_process')
        value_to_return = false
    end
    return value_to_return
  end
  
  def delete_calcul()
    if !self.log_tool.nil? and self.log_tool.ready?
      raise ActiveRecord::RecordInvalid
      return false
    else
      self.change_state('deleted')
      self.log_tool.deleted() unless self.log_tool.nil?
      self.updated_at = Time.now
      path_to_calcul = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}/calcul_#{self.id}"
      FileUtils.rm_rf path_to_calcul
      self.save
      return true
    end
  end
  
  def change_state(state)
    #mise à jour dde l'état du calcul_result
    #state = ['temp', 'in_process', 'finish','downloaded','failed','uploaded']
    self.state = state
    self.save
  end
  
end

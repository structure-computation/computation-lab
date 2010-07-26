class CalculResult < ActiveRecord::Base
  require 'find'
  require 'json'
  require 'socket'
  include Socket::Constants
  
  belongs_to  :user         # utilisateur ayant lance le calcul
  belongs_to  :sc_model
  has_one     :log_calcul
  
  #state = ['temp', 'in_process', 'finish','downloaded']
  #log_type = ['create', 'compute']
  
  def send_calcul(params) #enregistrement du fichier calcul et envoie du calcul
    jsonobject = JSON.parse(params[:file])
    file = JSON.pretty_generate(jsonobject)
    
    # on enregistre le fichier sur le disque et on change les droit pour que le serveur de calcul y ait acces
    path_to_model = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}"
    path_to_calcul = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}/calcul_#{self.id}"
 
    Dir.mkdir(path_to_model, 0777) unless File.exists?(path_to_model)
    Dir.mkdir(path_to_calcul, 0777) unless File.exists?(path_to_calcul)

    path_to_file = path_to_calcul + "/calcul.json"
    File.open(path_to_file, 'w+') do |f|
        f.write(file)
    end
    File.chmod 0777, path_to_calcul
    
    # création des elements a envoyer au calculateur
    send_data  = { :id_model => self.sc_model.id, :id_calcul => self.id, :dimension => self.sc_model.dimension , :mode => "compute"}
    
    # socket d'envoie au serveur
    socket    = Socket.new( AF_INET, SOCK_STREAM, 0 )
    sockaddr  = Socket.pack_sockaddr_in( SC_CALCUL_PORT, SC_CALCUL_SERVER ) #variables d'environnement
    socket.connect( sockaddr )
    socket.write( send_data.to_json )
    
    # reponse du calculateur
    results = socket.read
    self.change_state('in_process') 
    self.save
    return results
  end

  def save_brouillon(params) #enregistrement du fichier brouillon
    jsonobject = JSON.parse(params[:file])
    file = JSON.pretty_generate(jsonobject)
    
    # on enregistre le fichier sur le disque et on change les droit pour que le serveur de calcul y ait acces
    path_to_model = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}"
    path_to_calcul = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}/calcul_#{self.id}"
 
    Dir.mkdir(path_to_model, 0777) unless File.exists?(path_to_model)
    Dir.mkdir(path_to_calcul, 0777) unless File.exists?(path_to_calcul)

    path_to_file = path_to_calcul + "/brouillon.json"
    File.open(path_to_file, 'w+') do |f|
        f.write(file)
    end
    File.chmod 0777, path_to_calcul
    
    results = "brouillon sauvegardé"
    return results
  end
  
  def get_brouillon(params,current_user) # lecture du fichier brouillon sur le disque
    path_to_file = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}/calcul_#{self.id}/brouillon.json"
    results = File.read(path_to_file)
    jsonobject = JSON.parse(results)
    
    if(self.state == 'temp') 	#si on prend le brouillon d'un calcul non effectué
      send_data  = {:calcul => self, :brouillon => jsonobject}
    else			#si on prend le brouillon d'un calcul effectué
      @new_calcul = self.sc_model.calcul_results.create(:name => params[:name], :description => params[:description], :state => 'temp', :ctype =>params[:ctype], :D2type => params[:D2type], :log_type => 'compute')
      @new_calcul.user = current_user
      if (@new_calcul.name == self.name)
	@new_calcul.name = "brouillon_#{@new_calcul.id}" 
      end
      @new_calcul.save
      send_data  = {:calcul => @new_calcul, :brouillon => jsonobject}
    end
    
    return send_data 
  end
  
  def compute_previsions() # calcul des prevision de temps de calcul et autorisation de calcul
    # récupération du brouillon
    path_to_file = "#{SC_MODEL_ROOT}/model_#{self.sc_model.id}/calcul_#{self.id}/brouillon.json"
    results = File.read(path_to_file)
    jsonobject = JSON.parse(results)
    
    #calcul des prévisions
    @estimated_calcul_points = self.sc_model.dimension * self.sc_model.dimension * self.sc_model.sst_number * jsonobject['options']['LATIN_nb_iter'] * jsonobject['time_step'].length 
    self.gpu_allocated = (self.sc_model.dimension * self.sc_model.dimension * self.sc_model.sst_number * 0.00001).ceil
    self.estimated_calcul_time = @estimated_calcul_points * 0.00001
    @estimated_debit_jeton = ((self.estimated_calcul_time * self.gpu_allocated)/15).ceil+1
        
    #autorisation de calcul
    @solde_jeton = self.sc_model.company.calcul_account.solde_jeton
    @solde_jeton_tempon = self.sc_model.company.calcul_account.solde_jeton_tempon
    self.launch_autorisation = false
    if(@solde_jeton == 0) 			#si il n'y a plus de jetons
      self.launch_autorisation = false
    elsif(@estimated_debit_jeton > @solde_jeton)
      temp_rest_jeton = @estimated_debit_jeton - @solde_jeton
      if(temp_rest_jeton > @solde_jeton_tempon) #si il n'y a plus assez de jetons tempons
        self.launch_autorisation = false
      else					#si il y a assez de jetons tempons
        self.launch_autorisation = true
      end
    else					#si il y a assez de jetons
      self.launch_autorisation = true
    end
    self.save
    
    send_data  = {:launch_autorisation => self.launch_autorisation, :gpu_allocated => self.gpu_allocated, :estimated_calcul_time => self.estimated_calcul_time, :estimated_debit_jeton => @estimated_debit_jeton}
    
    return send_data 
  end
  
  def calcul_valid(calcul_time) 
    #mise à jour du résultat de calcul
    self.calcul_time = calcul_time
    self.result_date = Time.now
    self.gpu_allocated = 1
    self.name = "calcul_#{self.id}" 
    
    self.change_state('finish')
    self.get_used_memory()
    #self.save
    
    #mise à jour du compte de calcul
    self.sc_model.company.calcul_account.log_calcul(self.id)
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
    self.used_memory = dirsize
    self.save
    self.sc_model.get_used_memory()
  end
  
  def change_state(state)
    #mise à jour dde l'état du calcul_result
    #state = ['temp', 'in_process', 'finish','downloaded','failed','uploaded']
    self.state = state
    #self.save
  end
  
end

class ScModel < ActiveRecord::Base
  require 'json'
  
  belongs_to  :company
  belongs_to  :project
  
  has_many    :user_sc_models  
  has_many    :users    ,  :through => :user_sc_models
  
  has_many    :calcul_results
  has_many    :forum_sc_models
  
  def has_result? 
    return (rand(1) > 0.5)
  end
  
  def mesh_valid(id_user,calcul_time,json)
    current_user = User.find(id_user)
    jsonobject = JSON.parse(json)
    
    #mise à jour des infos modèle
    self.parts = jsonobject[0]['mesh']['nb_groups_elem']
    self.interfaces = jsonobject[0]['mesh']['nb_groups_inter']
    self.state = 'active'
    self.save
    
    #mise à jour du résultat de calcul
    @calcul_result = self.calcul_results.build(:calcul_time => calcul_time, :ctype => 'create', :state => 'finish', :gpu_allocated => 1) 
    @calcul_result.user = current_user
    @calcul_result.result_date = Time.now
    @calcul_result.save
    
    #mise à jour du compte de calcul
    self.company.calcul_account.log_model(@calcul_result.id)
    
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
  
  
end

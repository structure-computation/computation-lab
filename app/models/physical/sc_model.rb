class ScModel < ActiveRecord::Base
  
  belongs_to  :company
  belongs_to  :project
  
  has_many    :user_sc_models  
  has_many    :users    ,  :through => :user_sc_models
  
  has_many    :calcul_results
  #has_many    :log_calcul ,  :through => :calcul_results
  
  has_many    :forum_sc_models
  
  def has_result? 
    return (rand(1) > 0.5)
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

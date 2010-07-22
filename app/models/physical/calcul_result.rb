class CalculResult < ActiveRecord::Base
  require 'find'
  
  belongs_to  :user         # utilisateur ayant lance le calcul
  belongs_to  :sc_model
  has_one     :log_calcul
  
  #state = ['temp', 'in_process', 'finish','downloaded']
  #log_type = ['create', 'compute']
  
  def calcul_valid(calcul_time) 
    #mise à jour du résultat de calcul
    self.calcul_time = calcul_time
    self.state = 'finish'
    self.result_date = Time.now
    self.gpu_allocated = 1
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
  
end

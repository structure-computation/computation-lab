class CalculResult < ActiveRecord::Base
  
  belongs_to  :user         # utilisateur ayant lance le calcul
  belongs_to  :sc_model
  has_one     :log_calcul
  
  def calcul_valid(calcul_time) 
    #mise à jour du résultat de calcul
    self.calcul_time = calcul_time
    self.state = 'finish'
    self.result_date = Time.now
    self.gpu_allocated = 1
    self.save
    
    #mise à jour du compte de calcul
    self.sc_model.company.calcul_account.log_calcul(self.id)
  end
end

class MemoryAccount < ActiveRecord::Base
  
  belongs_to :company
  has_many   :log_abonnements
  
  
  # nouvel abonnement sur ce compte
  def add_abonnement(id_abonnement)
    abonnement = Abonnement.find(id_abonnement)
    
    #construction de la ligne de log_abonnement
    current_log_abonnement = self.log_abonnements.build()
    current_log_abonnement.abonnement = abonnement
    current_log_abonnement.assigned_memory = abonnement.assigned_memory
    current_log_abonnement.price = abonnement.price
    current_log_abonnement.abonnement_date = Date.today 
    
    #mise a jour des info du compte 
    self.end_date = Date.today + 1.year
    self.assigned_memory = abonnement.assigned_memory
    self.status = 'active'  
    
    #derniere mise a jour des info du compte et sauvegarde
    current_log_abonnement.save
    self.save
  end
  
end

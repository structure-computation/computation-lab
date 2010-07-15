class MemoryAccount < ActiveRecord::Base
  
  belongs_to :company
  has_many   :log_abonnements
  
  # initialisation d'un nouveau compte lors de la création d'une nouvelle company
  def init()
    self.assigned_memory = 0
    self.status = 'pause'
    self.inscription_date = Date.today
    self.used_memory = 0
    self.save
  end
  
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
  
  def get_used_memory()
    used_memory = 0
    list_sc_models = self.company.sc_models.find(:all, :conditions => {:state => "active"})
    list_sc_models.each{ |model_i|
       used_memory += (model_i.used_memory/10000)*0.01          
    }
    self.used_memory = used_memory
    self.save
  end
  
end

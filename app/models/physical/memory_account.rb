# encoding: utf-8

class MemoryAccount < ActiveRecord::Base
  
  belongs_to :workspace
  has_many   :log_abonnements
  
  # initialisation d'un nouveau compte lors de la création d'une nouvelle workspace
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
    current_log_abonnement.new_log_abonnement_and_facture(id_abonnement)
  end
  
  # valider l'abonnement sur ce compte
  def valid_log_abonnement(id_log_abonnement)
    current_log_abonnement = self.log_abonnements.find(id_log_abonnement)
    abonnement = current_log_abonnement.abonnement
    
    #mise a jour des info du compte 
    self.end_date = Date.today + 1.year
    self.assigned_memory = abonnement.assigned_memory
    self.status = 'active'  
    
    #derniere mise a jour des info du compte et sauvegarde
    self.save
  end
  
  def get_used_memory()
    used_memory = 0
    list_sc_models = self.workspace.sc_models.find(:all, :conditions => {:state => "active"})
    list_sc_models.each{ |model_i|
       used_memory += (model_i.used_memory/10000)*0.01          
    }
    self.used_memory = used_memory
    self.save
  end
  
end

# encoding: utf-8

class LogAbonnement < ActiveRecord::Base
  belongs_to :memory_account
  belongs_to :abonnement
  has_one    :workspace ,  :through => :memory_account
  has_one    :facture
  
  # nouvelle ligne de log_abonnement et nouvelle facture non validé
  def new_log_abonnement_and_facture(id_abonnement)
     abonnement = Abonnement.find(id_abonnement)
    
    #initialisation de la ligne de credit
    self.abonnement = abonnement
    self.assigned_memory = abonnement.assigned_memory
    self.price = abonnement.price
    self.abonnement_date = Date.today 
    
    #création de la facture
    current_facture = self.build_facture() 
    current_facture.workspace = self.memory_account.workspace
    current_facture.save
    
    #derniere mise a jour des info du compte et sauvegarde
    self.save
    current_facture.new_facture_memoire()
  end
  
  # validation de la ligne de log_abonnement et sauvegarde du compte après paiement de la facture
  def valid_log_abonnement_and_memory_account()
    self.abonnement_date = Date.today
    self.save
    self.memory_account.valid_log_abonnement(self.id)
  end
  
end

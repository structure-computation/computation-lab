class Facture < ActiveRecord::Base
  belongs_to :company
  belongs_to :credit
  belongs_to :log_abonnement
  
  
  # nouvelle facture associée à une ligne de crédit calcul
  def new_facture_calcul()
    self.facture_type = "calcul"
    self.statut = "unpaid"
    self.ref = Date.today.to_s() + "-" + self.id.to_s()  
    self.price_calcul_HT = self.credit.price
    self.price_calcul_TVA = self.price_calcul_HT * 0.196
    self.price_calcul_TTC = self.price_calcul_HT + self.price_calcul_TVA

    self.price_memory_HT = 0
    self.price_memory_TVA = 0
    self.price_memory_TTC = self.price_memory_HT + self.price_memory_TVA
    
    self.total_price_HT = self.price_calcul_HT + self.price_memory_HT
    self.total_price_TVA = self.price_calcul_TVA + self.price_memory_TVA
    self.total_price_TTC = self.total_price_HT + self.total_price_TVA
    
    #derniere mise a jour des info du compte et sauvegarde
    self.save
  end
  
  # nouvelle facture associée à une ligne de log_memoire
  def new_facture_memoire()
    self.facture_type = "memoire"
    self.statut = "unpaid"
    self.ref = Date.today.to_s() + "-" + self.id.to_s()  
    self.price_calcul_HT = 0
    self.price_calcul_TVA = 0
    self.price_calcul_TTC = self.price_calcul_HT + self.price_calcul_TVA

    self.price_memory_HT = self.log_abonnement.price
    self.price_memory_TVA = self.price_memory_HT * 0.196
    self.price_memory_TTC = self.price_memory_HT + self.price_memory_TVA
    
    self.total_price_HT = self.price_calcul_HT + self.price_memory_HT
    self.total_price_TVA = self.price_calcul_TVA + self.price_memory_TVA
    self.total_price_TTC = self.total_price_HT + self.total_price_TVA
    
    #derniere mise a jour des info du compte et sauvegarde
    self.save
  end
  
  def valid_facture_calcul()
    self.statut = "paid"
    self.paid_date = Date.today
    self.save
    self.credit.valid_credit_and_calcul_account()
  end
  
  def valid_facture_memoire()
    self.statut = "paid"
    self.paid_date = Date.today
    self.save
    self.log_abonnement.valid_log_abonnement_and_memory_account()
  end
  
  def valid_facture()
    if(self.facture_type == "calcul")
      valid_facture_calcul()
    elsif(self.facture_type == "memoire")
      valid_facture_memoire()
    end
  end
  
end

class CalculAccount < ActiveRecord::Base
  
  belongs_to :company
  has_many   :log_calculs
  has_many   :solde_calcul_accounts
  has_many   :credits

  # initialisation d'un nouveau compte lors de la création d'une nouvelle company
  def init()
    self.report_jeton = 0
    self.base_jeton = 0
    self.base_jeton_tempon = 0
    self.used_jeton = 0
    self.used_jeton_tempon = 0
    self.solde_jeton = 0
    self.solde_jeton_tempon = 0
    self.status = 'pause'
    self.save
  end
  
  # nouveau forfait sur ce compte
  def add_forfait(id_forfait)
    forfait = Forfait.find(id_forfait)
    
    #construction de la ligne de credit
    current_credit = self.credits.build()
    current_credit.new_credit_and_facture(id_forfait)
  end
  
   # validation du credit après paiement de la facture
  def valid_credit(id_credit)
    current_credit = self.credits.find(id_credit)
    forfait = current_credit.forfait
    
    #mise a jour des info du compte
    self.start_date = Date.today 
    self.end_date = Date.today + forfait.validity.month
    self.report_jeton = self.solde_jeton + self.solde_jeton_tempon
    self.base_jeton = forfait.nb_jetons
    self.base_jeton_tempon = forfait.nb_jetons_tempon
    self.used_jeton = 0
    self.used_jeton_tempon = 0

    #mise à jour du solde_calcul_accounts
    current_solde = self.solde_calcul_accounts.build()
    current_solde.credit = current_credit
    current_solde.solde_type = 'achat'
    current_solde.credit_jeton = current_credit.nb_jetons
    current_solde.credit_jeton_tempon = current_credit.nb_jetons_tempon
    current_solde.debit_jeton = 0
    current_solde.debit_jeton_tempon = 0
    current_solde.solde_jeton = self.solde_jeton + current_credit.nb_jetons + self.solde_jeton_tempon
    current_solde.solde_jeton_tempon = current_credit.nb_jetons_tempon
    
    
    #derniere mise a jour des info du compte et sauvegarde
    self.solde_jeton = current_solde.solde_jeton
    self.solde_jeton_tempon = current_solde.solde_jeton_tempon
    self.status = 'active'
    current_solde.save
    self.save
  end
  
   # nouveau dépot de modèle sur ce compte
  def log_model(id_calcul_result)
    #reprise du calcul_result
    current_calcul_result = CalculResult.find(id_calcul_result)
    
    #construction de la ligne de débit log_calcul
    current_log_calcul = self.log_calculs.build()
    current_log_calcul.calcul_result = current_calcul_result
    current_log_calcul.calcul_time = current_calcul_result.calcul_time
    current_log_calcul.gpu_cards_number = current_calcul_result.gpu_allocated
    current_log_calcul.log_type = 'depot modele'
    current_log_calcul.debit_jeton = ((current_calcul_result.calcul_time * current_calcul_result.gpu_allocated)/15).ceil+5

    #mise à jour du solde_calcul_accounts
    current_solde = self.solde_calcul_accounts.build()
    current_solde.log_calcul = current_log_calcul
    current_solde.solde_type = 'depot modele'
    current_solde.credit_jeton = 0
    current_solde.credit_jeton_tempon = 0
    
    if(current_log_calcul.debit_jeton > self.solde_jeton)
      current_solde.debit_jeton = self.solde_jeton
      temp_rest_jeton = current_log_calcul.debit_jeton - self.solde_jeton
      if(temp_rest_jeton > self.solde_jeton_tempon)
        current_solde.debit_jeton_tempon = self.solde_jeton_tempon
      else
        current_solde.debit_jeton_tempon = temp_rest_jeton
      end
    else
      current_solde.debit_jeton = current_log_calcul.debit_jeton
      current_solde.debit_jeton_tempon = 0
    end
    
    current_solde.solde_jeton = self.solde_jeton - current_solde.debit_jeton
    current_solde.solde_jeton_tempon = self.solde_jeton_tempon - current_solde.debit_jeton_tempon
    
    #mise a jour des info du compte et sauvegarde
    self.used_jeton += current_solde.debit_jeton
    self.used_jeton_tempon += current_solde.debit_jeton_tempon
    self.solde_jeton = current_solde.solde_jeton
    self.solde_jeton_tempon = current_solde.solde_jeton_tempon
    current_solde.save
    current_log_calcul.save
    self.save
  end
  
  # nouveaucalcul fini sur ce compte
  def log_calcul(id_calcul_result, calcul_state)
    #reprise du calcul_result
    current_calcul_result = CalculResult.find(id_calcul_result)
    
    #construction de la ligne de débit log_calcul
    current_log_calcul = self.log_calculs.build()
    current_log_calcul.calcul_result = current_calcul_result
    current_log_calcul.calcul_time = current_calcul_result.calcul_time
    current_log_calcul.gpu_cards_number = current_calcul_result.gpu_allocated
    current_log_calcul.log_type = 'calcul'
    current_log_calcul.debit_jeton = ((current_calcul_result.estimated_calcul_time * current_calcul_result.gpu_allocated)/15).ceil+1

    #mise à jour du solde_calcul_accounts
    current_solde = self.solde_calcul_accounts.build()
    current_solde.log_calcul = current_log_calcul
    current_solde.solde_type = 'calcul_' +  current_calcul_result.id.to_s()
    current_solde.credit_jeton = 0
    current_solde.credit_jeton_tempon = 0
    
    if(calcul_state == 0)
      current_solde.debit_jeton = current_log_calcul.debit_jeton 
      current_solde.debit_jeton_tempon = current_log_calcul.debit_jeton
    else
      current_solde.debit_jeton = 0
      current_solde.debit_jeton_tempon = current_log_calcul.debit_jeton
    end
    
    current_solde.solde_jeton = self.solde_jeton - current_solde.debit_jeton
    current_solde.solde_jeton_tempon = self.solde_jeton_tempon - current_solde.debit_jeton_tempon
    
    #mise a jour des info du compte et sauvegarde
    self.used_jeton += current_solde.debit_jeton + current_solde.debit_jeton_tempon
    self.used_jeton_tempon += 0
    self.solde_jeton = current_solde.solde_jeton
    self.solde_jeton_tempon = current_solde.solde_jeton_tempon
    current_solde.save
    current_log_calcul.save
    self.save
  end
  
  
end

class LogCalcul < ActiveRecord::Base
  
  # Le calcul sur le quel porte ce log
  belongs_to  :calcul_result
  has_one     :sc_model ,  :through => :calcul_result
  has_one     :user     ,  :through => :calcul_result
  
  # Utilisateur ayant lance ce calcul (utilisateur facture)
  belongs_to  :calcul_account
  has_one     :company ,  :through => :calcul_account
  has_one     :solde_calcul_account
end

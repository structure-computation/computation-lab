class LogCalcul < ActiveRecord::Base
  
  # Le calcul sur le quel porte ce log
  belongs_to :calcul_result
  
  # Projet au sein du quel`est "facture" ce log, au sein du quel le calcul a ete lance
  belongs_to :project
  
  # Utilisateur ayant lance ce calcul (utilisateur facture)
  belongs_to :user
end

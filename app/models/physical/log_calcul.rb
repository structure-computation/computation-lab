class LogCalcul < ActiveRecord::Base
  
  # Le calcul sur le quel porte ce log
  belongs_to :calcul_result
  
  # modele dont le dépot du maillage a conduit à ce log
  belongs_to :sc_model
  
  # Utilisateur ayant lance ce calcul (utilisateur facture)
  belongs_to :user
  
  # Utilisateur ayant lance ce calcul (utilisateur facture)
  belongs_to :company
end

class Credit < ActiveRecord::Base
  belongs_to :calcul_account
  belongs_to :forfait
  has_one    :company ,  :through => :calcul_account
  has_one    :solde_calcul_account
  has_one    :facture
  
  
  # nouvelle ligne de crédit et nouvelle facture non validé
  def new_credit_and_facture(id_forfait)
    forfait = Forfait.find(id_forfait)
    
    #initialisation de la ligne de credit
    self.forfait = forfait
    self.nb_jetons = forfait.nb_jetons
    self.nb_jetons_tempon = forfait.nb_jetons_tempon
    self.price = forfait.price 
    
    #création de la facture
    current_facture = self.build_facture() 
    current_facture.company = self.calcul_account.company
    current_facture.save
    
    #derniere mise a jour des info du compte et sauvegarde
    self.save
    current_facture.new_facture_calcul()
  end
  
  # validation de la ligne de credit et sauvegarde du compte après paiement de la facture
  def valid_credit_and_calcul_account()
    self.credit_date = Date.today
    self.save
    self.calcul_account.valid_credit(self.id)
  end
  
end

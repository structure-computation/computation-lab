class Credit < ActiveRecord::Base
  belongs_to :token_account
  belongs_to :forfait
  has_one    :workspace ,  :through => :token_account
  has_one    :solde_token_account
  has_one    :bill
  
  
  # nouvelle ligne de crédit et nouvelle facture non validé
  def new_credit_and_bill(id_forfait)
    forfait = Forfait.find(id_forfait)
    
    #initialisation de la ligne de credit
    self.forfait = forfait
    self.nb_token = forfait.nb_token
    self.token_price = forfait.token_price
    self.global_price = forfait.global_price 
    self.solde_token = forfait.nb_token
    self.used_token = 0
    self.state = "pending"
    
    #création de la facture
    current_bill = self.build_bill() 
    current_bill.workspace = self.token_account.workspace
    current_bill.save
    
    #derniere mise a jour des info du compte et sauvegarde
    self.save
    current_bill.new_token_bill()
  end
  
  # validation de la ligne de credit et sauvegarde du compte après paiement de la facture
  def valid_credit_and_token_account()
    self.state = "active"
    self.end_date = Date.today + self.forfait.validity.month
    self.save
    self.token_account.valid_credit(self.id)
  end
  
end

class TokenAccount < ActiveRecord::Base
  belongs_to :workspace
  has_many   :solde_token_accounts
  has_many   :credits
  
  # initialisation d'un nouveau compte lors de la création d'une nouvelle workspace
  def init()  
    self.status = 'active'
    self.used_token_counter = 0
    self.purchased_token_counter = 0
    self.reserved_token = 0
    self.solde_token = 0
    self.save
  end
  
  def valid_credit(credit_id)
    current_credit = self.credits.find(credit_id)
    #mise a jour des info du compte
    self.purchased_token_counter += current_credit.nb_token
    self.status = 'active'
    self.make_solde()
    
    #mise à jour du solde_calcul_accounts
    current_solde = self.solde_token_accounts.build()
    current_solde.credit = current_credit
    current_solde.solde_type = 'token'
    current_solde.credit_token = current_credit.nb_token
    current_solde.used_token = 0
    current_solde.solde_token = self.solde_token
    current_solde.save
    
    #derniere mise a jour des info du compte et sauvegarde
    logger.debug "self.solde_token : " + self.solde_token.to_s
    logger.debug "solde_token : " + solde_token.to_s
    self.save
  end
  
  def make_solde()
    self.purchased_token_counter = 0
    self.used_token_counter = 0
    self.solde_token = 0
    credits = self.credits.find(:all, :conditions => {:state => "active"})
    credits.each  do |cred|
      self.purchased_token_counter += cred.nb_token
      self.used_token_counter += cred.used_token
      self.solde_token += cred.solde_token
    end
    self.save
    
  end
  
end

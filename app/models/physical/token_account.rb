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
  
end

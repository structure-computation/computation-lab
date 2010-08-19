class LogAbonnement < ActiveRecord::Base
  belongs_to :memory_account
  belongs_to :abonnement
  has_one    :company ,  :through => :memory_account
  has_one    :facture
end

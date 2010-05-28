class Credit < ActiveRecord::Base
  belongs_to :calcul_account
  has_one    :company ,  :through => :calcul_account
  has_one    :solde_calcul_account
end

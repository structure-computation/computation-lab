class CalculAccount < ActiveRecord::Base
  
  belongs_to :company
  has_many   :log_calculs
  has_many   :solde_calcul_accounts
  has_many   :credits

end

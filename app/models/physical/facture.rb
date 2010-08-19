class Facture < ActiveRecord::Base
  belongs_to :company
  belongs_to :credit
  belongs_to :log_abonnement
end

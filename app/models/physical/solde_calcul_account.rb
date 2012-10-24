# encoding: utf-8

class SoldeCalculAccount < ActiveRecord::Base
  belongs_to :calcul_account
  has_one    :workspace ,  :through => :calcul_account
  
  belongs_to :log_calcul
  belongs_to :credit
end

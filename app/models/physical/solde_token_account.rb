# encoding: utf-8

class SoldeTokenAccount < ActiveRecord::Base
  belongs_to :token_account
  has_one    :workspace ,  :through => :token_account
  
  belongs_to :log_tool
  belongs_to :credit
end

class RenameTableFacturesToBills < ActiveRecord::Migration
  def self.up
    rename_table :factures, :bills
  end 
  def self.down
    rename_table :factures, :bills
  end
end

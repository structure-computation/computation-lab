class ChangeDetailsToBills < ActiveRecord::Migration
  def self.up
    remove_column :bills, :log_abonnement_id
    remove_column :bills, :facture_type
    remove_column :bills, :price_calcul_HT
    remove_column :bills, :price_calcul_TVA
    remove_column :bills, :price_calcul_TTC
    remove_column :bills, :price_memory_HT
    remove_column :bills, :price_memory_TVA
    remove_column :bills, :price_memory_TTC
    
    
    add_column :bills, :token_price_HT, :float
    add_column :bills, :global_price_HT, :float
    add_column :bills, :global_price_TVA, :float
    add_column :bills, :global_price_TTC, :float
    add_column :bills, :description, :text
    add_column :bills, :bill_type, :text
  end

  
  def self.down
    remove_column :bills, :token_price_HT
    remove_column :bills, :global_price_HT
    remove_column :bills, :global_price_TVA
    remove_column :bills, :global_price_TTC
    remove_column :bills, :description  
    remove_column :bills, :bill_type  
  end
end

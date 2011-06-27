class CreateFactures < ActiveRecord::Migration
  def self.up
    create_table :factures do |t|
      t.integer :company_id
      t.integer :credit_id
      t.integer :log_abonnement_id
      t.string  :facture_type
      t.float :price_calcul_HT
      t.float :price_calcul_TVA
      t.float :price_calcul_TTC
      t.float :price_memory_HT
      t.float :price_memory_TVA
      t.float :price_memory_TTC
      t.float :total_price_HT
      t.float :total_price_TVA
      t.float :total_price_TTC
      t.string :ref					# reference de la facture = date-id
      t.string :statut                                     # paid ou unpaid
      t.date :paid_date
      t.timestamps
    end
  end

  def self.down
    drop_table :factures
  end
end

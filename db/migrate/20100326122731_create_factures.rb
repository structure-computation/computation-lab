class CreateFactures < ActiveRecord::Migration
  def self.up
    create_table :factures do |t|
      t.integer :company_id
      t.integer :calcul_account_id
      t.integer :memory_account_id
      t.integer :forfait_id
      t.integer :jetons_utilise
      t.integer :jetons_achete
      t.float :total_calcul
      t.float :total_memory
      t.float :total
      t.bool :type_calcul
      t.bool :type_memory
      t.integer :facture_month
      t.integer :facture_year
      t.bool :statut                                     # payee ou non
      t.date :facture_date
      t.timestamps
    end
  end

  def self.down
    drop_table :factures
  end
end
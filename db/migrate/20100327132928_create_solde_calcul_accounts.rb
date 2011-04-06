class CreateSoldeCalculAccounts < ActiveRecord::Migration
  def self.up
    create_table :solde_calcul_accounts do |t|
      t.integer :calcul_account_id
      t.integer :log_calcul_id
      t.integer :credit_id
      t.string  :solde_type
      t.integer :credit_jeton
      t.integer :credit_jeton_tempon
      t.integer :debit_jeton
      t.integer :debit_jeton_tempon
      t.integer :solde_jeton
      t.integer :solde_jeton_tempon
      t.timestamps
    end
  end

  def self.down
    drop_table :solde_calcul_accounts
  end
end

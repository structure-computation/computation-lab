class CreateSoldeTokenAccounts < ActiveRecord::Migration
  def self.up
    create_table :solde_token_accounts do |t|
      t.integer :token_account_id
      t.integer :calcul_result_id
      t.integer :credit_id
      t.string  :solde_type
      t.integer :credit_token
      t.integer :used_token
      t.integer :solde_token
      t.timestamps
    end
  end

  def self.down
    drop_table :solde_token_accounts
  end
end
